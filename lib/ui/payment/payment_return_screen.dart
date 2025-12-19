import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'web_url_helper.dart'
    if (dart.library.io) 'web_url_helper_stub.dart';

class PaymentReturnScreen extends StatefulWidget {
  const PaymentReturnScreen({super.key});

  static const String route = '/payment/return';

  @override
  _PaymentReturnScreenState createState() => _PaymentReturnScreenState();
}

class _PaymentReturnScreenState extends State<PaymentReturnScreen> {
  @override
  void initState() {
    super.initState();
    _handlePaymentReturn();
  }

  void _handlePaymentReturn() {
    // Extract query parameters from the URL (web only)
    if (kIsWeb) {
      final queryParams = getUrlParameters();
      final redirectStatus = queryParams['redirect_status'];

      // Handle different payment statuses
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (redirectStatus == 'succeeded') {
          _showSuccessDialog();
        } else if (redirectStatus == 'failed') {
          _showFailureDialog();
        } else {
          _showProcessingDialog();
        }
      });
    } else {
      // For mobile apps, show a generic success message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSuccessDialog();
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text('Payment Successful'),
            ],
          ),
          content: const Text(
            'Your payment has been processed successfully. You will be redirected back to the app.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateBack();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 28),
              SizedBox(width: 12),
              Text('Payment Failed'),
            ],
          ),
          content: const Text(
            'Your payment could not be processed. Please try again or contact support if the problem persists.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateBack();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  void _showProcessingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.hourglass_empty, color: Colors.orange, size: 28),
              SizedBox(width: 12),
              Text('Payment Processing'),
            ],
          ),
          content: const Text(
            'Your payment is being processed. Please check your payment status in the app.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateBack();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _navigateBack() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/', 
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Return'),
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Processing payment result...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
