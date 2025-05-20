import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeApi {
  // Singleton pattern for StripeApi
  static final StripeApi _instance = StripeApi._internal();
  factory StripeApi() => _instance;
  StripeApi._internal();

  // Initialize Stripe
  Future<void> initializeStripe() async {
    // Load environment variables
    await dotenv.load(fileName: ".env");
    
    // Set the publishable key from .env file
    final publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
    if (publishableKey.isEmpty) {
      throw Exception('Stripe publishable key not found in .env file');
    }
    
    // Initialize Stripe SDK with the publishable key
    Stripe.publishableKey = publishableKey;
  }

  // Get Stripe secret key from .env
  String get _secretKey {
    final key = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
    if (key.isEmpty) {
      throw Exception('Stripe secret key not found in .env file');
    }
    return key;
  }

  // Headers for Stripe API requests
  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_secretKey',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  // Create a payment intent for deposit
  Future<Map<String, dynamic>> createPaymentIntent(double amount, String currency) async {
    try {
      // Convert amount to cents/smallest currency unit as required by Stripe
      final amountInCents = (amount * 100).toInt().toString();
      
      // Create the payment intent with the Stripe API
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: _headers,
        body: {
          'amount': amountInCents,
          'currency': currency,
          'payment_method_types[]': 'card',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }

  // Process a card payment for deposit
  Future<Map<String, dynamic>> processPayment(double amount, {String currency = 'usd'}) async {
    try {
      // Create a payment intent
      final paymentIntent = await createPaymentIntent(amount, currency);
      
      // Confirm the payment with the Stripe SDK
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'Spoon Feed',
          style: ThemeMode.system,
        ),
      );
      
      // Present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();
      
      // If we get here, payment succeeded
      return {
        'success': true,
        'amount': amount,
        'paymentId': paymentIntent['id'],
      };
    } catch (e) {
      if (e is StripeException) {
        return {
          'success': false,
          'error': '${e.error.localizedMessage}',
        };
      } else {
        return {
          'success': false,
          'error': 'Payment failed: $e',
        };
      }
    }
  }

  // Create a payout for withdrawals
  Future<Map<String, dynamic>> createPayout(double amount, {String currency = 'usd'}) async {
    try {
      // In a real app, you would:
      // 1. Have already collected and saved the user's bank account/card details
      // 2. Create a connected account or use Transfer API
      // 3. Process the withdrawal to their bank account
      
      // This is simplified - in production, you'd need to use Stripe Connect
      // For now, we'll simulate a successful withdrawal
      
      // Mock API call - in production, replace with actual Stripe API calls for payouts
      await Future.delayed(const Duration(seconds: 1));
      
      return {
        'success': true,
        'amount': amount,
        'id': 'payout_${DateTime.now().millisecondsSinceEpoch}',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Withdrawal failed: $e',
      };
    }
  }
}