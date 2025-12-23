import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/utils/pricing_utils.dart';
import 'package:flutter_boilerplate/utils/premium_access_utils.dart';
import 'package:flutter_boilerplate/services/user_service.dart';
import 'package:flutter_boilerplate/ui/widgets/premium_upgrade_button.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class PaymentHandler {
  static void showPaymentDialog(
    BuildContext context,
    String feature, {
    VoidCallback? onPaymentSuccess,
    VoidCallback? onPaymentCancel,
  }) {
    if (ProjectConfig.appType == AppType.opw) {
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PremiumUpgradeDialog(
        feature: feature,
        onConfirm: () {
          Navigator.of(context).pop();
          _initiateStripePayment(context, feature, onPaymentSuccess);
        },
      ),
    );
  }

  static void _initiateStripePayment(
    BuildContext context,
    String feature,
    VoidCallback? onSuccess,
  ) {
   

  }

  static void _updateUserPaymentStatus(
      Store<AppState> store, String paymentStatus) async {
    
    try {
      final result = await UserService.updateUserPaymentStatus(
        plan: 'Paid', 
        metadata: {
          'updated_via': 'payment_handler',
          'payment_status': paymentStatus,
          'update_date': DateTime.now().toIso8601String(),
        },
      );

      if (result['success'] == true) {
        debugPrint('User payment status updated successfully: $paymentStatus');
        // TODO: Dispatch Redux action to update local state if needed
        // store.dispatch(UpdateUserPaymentStatus(paymentStatus));
      } else {
        debugPrint('Failed to update user payment status: ${result['error']}');
      }
    } catch (e) {
      debugPrint('Error updating user payment status: $e');
    }
  }

  static String _getFeatureDescription(String feature) {
    switch (feature.toLowerCase()) {
      case 'share':
        return 'Event Sharing';
      case 'guest_uploads':
      case 'photos':
        return 'Guest Photo Uploads';
      default:
        return 'Premium Features';
    }
  }

  static void _handlePaymentSuccess(
    BuildContext context,
    String feature,
    VoidCallback? onSuccess,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            SizedBox(width: 8),
            Text('Payment Successful'),
          ],
        ),
        content: Text(
          'Your account has been upgraded to Premium! You can now access ${_getFeatureDescription(feature).toLowerCase()} and all other premium features.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onSuccess?.call();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  static void _handlePaymentError(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
            ),
            SizedBox(width: 8),
            Text('Payment Failed'),
          ],
        ),
        content: Text(
          'Payment could not be completed: $error\n\nPlease try again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static bool shouldTriggerPaymentForShare(AppState state) {
    if (ProjectConfig.appType == AppType.opw) {
      return false;
    }
    return PricingUtils.shouldTriggerPaymentForShare(state);
  }

  static bool shouldTriggerPaymentForGuestUploads(AppState state) {
    if (ProjectConfig.appType == AppType.opw) {
      return false;
    }
    return PricingUtils.shouldTriggerPaymentForGuestUploads(state);
  }

  static bool shouldTriggerPaymentForEventCreation(AppState state, int currentEventCount) {
    if (ProjectConfig.appType == AppType.opw) {
      return false;
    }
    return PricingUtils.shouldTriggerPaymentForEventCreation(state, currentEventCount);
  }

  static void handleShareAction(
    BuildContext context, {
    required VoidCallback onShare,
    VoidCallback? onPaymentSuccess,
  }) async {
    if (ProjectConfig.appType == AppType.opw) {
      onShare();
      return;
    }
    try {
      final hasPremiumAccess = await PremiumAccessUtils.canAccessFeature('share');
      
      if (!context.mounted) return;
      
      if (hasPremiumAccess) {
        onShare();
      } else {
        showPaymentDialog(
          context,
          'share',
          onPaymentSuccess: () {
            onPaymentSuccess?.call();
            onShare();
          },
        );
      }
    } catch (e) {
      debugPrint('Error checking premium access for share: $e');
      
      if (!context.mounted) return;
      
      final store = StoreProvider.of<AppState>(context);
      final state = store.state;
      
      if (shouldTriggerPaymentForShare(state)) {
        showPaymentDialog(
          context,
          'share',
          onPaymentSuccess: () {
            onPaymentSuccess?.call();
            onShare();
          },
        );
      } else {
        onShare();
      }
    }
  }

  static void handlePhotoUploadAction(
    BuildContext context, {
    required VoidCallback onUpload,
    VoidCallback? onPaymentSuccess,
  }) async {
    if (ProjectConfig.appType == AppType.opw) {
      onUpload();
      return;
    }
    try {
      final hasPremiumAccess = await PremiumAccessUtils.canAccessFeature('guest_uploads');
      
      if (!context.mounted) return;
      
      if (hasPremiumAccess) {
        onUpload();
      } else {
        showPaymentDialog(
          context,
          'guest_uploads',
          onPaymentSuccess: () {
            onPaymentSuccess?.call();
            onUpload();
          },
        );
      }
    } catch (e) {
      debugPrint('Error checking premium access for uploads: $e');
      
      if (!context.mounted) return;
      
      final store = StoreProvider.of<AppState>(context);
      final state = store.state;
      
      if (shouldTriggerPaymentForGuestUploads(state)) {
        showPaymentDialog(
          context,
          'guest_uploads',
          onPaymentSuccess: () {
            onPaymentSuccess?.call();
            onUpload();
          },
        );
      } else {
        onUpload();
      }
    }
  }

  static void handleEventCreationAction(
    BuildContext context, {
    required VoidCallback onCreate,
    required int currentEventCount,
    VoidCallback? onPaymentSuccess,
  }) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    if (shouldTriggerPaymentForEventCreation(state, currentEventCount)) {
      showPaymentDialog(
        context,
        'event_creation',
        onPaymentSuccess: () {
          onPaymentSuccess?.call();
          onCreate();
        },
      );
    } else {
      onCreate();
    }
  }
}
