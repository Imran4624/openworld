import 'package:flutter/material.dart';
import 'dart:async';

class WebStripeElements {
  static Widget createStripeElementsWidget() {
    return const SizedBox.shrink();
  }

  static Future<Map<String, dynamic>> extractCardDataForCloudFunction(
      Map<String, dynamic> billingDetails) async {
    return {
      'success': false,
      'error': 'Web-only functionality not available on this platform'
    };
  }

  static bool initializeStripeForWeb(String publishableKey) {
    return false;
  }
}

class StripeElementsWidget extends StatefulWidget {
  const StripeElementsWidget({Key? key}) : super(key: key);

  @override
  State<StripeElementsWidget> createState() => _StripeElementsWidgetState();
}

class _StripeElementsWidgetState extends State<StripeElementsWidget> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
