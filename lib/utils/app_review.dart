import 'package:in_app_review/in_app_review.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';

class AppReview {
  static final InAppReview inAppReview = InAppReview.instance;

  static Future<bool> isAvailable() async => await inAppReview.isAvailable();

  static void requestReview() => inAppReview.requestReview();

  static void openStoreListing() => inAppReview.openStoreListing(
      appStoreId: isAndroid() ? kPlayStoreAppId : kAppStoreAppId,
      microsoftStoreId: kMicrosoftAppStoreId);
}
