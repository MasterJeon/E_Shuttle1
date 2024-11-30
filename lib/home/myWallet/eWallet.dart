import 'package:e_shuttle/home/myWallet/recharge.dart';
import 'package:e_shuttle/home/myWallet/refund.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EWallet(),
    )
);

class EWallet extends StatefulWidget {
  const EWallet({Key? key}) : super(key: key);

  @override
  EWalletState createState() => EWalletState();
}

class EWalletState extends State<EWallet> {
  double _walletBalance = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWalletBalance();
  }

  Future<void> _fetchWalletBalance() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final userDocRef = FirebaseFirestore.instance.collection('passenger').doc(user.uid);
      final doc = await userDocRef.get();
      if (doc.exists) {
        final data = doc.data();
        setState(() {
          _walletBalance = data?['wallet_balance']?.toDouble() ?? 0.0;
          _isLoading = false;
        });
      } else {
        setState(() {
          _walletBalance = 0.0;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching wallet balance: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        // Set padding relative to screen size
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.05,
          horizontal: screenSize.width * 0.08,
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 77, 157, 255),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'E-Wallet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 34),
                    Text(
                      'Total Balance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 18),
                    _isLoading
                        ? CircularProgressIndicator() // Show a loading spinner while fetching
                        : Text(
                      'Rs. ${_walletBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 96),
            profileTab(
              "Recharge Balance",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RechargePage()),
                );
              },
            ),
            SizedBox(height: 16),
            profileTab("Refund", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RefundPage()),
              );
            }),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget profileTab(String title, {Widget? trailing, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 175, 77),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: const Color.fromARGB(255, 5, 9, 11).withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey),
        tileColor: const Color.fromARGB(255, 255, 255, 255),
        onTap: onTap, // This line ensures the onTap is triggered
      ),
    );
  }
}


