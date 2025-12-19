// Stripe Routes Configuration
// Add these routes to your main route configuration

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/payment/stripe/stripe_connect_screen.dart';
import 'package:flutter_boilerplate/ui/payment/stripe/stripe_payment_screen.dart';
import 'package:flutter_boilerplate/ui/payment/stripe/payment_method_manager_screen.dart';
import 'package:flutter_boilerplate/ui/payment/payment_return_screen.dart';

// Route constants (already defined in respective screens):
// StripeConnectScreen.route = '/stripe_connect'
// StripePaymentScreen.route = '/stripe_payment'
// PaymentMethodManagerScreen.route = '/payment_method_manager'
// PaymentReturnScreen.route = '/payment/return'

// Add these to your route map in main.dart or app_routes.dart:

class StripeRoutes {
  static const String stripeConnect = '/stripe_connect';
  static const String stripePayment = '/stripe_payment';
  static const String paymentMethodManager = '/payment_method_manager';
  static const String paymentReturn = '/payment/return';

  static Map<String, Widget Function(BuildContext)> get routes => {
        stripeConnect: (context) => const StripeConnectScreen(),
        stripePayment: (context) => const StripePaymentScreen(),
        paymentMethodManager: (context) => const PaymentMethodManagerScreen(),
        paymentReturn: (context) => const PaymentReturnScreen(),
      };
}

// Example integration with existing app routes:
/*
class AppRoutes {
  static final Map<String, Widget Function(BuildContext)> routes = {
    // ... your existing routes ...
    
    // Add Stripe routes
    ...StripeRoutes.routes,
    
    // Or add individually:
    StripeConnectScreen.route: (context) => const StripeConnectScreen(),
    StripePaymentScreen.route: (context) => const StripePaymentScreen(),
    PaymentMethodManagerScreen.route: (context) => const PaymentMethodManagerScreen(),
  };
}
*/

// Usage in MaterialApp:
/*
MaterialApp(
  routes: {
    // Your existing routes
    ...AppRoutes.routes,
  },
  // ... other properties
)
*/
