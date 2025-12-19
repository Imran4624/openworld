import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/repositories/firebase_repository.dart';
import 'package:flutter_boilerplate/data/models/serializers.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  const ProductRepository();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseRepository _firebaseRepository =
      FirebaseRepository('products');

  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static const String filterProductsCloudFunctionUrl =
      "Config.CLOUDFUNCTION_FILTERPRODUCTS";

  Future<ProductEntity> loadItem(
      Credentials credentials, String entityId) async {
    final data = await _firebaseRepository.getItem(entityId);

    if (data != null) {
      return serializers.deserializeWith(ProductEntity.serializer, data)!;
    }
    
    logError('Product with ID $entityId not found');
    return ProductEntity(id: entityId);
  }

  Future<Map<String, dynamic>> loadListWithPagination({
    DocumentSnapshot? lastDocument,
    int limit = 10,
    ProductFilter? filter,
  }) async {
    try {
      final queryParams = {
        'limit': limit.toString(),
        if (lastDocument != null) 'lastDocId': lastDocument.id,
      };

      final uri = Uri.parse(filterProductsCloudFunctionUrl).replace(
        queryParameters: queryParams,
      );

      final dynamicFieldsMap = <String, dynamic>{};
      filter?.dynamicFieldsFilters.forEach((key, value) {
        dynamicFieldsMap[key] = value;
      });

      final requestBody = {
        'filters': {
          'dynamicFields': dynamicFieldsMap,
          'state': _getStateFilter(filter),
          'searchTerm': filter?.searchTerm ?? '',
        }
      };

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<ProductEntity> products = [];

        for (final productData in data['products']) {
          final product = ProductEntity().rebuild((b) {
            b.id = productData['id'];
            b.name = productData['name'] ?? '';
            b.isDeleted = productData['is_deleted'] ?? false;
            b.createdAt = productData['created_at'] ?? 0;
            b.updatedAt = productData['updated_at'] ?? 0;
            b.archivedAt = productData['archived_at'] ?? 0;

            if (productData['dynamicFields'] != null) {
              for (final entry
                  in (productData['dynamicFields'] as Map<String, dynamic>)
                      .entries) {
                b.dynamicFields[entry.key] = entry.value;
              }
            }
          });

          products.add(product);
        }

        DocumentSnapshot? newLastDocument;
        if (data['lastDocument'] != null) {
          try {
            final docRef = _firestore
                .collection('products')
                .doc(data['lastDocument']);
            newLastDocument = await docRef.get();
          } catch (e) {
            logError(' Error getting lastDocument: $e');
          }
        }

        return {
          'products': BuiltList<ProductEntity>(products),
          'lastDocument': newLastDocument,
        };
      } else {
        logError(
            ' Cloud Function call failed with status: ${response.statusCode}  Response: ${response.body}');
        return _loadFromFirestoreBasic(
            lastDocument: lastDocument, limit: limit, filter: filter);
      }
    } catch (e) {
      logError(' Error calling Cloud Function: $e');
      return _loadFromFirestoreBasic(
          lastDocument: lastDocument, limit: limit, filter: filter);
    }
  }

  String _getStateFilter(ProductFilter? filter) {
    if (filter == null) return kEntityStateActive;

    switch (filter.stateFilter) {
      case EntityState.active:
        return kEntityStateActive;
      case EntityState.archived:
        return kEntityStateArchived;
      case EntityState.deleted:
        return kEntityStateDeleted;
      default:
        return kEntityStateActive;
    }
  }

  Future<Map<String, dynamic>> loadSingleProduct({
    DocumentSnapshot? lastDocument,
    int limit = 1,
    ProductFilter? filter,
  }) async {
    try {
      final response = await loadListWithPagination(
        lastDocument: lastDocument,
        limit: 1,
        filter: filter,
      );

      final products = response['products'] as BuiltList<ProductEntity>;
      final newLastDocument = response['lastDocument'] as DocumentSnapshot?;
      if (products.isEmpty) {
        snackBarCompleter<void>('No more data available').complete();
      }
      return {
        'product': products.isNotEmpty ? products.first : null,
        'lastDocument': newLastDocument,
      };
    } catch (e) {
      logError(' Error loading single product: $e');
      return {
        'product': null,
        'lastDocument': null,
      };
    }
  }

  Future<Map<String, dynamic>> _loadFromFirestoreBasic({
    DocumentSnapshot? lastDocument,
    int limit = 10,
    ProductFilter? filter,
  }) async {
    try {
      Query query = _firestore.collection('products');

      if (filter != null) {
        switch (filter.stateFilter) {
          case EntityState.active:
            query = query
                .where('archived_at', isEqualTo: 0)
                .where('is_deleted', isEqualTo: false);
            break;
          case EntityState.archived:
            query = query
                .where('archived_at', isGreaterThan: 0)
                .where('is_deleted', isEqualTo: false);
            break;
          case EntityState.deleted:
            query = query.where('is_deleted', isEqualTo: true);
            break;
        }

        if (filter.sortField.isNotEmpty) {
          query = query.orderBy(filter.sortField,
              descending: !filter.sortAscending);
        }
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.limit(limit).get();

      final products = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return ProductEntity().rebuild((b) {
          b.id = doc.id;
          b.name = data['name'] ?? '';
          b.isDeleted = data['is_deleted'] ?? false;
          b.createdAt = data['created_at'] ?? 0;
          b.updatedAt = data['updated_at'] ?? 0;
          b.archivedAt = data['archived_at'] ?? 0;

          if (data['dynamicFields'] != null) {
            for (final entry
                in (data['dynamicFields'] as Map<String, dynamic>).entries) {
              b.dynamicFields[entry.key] = entry.value;
            }
          }
        });
      }).toList();

      return {
        'products': BuiltList<ProductEntity>(products),
        'lastDocument':
            querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null,
      };
    } catch (e) {
      logError(' Error in _loadFromFirestoreBasic: $e');
      rethrow;
    }
  }

  Future<List<ProductEntity>> bulkAction(
      Credentials credentials, List<String> ids, EntityAction action) async {
    if (action == EntityAction.delete) {
      for (var id in ids) {
        final data = {'is_deleted': true};
        await _firebaseRepository.updateItem(id, data);
      }
    } else if (action == EntityAction.archive) {
      final int currentTime = DateTime.now().millisecondsSinceEpoch;
      for (var id in ids) {
        final data = {'archived_at': currentTime};
        await _firebaseRepository.updateItem(id, data);
      }
    } else if (action == EntityAction.restore) {
      for (var id in ids) {
        final data = {'archived_at': 0, 'is_deleted': false};
        await _firebaseRepository.updateItem(id, data);
      }
    } else if (action == EntityAction.purge) {
      await _firebaseRepository.deleteItems(ids);
    }

    return ids.map((id) => ProductEntity(id: id)).toList();
  }

  Future<String> _uploadImageToStorage(
      List<int> imageData, String productId, String imageName) async {
    try {
      final String path = 'products/$productId/images/$imageName';

      final ref = _storage.ref().child(path);

      final UploadTask uploadTask = ref.putData(
        Uint8List.fromList(imageData),
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'productId': productId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      logInfo('Image uploaded successfully');
      return downloadUrl;
    } catch (e) {
      logError(' Error uploading image: $e');
      return '';
    }
  }

  Future<ProductEntity> saveData(
      Credentials credentials, ProductEntity product) async {
    try {
      final dynamicFields =
          Map<String, dynamic>.from(product.dynamicFields.toMap());

      if (dynamicFields.containsKey('images') &&
          dynamicFields['images'] is List) {
        final imagesList = dynamicFields['images'] as List;
        final processedImages = [];

        for (var image in imagesList) {
          if (image is Map &&
              image.containsKey('bytes') &&
              image.containsKey('name')) {
            final bytes = image['bytes'] as List<int>;
            final name = image['name'] as String;
            final type = image['type'] as String?;
            final size = image['size'] as int? ?? bytes.length;
            final action = image['action'] as String?;

            if (action != 'added' || bytes.isEmpty) {
              processedImages.add(image);
              continue;
            }

            final imageUrl =
                await _uploadImageToStorage(bytes, product.id, name);

            processedImages.add({
              'name': name,
              'url': imageUrl,
              'size': size,
              'type': type,
              'action': action
            });
          } else if (image is Map && image.containsKey('url')) {
            processedImages.add(image);
          } else if (image is String && image.startsWith('http')) {
            processedImages.add({
              'url': image,
              'name': _getFileNameFromUrl(image),
              'action': 'existing'
            });
          }
        }

        dynamicFields['images'] = processedImages;
      }

      final productWithoutDynamicFields =
          product.rebuild((b) => b..dynamicFields.clear());

      final data = serializers.serializeWith(
              ProductEntity.serializer, productWithoutDynamicFields)
          as Map<String, dynamic>;

      data['dynamicFields'] = dynamicFields;

      if (product.isNew) {
        final newId =
            _firestore.collection('products').doc().id;
        data['id'] = newId;
        data['name'] =
            dynamicFieldProductNameField(dynamicFields) ?? product.name;
        data['createdAt'] = DateTime.now().millisecondsSinceEpoch;
        data['updatedAt'] = DateTime.now().millisecondsSinceEpoch;
        data['archived_at'] =
            ProjectConfig.defaultNewProductStatus() == kEntityStateActive
                ? 0
                : DateTime.now().millisecondsSinceEpoch;

        await _firebaseRepository.saveItem(newId, data);
        return product.rebuild((b) => b
          ..id = newId
          ..archivedAt = data['archived_at']
          ..dynamicFields.clear()
          ..dynamicFields.addAll(dynamicFields));
      } else {
        data['updatedAt'] = DateTime.now().millisecondsSinceEpoch;
        data['archived_at'] = product.archivedAt;
        data['name'] =
            dynamicFieldProductNameField(dynamicFields) ?? product.name;
        await _firebaseRepository.saveItem(product.id, data);
        return product.rebuild((b) => b
          ..dynamicFields.clear()
          ..dynamicFields.addAll(dynamicFields));
      }
    } catch (e) {
      logError(' Error saving product: $e');
      return product; 
    }
  }

  String _getFileNameFromUrl(String url) {
    try {
      final Uri uri = Uri.parse(url);
      final String path = uri.path;
      final String fileName = path.split('/').last;

      if (fileName.contains('%')) {
        return Uri.decodeComponent(fileName).split('?').first;
      }

      return fileName.split('?').first;
    } catch (e) {
      return 'file_${DateTime.now().millisecondsSinceEpoch}';
    }
  }
}

String? dynamicFieldProductNameField(Map<String, dynamic> dynamicFields) {
  return dynamicFields[DynamicFieldsConstants.name] ??
      dynamicFields['product_name'] ??
      dynamicFields['title'];
}
