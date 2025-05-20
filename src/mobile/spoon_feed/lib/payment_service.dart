import 'package:flutter/material.dart';
import 'package:courier_app/stripe_api.dart';

class PaymentService {
  final StripeApi _stripeApi = StripeApi();
  
  // Process a deposit using Stripe
  Future<Map<String, dynamic>> processDeposit(double amount) async {
    try {
      // Call the Stripe API to process the payment
      final result = await _stripeApi.processPayment(amount);
      
      if (result['success']) {
        return {
          'success': true,
          'type': 'Deposit',
          'amount': amount,
          'date': DateTime.now().toString().substring(0, 10),
          'paymentId': result['paymentId'],
        };
      } else {
        return {
          'success': false,
          'error': result['error'] ?? 'Deposit failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Deposit processing error: $e',
      };
    }
  }
  
  // Process a withdrawal using Stripe
  Future<Map<String, dynamic>> processWithdrawal(double amount) async {
    try {
      // Call the Stripe API to process the withdrawal/payout
      final result = await _stripeApi.createPayout(amount);
      
      if (result['success']) {
        return {
          'success': true,
          'type': 'Withdraw',
          'amount': -amount, // Negative amount for withdraw
          'date': DateTime.now().toString().substring(0, 10),
          'payoutId': result['id'],
        };
      } else {
        return {
          'success': false,
          'error': result['error'] ?? 'Withdrawal failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Withdrawal processing error: $e',
      };
    }
  }

  void showPaymentProcessingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Processing payment...'),
            ],
          ),
        );
      },
    );
  }

  // Show error dialog
  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Show success dialog
  void showSuccessDialog(BuildContext context, String type, double amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$type Successful'),
          content: Text('Your $type of \$${amount.toStringAsFixed(2)} was processed successfully.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}