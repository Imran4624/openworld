import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'dart:js' as js;
import 'dart:ui_web' as ui;
import 'dart:html' as html;

import 'package:flutter_boilerplate/ui/app/shared.dart';

class WebStripeElements {
  static Widget createStripeElementsWidget() {
    if (!kIsWeb) {
      return const SizedBox.shrink();
    }
    return const StripeElementsWidget();
  }

  static Future<Map<String, dynamic>> extractCardDataForCloudFunction(
      Map<String, dynamic> billingDetails) async {
    if (!kIsWeb) {
      return {
        'success': false,
        'error': 'Web-only functionality called on non-web platform'
      };
    }

    try {
      final completer = Completer<Map<String, dynamic>>();

      js.context['__flutterPromiseResolver'] = (result) {
        try {
          final resultMap = <String, dynamic>{};
          if (result != null) {
            if (result['paymentMethod'] != null) {
              resultMap['success'] = true;
              resultMap['paymentMethod'] = result['paymentMethod'];
            } else if (result['token'] != null) {
              resultMap['success'] = true;
              resultMap['token'] = result['token'];
            } else {
              resultMap['success'] = result['success'] == true;
              resultMap['error'] = result['error']?.toString();
            }
          } else {
            resultMap['success'] = false;
            resultMap['error'] = 'Null result from JavaScript';
          }
          completer.complete(resultMap);
        } catch (e) {
          completer.complete({
            'success': false,
            'error': 'Error processing result: $e'
          });
        }
      };

      js.context['__flutterPromiseRejector'] = (error) {
        completer.complete({
          'success': false,
          'error': error?.toString() ?? 'Unknown error'
        });
      };

      try {
        final jsPromise = js.context.callMethod('extractCardDataForCloudFunction', [
          js.JsObject.jsify(billingDetails)
        ]);

        jsPromise.callMethod('then', [
          js.allowInterop((result) {
            js.context.callMethod('__flutterPromiseResolver', [result]);
          })
        ]).callMethod('catch', [
          js.allowInterop((error) {
            js.context.callMethod('__flutterPromiseRejector', [error]);
          })
        ]);
      } catch (e) {
        try {
          final jsPromise = js.context.callMethod('createPaymentMethodToken', [
            js.JsObject.jsify(billingDetails)
          ]);

          jsPromise.callMethod('then', [
            js.allowInterop((result) {
              js.context.callMethod('__flutterPromiseResolver', [result]);
            })
          ]).callMethod('catch', [
            js.allowInterop((error) {
              js.context.callMethod('__flutterPromiseRejector', [error]);
            })
          ]);
        } catch (tokenError) {
          completer.complete({
            'success': false,
            'error': 'Error setting up Promise handlers: $e, Token error: $tokenError'
          });
        }
      }

      return await completer.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () => {
          'success': false,
          'error': 'Timeout waiting for payment method creation'
        },
      );
    } catch (e) {
      return {
        'success': false,
        'error': 'Unexpected error: $e'
      };
    }
  }

  static bool initializeStripeForWeb(String publishableKey) {
    if (!kIsWeb) {
      return false;
    }

    try {
      if (js.context['Stripe'] == null) {
        logError('DEBUG: Stripe library not loaded');
        return false;
      }

      final initResult = js.context.callMethod('initializeStripeForWeb', [publishableKey]);
      return initResult == true;
    } catch (e) {
      logError('DEBUG: Error initializing Stripe: $e');
      return false;
    }
  }
}

class StripeElementsWidget extends StatefulWidget {
  const StripeElementsWidget({Key? key}) : super(key: key);

  @override
  State<StripeElementsWidget> createState() => _StripeElementsWidgetState();
}

class _StripeElementsWidgetState extends State<StripeElementsWidget> {
  final String elementId = 'stripe-card-element-${DateTime.now().millisecondsSinceEpoch}';
  final String cardElementId = 'stripe-card-element';

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initializeStripeElement();
    }
  }

  void _initializeStripeElement() {
    if (kIsWeb) {
      ui.platformViewRegistry.registerViewFactory(
        elementId,
        (int viewId) {
          final divElement = html.DivElement()
            ..id = cardElementId
            ..style.width = '100%'
            ..style.height = '50px'
            ..style.padding = '16px'
            ..style.border = '1px solid #ced4da'
            ..style.borderRadius = '8px'
            ..style.backgroundColor = '#ffffff'
            ..style.outline = 'none';

          final errorDiv = html.DivElement()
            ..id = 'stripe-card-element-errors'
            ..style.color = '#fa755a'
            ..style.fontSize = '12px'
            ..style.marginTop = '8px';

          final container = html.DivElement()
            ..style.width = '100%'
            ..style.height = '100%';

          container.children.addAll([divElement, errorDiv]);

          Future.delayed(const Duration(milliseconds: 300), () {
            try {
              final result = js.context.callMethod('createCardElement', [cardElementId]);
              if (result != true) {
                logError('Failed to create Stripe card element: $result');
                errorDiv.text = 'Failed to load payment form. Please refresh and try again.';
              }
            } catch (e) {
              logError('Error creating Stripe card element: $e');
              errorDiv.text = 'Payment form failed to load. Please refresh and try again.';
            }
          });

          return container;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return SizedBox(
        height: 100,
        child: HtmlElementView(viewType: elementId),
      );
    }
    return const SizedBox.shrink();
  }
}
