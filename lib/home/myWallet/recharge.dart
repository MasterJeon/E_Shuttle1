import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 230, 81, 0),
                Color.fromRGBO(239, 108, 0, 1),
                Color.fromRGBO(255, 167, 38, 1),
              ],
            ),
          ),
        ),
      ),
      body: Column(
          children: [
            const SizedBox(height: 10),
            Image.asset(
              'assets/recharge.png', 
              height: 300, 
              width: 300,  
            ),
            Expanded(child: Padding(padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Enter the amount to recharge',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                if (_amountController.text.isNotEmpty) {
                  await makePayment(_amountController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an amount')),
                  );
                }
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 69, 230, 1),
                      Color.fromRGBO(0, 115, 239, 1),
                      Color.fromRGBO(38, 201, 255, 1),
                    ],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Recharge your wallet",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
            ),
          ],
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
      await displayPaymentSheet(context);
    } catch (e, s) {
      print('exception: $e$s');
    }
  }


  Future<void> displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        // After payment is successful, update the wallet balance
        final amount = double.tryParse(_amountController.text) ?? 0.0;
        if (amount > 0) {
          await updateWalletBalance(context, amount);
        }

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



Future<void> updateWalletBalance(BuildContext context, double amount) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User not logged in')),
    );
    return;
  }

  try {
    final userDocRef = FirebaseFirestore.instance.collection('passenger').doc(user.uid);

    // Get the current balance
    final doc = await userDocRef.get();
    if (!doc.exists) {
      print('Document does not exist');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User document does not exist')),
      );
      return;
    }

    final data = doc.data();
    final currentBalance = data?['wallet_balance'] ?? 0.0;
    print('Current Balance: $currentBalance');

    // Ensure currentBalance is a double
    if (currentBalance is! double) {
      print('Current balance is not a double');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid wallet balance format')),
      );
      return;
    }

    // Update the wallet balance
    await userDocRef.update({
      'wallet_balance': currentBalance + amount,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wallet balance updated successfully')),
    );
  } catch (e) {
    print('Error updating wallet balance: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update wallet balance: $e')),
    );
  }
}

