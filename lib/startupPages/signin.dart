import 'package:flutter/material.dart';


void main() => runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainApp(),
    )
  );


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets. symmetric(vertical: 30),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 230, 81, 0),
                const Color.fromRGBO(239, 108, 0, 1),
                const Color.fromRGBO(255, 167, 38, 1)
              ] 
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              SizedBox(height: 50,),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Login", style: TextStyle(color: Colors.white, fontSize: 40),),
                    SizedBox(height: 10,),
                    Text("It's nice to see you again!", style: TextStyle(color: Colors.white, fontSize: 18),),
                  ],
                ),
              ),
              
              SizedBox(height: 20,),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                    color: Colors.white,
                  ),
                  height: double.infinity,
                  width: double.infinity,
            
                  child: Padding(
                    padding: EdgeInsets.all(25), //length of the box
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 50,),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10)
                            )]
                          ),

                          //the Email & password decos
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: const Color.fromRGBO(238, 238, 238, 1)))
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText:"Email or Student ID",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: const Color.fromRGBO(238, 238, 238, 1)))
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText:"Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30,),
                        Text("Forgot Password?", style: TextStyle(color: Colors.grey),),
                        
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
                            child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        ),

                        SizedBox(height: 35,),
                        Text("Don't have an account?", style: TextStyle(color: Colors.grey),),

                        SizedBox(height: 30,),
                        Container(
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: const LinearGradient(
                              colors: [
                                 Color.fromRGBO(230, 81, 0, 1),
                                Color.fromRGBO(239, 108, 0, 1),
                                Color.fromRGBO(255, 167, 38, 1)
                            ]
                              
                          ),
                          ),
                          child: Center(
                            child: Text("Sign up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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