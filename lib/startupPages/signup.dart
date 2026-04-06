import 'package:flutter/material.dart';


//Not using anymooore

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  )
);

class MyApp extends StatelessWidget {

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
                child:  Padding(
                  padding: const EdgeInsets.only(left: 18.0,right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                            //suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text('Full Name',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Colors.grey,
                            ),)
                        ),
                      ),

                      const TextField(
                        decoration: InputDecoration(
                            //suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text('Registration No. (Staff/Student)',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),)
                        ),
                      ),

                      const TextField(
                        decoration: InputDecoration(
                            //suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text('Email',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),)
                        ),
                      ),

                      const TextField(
                        decoration: InputDecoration(
                            //suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text('Address',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),)
                        ),
                      ),

                      const TextField(
                        decoration: InputDecoration(
                            //suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text('Contact No.',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),)
                        ),
                      ),

                      const TextField(
                        decoration: InputDecoration(
                            //suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text("Guardian's Contact No.",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),)
                        ),
                      ),
                      
                      const TextField(
                        decoration: InputDecoration(
                            //suffixIcon: Icon(Icons.visibility_off,color: Colors.grey,),
                            label: Text('Password',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Colors.grey,
                            ),)
                        ),
                      ),

                      const TextField(
                        decoration: InputDecoration(
                           // suffixIcon: Icon(Icons.visibility_off,color: Colors.grey,),
                            label: Text('Confirm Password',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Colors.grey,
                            ),)
                        ),
                      ),

                       
                        SizedBox(height: 30,),
                        Container(
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                             gradient: const LinearGradient(
                              colors: [
                                 Color.fromRGBO(0, 69, 230, 1),
                                Color.fromRGBO(0, 115, 239, 1),
                                Color.fromRGBO(38, 201, 255, 1)
                            ]
                          ),
                          ),
                          child: Center(
                            child: Text("Sign Up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      );
  }
}