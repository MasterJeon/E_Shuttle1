import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shuttle/home/myProfile/notifi.dart';
import 'package:e_shuttle/home/myProfile/shareLiveLocation.dart';
import 'package:e_shuttle/home/myProfile/trustedContacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_shuttle/home/myProfile/appSettings.dart';
import 'package:e_shuttle/home/myProfile/myInformation.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  late Future<UserProfile> _userProfileFuture;

  @override
  void initState() {
    super.initState();
    _userProfileFuture = _fetchUserProfile();
  }

  Future<UserProfile> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('passenger') // Your Firestore collection name
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        return UserProfile.fromFirestore(userDoc);
      }
    }
    return UserProfile(full_name: 'N/A', email: 'N/A', routeno: 'N/A');
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'),
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
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.05,
          horizontal: screenSize.width * 0.08,
        ),
        child: FutureBuilder<UserProfile>(
          future: _userProfileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final userProfile = snapshot.data!;
            return Column(
              children: [
                Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('b 3s.jpg'), // Replace with your image asset
                ),
                SizedBox(height: 24),
                Text(
                  userProfile.full_name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  userProfile.email,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 28),
                profileTab(
                  "My Information",
                  CupertinoIcons.person,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyInformation()),
                    );
                  },
                ),
                SizedBox(height: 8),
                profileTab(
                  "Notifications",
                  CupertinoIcons.news,
                  onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationsPage()),
                    );
                  },
                ),
                SizedBox(height: 8),
                profileTab(
                  "Share Live Location",
                  CupertinoIcons.location,
                  onTap: () {
                    Navigator.push(
                     context,
                      MaterialPageRoute(builder: (context) => ShareLiveLocationPage()),
                    );
                  },
                ),
                SizedBox(height: 8),
                profileTab(
                  "Trusted Contacts",
                  CupertinoIcons.person_2,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TrustedContactsPage()),
                    );
                  },
                ),
                SizedBox(height: 8),
                profileTab(
                  "App Settings",
                  CupertinoIcons.settings,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AppSettings()),
                    );
                  },
                ),

                SizedBox(height: 8),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget profileTab(String title, IconData iconData, {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.blue.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey),
        tileColor: Colors.white,
        onTap: onTap,
      ),
    );
  }
}

class UserProfile {
  final String full_name;
  final String email;
  final String routeno;

  UserProfile({required this.full_name, required this.email, required this.routeno});

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      full_name: data['full_name'] ?? 'N/A',
      email: data['email'] ?? 'N/A',
      routeno: data['routeno'] ?? 'N/A',
    );
  }
}
