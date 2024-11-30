import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../global/common/toast.dart';


//not using anymoooore


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;
  final List<Widget> screens = [
    HomeContent(), // Placeholder for home content
    //ScanPay(),
    //SOS(),
    //MyProfile(),
    //EWallet(),
    //Feedbacks(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeContent(); // Placeholder for home content

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Sasini Lekamge'),
              accountEmail: const Text('sasini@gmail.com'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(child: Image.asset('images/profile.jpg')),
              ),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.sos),
              title: const Text('SOS-Emergency'),
              onTap: () {
                //Navigator.push(
                //context,
                //MaterialPageRoute(builder: (context) => SOS()),
                //);
              },
            ),
            ListTile(
              leading: const Icon(Icons.aod_sharp),
              title: const Text('E-Tickets'),
              onTap: () {
                //Navigator.push(
                //context,
                //MaterialPageRoute(builder: (context) => ScanPay()),
                //);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('My Wallet'),
              onTap: () {
                //Navigator.push(
                //context,
                //MaterialPageRoute(builder: (context) => EWallet()),
                //);
                // Implement My Wallet navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle_sharp),
              title: const Text('My Profile'),
              onTap: () {
                //Navigator.push(
                // context,
                //MaterialPageRoute(builder: (context) => MyProfile()),
                //);
              },
            ),
            Divider(),

            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Reviews and Feedbacks'),
              onTap: () {
                //Navigator.push(
                //context,
                //MaterialPageRoute(builder: (context) => Feedbacks()),
                //);
                // Implement Reviews and Feedbacks navigation
              },
            ),




            ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "/login");
                  showToast(message: "Successfully signed out");
                }
            ),
          ],
        ),
      ),

      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      //Middle Navigation Icon
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.share_location_sharp),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = HomeContent(); // Placeholder for home content
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_rounded,
                          color: currentTab == 0 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: currentTab == 0 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        //currentScreen = ScanPay();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.aod_sharp,
                          color: currentTab == 1 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'E-Tickets',
                          style: TextStyle(
                            color: currentTab == 1 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        //currentScreen = SOS();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sos,
                          color: currentTab == 2 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'SOS',
                          style: TextStyle(
                            color: currentTab == 2 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      //setState(() {
                      //  currentScreen = MyProfile();
                      // currentTab = 3;
                      // });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle_sharp,
                          color: currentTab == 3 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'My Profile',
                          style: TextStyle(
                            color: currentTab == 3 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
            ],
          ),
        ),
      ),












    );
  }

  Stream<List<UserModel>> _readData(){
    final userCollection = FirebaseFirestore.instance.collection("users");

    return userCollection.snapshots().map((querySnapshot)
    => querySnapshot.docs.map((e)
    => UserModel.fromSnapshot(e),).toList());
  }

  void _createData(UserModel userModel) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    String id = userCollection.doc().id;

    final newUser = UserModel(
      username: userModel.username,
      age: userModel.age,
      address: userModel.address,
      id: id,
    ).toJson();

    userCollection.doc(id).set(newUser);
  }

  void _updateData(UserModel userModel) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final newData = UserModel(
      username: userModel.username,
      id: userModel.id,
      address: userModel.address,
      age: userModel.age,
    ).toJson();

    userCollection.doc(userModel.id).update(newData);

  }

  void _deleteData(String id) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    userCollection.doc(id).delete();

  }

}

class UserModel{
  final String? username;
  final String? address;
  final int? age;
  final String? id;

  UserModel({this.id,this.username, this.address, this.age});


  static UserModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot){
    final data = snapshot.data()!;
    return UserModel(
      username: data['username'],
      address: data['address'],
      age: data['age'],
      id: snapshot.id,  // Using snapshot.id ensures that the id is correctly handled
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "username": username,
      "age": age,
      "id": id,
      "address": address,  // Use "address" instead of "adress" if that's the correct field name
    };
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Home Content'),
    );
  }
}