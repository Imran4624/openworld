import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> updateUserPaymentStatus({
    required String plan,
    String? priceId,
    String? paymentIntentId,
    DateTime? planExpires,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return {
          'success': false,
          'error': 'User not authenticated',
        };
      }

      final String userId = currentUser.uid;
      final now = DateTime.now();
      
      final expiryDate = planExpires ?? now.add(const Duration(days: 365));

      final updateData = {
        'plan': plan,
        'planUpdatedAt': FieldValue.serverTimestamp(),
        'planExpires': Timestamp.fromDate(expiryDate),
        'isPaymentActive': true,
        'lastPaymentDate': FieldValue.serverTimestamp(),
      };

      if (priceId != null && priceId.isNotEmpty) {
        updateData['lastPriceId'] = priceId;
      }
      
      if (paymentIntentId != null && paymentIntentId.isNotEmpty) {
        updateData['lastPaymentIntentId'] = paymentIntentId;
      }

      if (metadata != null && metadata.isNotEmpty) {
        updateData['paymentMetadata'] = metadata;
      }

      await _firestore.collection(ProjectConfig.usersProfileCollectionName).doc(userId).update(updateData);

      logInfo('User payment status updated successfully for user: $userId');
      logInfo('Plan: $plan, Expires: $expiryDate');

      return {
        'success': true,
        'data': {
          'userId': userId,
          'plan': plan,
          'planExpires': expiryDate.toIso8601String(),
          'updatedAt': now.toIso8601String(),
        },
      };
    } catch (e) {
      logError('Error updating user payment status: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getUserPaymentStatus([String? userId]) async {
    try {
      final String targetUserId = userId ?? FirebaseAuth.instance.currentUser?.uid ?? '';
      
      if (targetUserId.isEmpty) {
        return {
          'success': false,
          'error': 'User ID not provided and no current user',
        };
      }

      final DocumentSnapshot userDoc = await _firestore
          .collection(ProjectConfig.usersProfileCollectionName)
          .doc(targetUserId)
          .get();

      if (!userDoc.exists) {
        return {
          'success': false,
          'error': 'User document not found',
        };
      }

      final userData = userDoc.data() as Map<String, dynamic>? ?? {};
      
      return {
        'success': true,
        'data': {
          'plan': userData['plan'] ?? '',
          'planExpires': userData['planExpires'],
          'isPaymentActive': userData['isPaymentActive'] ?? false,
          'lastPaymentDate': userData['lastPaymentDate'],
          'lastPriceId': userData['lastPriceId'],
          'lastPaymentIntentId': userData['lastPaymentIntentId'],
          'paymentMetadata': userData['paymentMetadata'],
        },
      };
    } catch (e) {
      logError('Error getting user payment status: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  static Future<bool> hasActivePaidPlan([String? userId]) async {
    try {
      final result = await getUserPaymentStatus(userId);
      
      if (result['success'] != true) {
        return false;
      }

      final data = result['data'] as Map<String, dynamic>;
      final plan = data['plan'] as String? ?? '';
      final isPaymentActive = data['isPaymentActive'] as bool? ?? false;
      final planExpires = data['planExpires'] as Timestamp?;

      if (plan.toLowerCase() != 'paid' || !isPaymentActive) {
        return false;
      }

      if (planExpires != null) {
        final expiryDate = planExpires.toDate();
        final now = DateTime.now();
        return now.isBefore(expiryDate);
      }

      return true;
    } catch (e) {
      logError('Error checking user paid plan status: $e');
      return false;
    }
  }
}
