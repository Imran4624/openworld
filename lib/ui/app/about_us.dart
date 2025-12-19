import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/ui/app/copy_to_clipboard.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  static const String route = '/about-us';

  String _getAppTitle() {
    switch (ProjectConfig.appType) {
      case AppType.cac:
        return 'About Cocktails & Conversation';
      case AppType.mis:
        return 'About MyIslamicSpouse';
      case AppType.lvc:
        return 'About YourLuvCode';
      case AppType.loopjam:
        return 'About Loopjam';
      default:
        return 'About Us';
    }
  }

  String _getAppDescription() {
    switch (ProjectConfig.appType) {
      case AppType.cac:
        return 'Cocktails & Conversation is a curated event and social connection platform for singles who value real-world chemistry.';
      case AppType.mis:
        return 'MyIslamicSpouse is a trusted Islamic matrimonial platform designed to help Muslims find their life partners in accordance with Islamic values and traditions.';
      case AppType.lvc:
        return 'YourLuvCode is a modern dating platform that helps singles find meaningful connections through curated events and a user-friendly app experience.';
      case AppType.loopjam:
        return 'Loopjam is a mobile-first app for sharing photos and videos at real-world events, beginning with weddings. Our focus is providing couples and their guests with a fast, private, and intuitive way to share media during events.';
      default:
        return 'Welcome to our platform designed to connect people and build meaningful relationships.';
    }
  }

  String _getAppDetails() {
    switch (ProjectConfig.appType) {
      case AppType.cac:
        return 'We\'re not a dating app — we believe true connections begin in person. That\'s why we host elegant, thoughtfully curated events where you can meet new people face-to-face. After the event, the app allows you to reconnect with guests you met, continue conversations, and explore meaningful connections in a relaxed, organic way.';
      case AppType.mis:
        return 'Our platform provides a safe, secure, and respectful environment where Muslim singles can connect with potential spouses. We understand the importance of family values, religious compatibility, and cultural understanding in Islamic marriages. Our comprehensive profiles allow you to find someone who shares your faith, values, and life goals.\n\nWith advanced privacy controls and verification features, we ensure that every interaction is meaningful and respectful. Whether you\'re looking for someone from your local community or from around the world, MyIslamicSpouse helps facilitate connections that could lead to blessed and fulfilling marriages, In Sha Allah.';
      case AppType.lvc:
        return 'YourLuvCode is a modern dating platform that helps singles find meaningful connections through curated events and a user-friendly app experience.';
      default:
        return 'Our platform is designed to help you connect with like-minded individuals and build meaningful relationships in a safe and respectful environment.';
    }
  }

  Widget _buildPolicyLinks(BuildContext context) {
    
    if (ProjectConfig.getTermsAndConditionsUrl().isEmpty && ProjectConfig.getPrivacyPolicyUrl().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legal Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if(ProjectConfig.getTermsAndConditionsUrl().isNotEmpty)
          Text.rich(
            TextSpan(
              text: 'By using our services, you agree to our ',
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                if (ProjectConfig.getTermsAndConditionsUrl().isNotEmpty) ...[
                  TextSpan(
                    text: 'Terms of Service',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => launchUrl(Uri.parse(ProjectConfig.getTermsAndConditionsUrl()), mode: LaunchMode.externalApplication),
                  ),
                  if (ProjectConfig.getPrivacyPolicyUrl().isNotEmpty) ...[
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launchUrl(Uri.parse(ProjectConfig.getPrivacyPolicyUrl()), mode: LaunchMode.externalApplication),
                    ),
                  ],
                  const TextSpan(text: '.'),
                ] else if (ProjectConfig.getPrivacyPolicyUrl().isNotEmpty) ...[
                  TextSpan(
                    text: 'Privacy Policy',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => launchUrl(Uri.parse(ProjectConfig.getPrivacyPolicyUrl()), mode: LaunchMode.externalApplication),
                  ),
                  const TextSpan(text: '.'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionInfo(BuildContext context) {
    return FutureBuilder<String>(
      future: getCurrentAppVersion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        final version = snapshot.data ?? '';
        if (version.isEmpty) {
          return const SizedBox.shrink();
        }

        final textStyle = Theme.of(context).textTheme.bodySmall;
        return CopyToClipboard(
          value: version,
          child:Text(
          'Version $version',
          style: textStyle?.copyWith(
            color: textStyle.color?.withOpacity(0.7),
          ),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final appTheme =
        AppTheme.getThemeColors(store.state.prefState.enableDarkMode);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppTitle(),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: appTheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                _getAppDescription(),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _getAppDetails(),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              _buildPolicyLinks(context),
              const SizedBox(height: 32),
              _buildVersionInfo(context),
            ],
          ),
        ),
      ),
    );
  }
}
