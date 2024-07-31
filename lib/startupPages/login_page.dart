import 'package:e_shuttle/home/home.dart';
import 'package:e_shuttle/startupPages/signup_page.dart';
import 'package:flutter/material.dart';


import '../../startupPages/signup_page.dart';
import 'package:e_shuttle/services/database_service.dart';
import '../../models/user.dart';

void main() => runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    )
);

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseService _databaseService = DatabaseService();
    final textController1 = TextEditingController();
    final textController2 = TextEditingController();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 230, 81, 0),
              const Color.fromRGBO(239, 108, 0, 1),
              const Color.fromRGBO(255, 167, 38, 1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "It's nice to see you again!",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 50),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromRGBO(238, 238, 238, 1),
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: textController1,
                                decoration: InputDecoration(
                                  hintText: "Email or Student ID",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromRGBO(238, 238, 238, 1),
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: textController2,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            // Handle forgot password
                          },
                          child: Text('Forgot password?', style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        height: 40,
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        child: ElevatedButton(
                          onPressed: () async {
                            String email = textController1.text;
                            String password = textController2.text;

                            // Fetch user from Firestore
                            User? user = await _databaseService.getUserByEmailOrStudentID(email);

                            // Check if user exists and password matches
                            if (user != null && user.password == password) {
                              // Successful login
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Login Success"),
                                  duration: const Duration(seconds: 3),
                                ),
                              );

                              //Navigation to home page
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context)=> HomePage()),
                              );
                            }

                            else {
                              // Login failed
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Invalid email/Student ID or password"),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          },

                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color.fromRGBO(0, 69, 230, 1)),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                            elevation: MaterialStateProperty.all(0),
                          ),

                          child: SizedBox(
                            height: 30,
                            child: Center(
                              child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 35),
                      Text("Don't have an account?", style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 30),
                      Container(
                        height: 40,
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                          },
                          
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color.fromRGBO(230, 81, 0, 1)),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                            elevation: MaterialStateProperty.all(0),
                          ),
                          child: SizedBox(
                            height: 30,
                            child: Center(
                              child: Text("Sign Up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Text("Signup Page"),
      ),
    );
  }
}
