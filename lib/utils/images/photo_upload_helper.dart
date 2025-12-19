import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:mime/mime.dart';

class PhotoUploadHelper {
  static Future<List<Map<String, dynamic>>> pickImages(
      {bool allowMultiple = true}) async {
    final List<Map<String, dynamic>> result = [];

    try {
      if (kIsWeb || !Platform.isIOS && !Platform.isAndroid) {
        final FilePickerResult? pickerResult =
            await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: allowMultiple,
          withData: true,
        );

        if (pickerResult != null) {
          for (var file in pickerResult.files) {
            Uint8List? fileBytes;
            String fileName = file.name;
            String? mimeType;

            if (file.bytes != null) {
              fileBytes = file.bytes;
              mimeType = lookupMimeType(fileName, headerBytes: fileBytes);
            } else if (file.path != null) {
              fileBytes = await File(file.path!).readAsBytes();
              mimeType = lookupMimeType(file.path!);
            }

            if (fileBytes != null) {
              result.add({
                'name': fileName,
                'bytes': fileBytes,
                'size': fileBytes.length,
                'type': mimeType ?? 'application/octet-stream',
              });
            }
          }
        }
      } else {
        if (allowMultiple) {
          final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();

          for (var file in pickedFiles) {
            final Uint8List bytes = await file.readAsBytes();
            final mimeType = lookupMimeType(file.name, headerBytes: bytes);

            result.add({
              'name': file.name,
              'bytes': bytes,
              'size': bytes.length,
              'type': mimeType ?? 'image/jpeg',
            });
          }
        } else {
          final XFile? pickedFile = await ImagePicker().pickImage(
            source: ImageSource.gallery,
            imageQuality: 80,
          );

          if (pickedFile != null) {
            final Uint8List bytes = await pickedFile.readAsBytes();
            final mimeType =
                lookupMimeType(pickedFile.name, headerBytes: bytes);

            result.add({
              'name': pickedFile.name,
              'bytes': bytes,
              'size': bytes.length,
              'type': mimeType ?? 'image/jpeg',
            });
          }
        }
      }
    } catch (e) {
      logError(' Error picking images: $e');
    }

    return result;
  }

  static Future<Uint8List?> createThumbnail(Uint8List originalBytes) async {
    return originalBytes;
  }
}
