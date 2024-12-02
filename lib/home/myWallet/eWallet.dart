import 'package:e_shuttle/home/myWallet/recharge.dart';
import 'package:e_shuttle/home/myWallet/refund.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: EWallet(),
      ),
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
      body: Container(
        // Gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(0, 69, 230, 1),
              Color.fromRGBO(0, 115, 239, 1),
              Color.fromRGBO(38, 201, 255, 1),
            ],
            begin: Alignment.topRight,
            end: Alignment.topLeft,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.05,
                horizontal: screenSize.width * 0.08,
              ),
              child: Column(
                children: [
                  // Wallet Balance Container
                          SizedBox(height: 50),
                          Text(
                            'E-Wallet',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 34),
                          Text(
                            'Total Balance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 18),
                          _isLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  'Rs. ${_walletBalance.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  SizedBox(height: 30),
            // White Box Containing Buttons
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    profileTab(
                      "Recharge Balance",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RechargePage()),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    profileTab(
                      "Refund",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RefundPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileTab(String title, {Widget? trailing, required VoidCallback onTap}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Add internal padding
      margin: EdgeInsets.symmetric(horizontal: 10), // Add margin for spacing
      decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              colors: [
                Color.fromARGB(255, 230, 81, 0),
                Color.fromRGBO(239, 108, 0, 1),
                Color.fromRGBO(255, 167, 38, 1),
              ],
            ), 
          // Green box color
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 20,color: const Color.fromARGB(255, 255, 255, 255)),
          
        ),
        trailing: Icon(Icons.arrow_forward, color: const Color.fromARGB(255, 225, 222, 222)),
        onTap: onTap,
      ),
    );
  }
}
