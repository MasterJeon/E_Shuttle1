import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class RechargePage extends StatefulWidget {
  const RechargePage({Key? key}) : super(key: key);

  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  Map<String, dynamic>? paymentIntent;
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recharge E-Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Enter amount to recharge',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextButton(
              child: const Text('Recharge your wallet'),
              onPressed: () async {
                if (_amountController.text.isNotEmpty) {
                  await makePayment(_amountController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an amount')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'LKR');

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Adnan',
        ),
      );

      // Display the payment sheet
      await displayPaymentSheet();
    } catch (e, s) {
      print('exception: $e$s');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green),
                    Text("Payment Successful"),
                  ],
                ),
              ],
            ),
          ),
        );

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is: --->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Cancelled"),
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_51PmYqFRwXCT02Fy3LMOqWpow9lmmYWaCVd397AQAKVx5evpCMbpTAX1IUgZiF84cfyc96BXlFPysaXHamySmrjJL00p6rvXCrl', // Replace with your actual Secret Key
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('Error charging user: ${err.toString()}');
      return null; // Return null in case of an error
    }
  }

  String calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
