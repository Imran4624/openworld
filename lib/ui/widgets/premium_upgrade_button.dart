import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/utils/pricing_utils.dart';

class PremiumUpgradeButton extends StatelessWidget {
  final String feature;
  final String userPlan;
  final VoidCallback? onPaymentInitiated;
  final bool showFullWidth;
  final EdgeInsetsGeometry? margin;

  const PremiumUpgradeButton({
    Key? key,
    required this.feature,
    required this.userPlan,
    this.onPaymentInitiated,
    this.showFullWidth = true,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userPlan.toLowerCase() != "free") {
      return const SizedBox.shrink();
    }

    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      width: showFullWidth ? double.infinity : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getRestrictionMessage(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Upgrade button
          ElevatedButton(
            onPressed: () {
              _handlePaymentInitiation(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: showFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.upgrade, size: 20),
                const SizedBox(width: 8),
                Text(
                  PricingUtils.getPaymentButtonText(feature),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Text(
            PricingUtils.getPaymentDescription(feature),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getRestrictionMessage() {
    switch (feature.toLowerCase()) {
      case 'share':
        return 'Sharing is not enabled in your current plan';
      case 'guest_uploads':
      case 'photos':
        return 'Guest uploads are not enabled in your current plan';
      default:
        return 'This feature is not available in your current plan';
    }
  }

  void _handlePaymentInitiation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PremiumUpgradeDialog(
        feature: feature,
        onConfirm: () {
          Navigator.of(context).pop();
          onPaymentInitiated?.call();
        },
      ),
    );
  }
}

class PremiumUpgradeDialog extends StatelessWidget {
  final String feature;
  final VoidCallback? onConfirm;

  const PremiumUpgradeDialog({
    Key? key,
    required this.feature,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.workspace_premium,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          const Text('Upgrade to Premium'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unlock all premium features for just £${PricingUtils.guestLandingPagePrice.toStringAsFixed(0)}:',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),

          // Features list
          _buildFeatureItem(context, 'Unlimited event creation', Icons.event),
          _buildFeatureItem(
              context, 'Guest photo & video uploads', Icons.cloud_upload),
          _buildFeatureItem(context, 'Event sharing capabilities', Icons.share),
          _buildFeatureItem(context, 'QR code generation', Icons.qr_code),
          _buildFeatureItem(
              context, '12 months of premium access', Icons.schedule),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'One-time payment. No recurring charges.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: Text(
              'Pay £${PricingUtils.guestLandingPagePrice.toStringAsFixed(0)}'),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper widget for inline upgrade prompts
class InlineUpgradePrompt extends StatelessWidget {
  final String feature;
  final String userPlan;
  final VoidCallback? onUpgrade;

  const InlineUpgradePrompt({
    Key? key,
    required this.feature,
    required this.userPlan,
    this.onUpgrade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userPlan.toLowerCase() != "free") {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getPromptMessage(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          TextButton(
            onPressed: onUpgrade,
            child: Text(
              'Upgrade',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPromptMessage() {
    switch (feature.toLowerCase()) {
      case 'share':
        return 'Upgrade to enable sharing';
      case 'guest_uploads':
      case 'photos':
        return 'Upgrade to allow guest uploads';
      default:
        return 'Upgrade to unlock this feature';
    }
  }
}
