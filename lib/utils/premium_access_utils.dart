import 'package:flutter_boilerplate/services/user_service.dart';

class PremiumAccessUtils {
  
  static Future<bool> hasCurrentUserPremiumAccess() async {
    return await UserService.hasActivePaidPlan();
  }

  static Future<bool> hasUserPremiumAccess(String userId) async {
    return await UserService.hasActivePaidPlan(userId);
  }

  static Future<Map<String, dynamic>> getCurrentUserPremiumDetails() async {
    return await UserService.getUserPaymentStatus();
  }

  static Future<bool> canAccessFeature(String feature) async {
    if (!_isFeaturePremiumOnly(feature)) {
      return true; 
    }

    return await hasCurrentUserPremiumAccess();
  }

  static bool _isFeaturePremiumOnly(String feature) {
    const premiumFeatures = [
      'share',
      'guest_uploads',
      'photos',
      'unlimited_events',
      'qr_code',
      'custom_branding',
    ];
    
    return premiumFeatures.contains(feature.toLowerCase());
  }

  static Future<String> getPremiumStatusMessage() async {
    try {
      final result = await getCurrentUserPremiumDetails();
      
      if (result['success'] != true) {
        return 'Unable to check premium status';
      }

      final data = result['data'] as Map<String, dynamic>;
      final plan = data['plan'] as String? ?? '';
      final isActive = data['isPaymentActive'] as bool? ?? false;
      
      if (plan.toLowerCase() == 'paid' && isActive) {
        return 'Premium Member';
      } else if (plan.toLowerCase() == 'paid' && !isActive) {
        return 'Premium Expired';
      } else {
        return 'Free Plan';
      }
    } catch (e) {
      return 'Unable to check premium status';
    }
  }

  static Future<bool> isPlanExpiringSoon() async {
    try {
      final result = await getCurrentUserPremiumDetails();
      
      if (result['success'] != true) {
        return false;
      }

      final data = result['data'] as Map<String, dynamic>;
      final planExpires = data['planExpires'];
      
      if (planExpires == null) {
        return false; 
      }

      final expiryDate = (planExpires as dynamic).toDate();
      final now = DateTime.now();
      final daysUntilExpiry = expiryDate.difference(now).inDays;
      
      return daysUntilExpiry <= 7 && daysUntilExpiry > 0;
    } catch (e) {
      return false;
    }
  }
}
