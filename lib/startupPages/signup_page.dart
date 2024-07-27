import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:e_shuttle/services/database_service.dart';
import '../../models/user.dart';

void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUp(),
    )
);

class SignUp extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(230, 81, 0, 1),
                Color.fromRGBO(239, 108, 0, 1),
                Color.fromRGBO(255, 167, 38, 1)
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Create Your\nAccount',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        label: Text('Full Name', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )),
                      ),
                    ),

                    const TextField(
                      decoration: InputDecoration(
                        label: Text('Registration No.', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )),
                      ),
                    ),

                    const TextField(
                      decoration: InputDecoration(
                        label: Text('Email', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )),
                      ),
                    ),

                    const TextField(
                      decoration: InputDecoration(
                        label: Text('Address', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )),
                      ),
                    ),

                    const TextField(
                      decoration: InputDecoration(
                        label: Text('Contact No.', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )),
                      ),
                    ),

                    const TextField(
                      decoration: InputDecoration(
                        label: Text("Guardian's Contact No.", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )),
                      ),
                    ),

                    const TextField(
                      decoration: InputDecoration(
                        label: Text('Password', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )),
                      ),
                    ),

                    const TextField(
                      decoration: InputDecoration(
                        label: Text('Confirm Password', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )),
                      ),
                    ),

                    const SizedBox(height: 30,),

                    Container(
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle sign up action
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color.fromRGBO(0, 69, 230, 1)),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        child: const Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
