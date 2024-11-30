import 'dart:ffi';
import 'package:e_shuttle/home/Help.dart';
import 'package:e_shuttle/home/find_shuttle.dart';
import 'package:e_shuttle/home/SOS/SOS.dart';
import 'package:e_shuttle/home/changeRoute.dart';
import 'package:e_shuttle/home/eTickets/scanPay.dart';
import 'package:e_shuttle/home/feedbacks/feedbacks.dart';
import 'package:e_shuttle/home/feedbacks/feedbacks.dart';
import 'package:e_shuttle/home/find_shuttle.dart';
import 'package:e_shuttle/home/myProfile/appSettings.dart';
import 'package:e_shuttle/home/myProfile/myProfile.dart';
import 'package:e_shuttle/home/myProfile/notifi.dart';
import 'package:e_shuttle/home/myWallet/eWallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_shuttle/testingMap/mapfront.dart';

import 'package:e_shuttle/features/user_auth/presentation/pages/login_page.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_shuttle/welcome_pages/splash_screen.dart';
import 'package:e_shuttle/welcome_pages/wScreen1.dart';
import 'package:e_shuttle/welcome_pages/welcomeScreen.dart';
import 'package:e_shuttle/welcome_pages/wScreen2.dart';
import 'package:e_shuttle/welcome_pages/wScreen3.dart';

import '../../../../global/common/toast.dart';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' as io;
import 'package:e_shuttle/home/routemap.dart';
import 'package:e_shuttle/testingMap/livelocation.dart';
import 'package:e_shuttle/testingMap/routetest.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UserProfile> _userProfileFuture;
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(6.81750000, 79.89027778);
  int notificationCount = 3; // Example notification count, replace with actual data

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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  int currentTab = 0;
  final List<Widget> screens = [
    HomeContent(), // Placeholder for home content
    EWallet(),
    AppSettings(),
    MyProfile(),
    Feedbacks(),
    Help_support(),
    ChangeRoute(),
    LiveLocation(),
    MapFront()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  //Widget currentScreen = LiveLocation(); // Placeholder for home content
  Widget currentScreen = MapFront();
  //Widget currentScreen = MyRoute();
  //Widget currentScreen = RouteMapPage();

  Future<bool> _onWillPop() async {
    // Show confirmation dialog
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm'),
        content: Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Exit the app
              Navigator.of(context).pop(true);
              // Use exit() to terminate the app
              io.exit(0);
            },
            child: Text('Exit'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
               appBar: AppBar(
          title: Text('H'),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationsPage()),
                    );
                  },
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: 11,
                    top: 11,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$notificationCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),

    drawer: Drawer(
    child: FutureBuilder<UserProfile>(
    future: _userProfileFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Loading...'),
              accountEmail: const Text('Please wait...'),
              currentAccountPicture: CircleAvatar(
                child: CircularProgressIndicator(),
              ),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
            ),
            // Add other drawer items here if needed
          ],
        );
      }
      if (snapshot.hasError) {
        return Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Error'),
              accountEmail: const Text('Failed to load'),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.error),
              ),
              decoration: BoxDecoration(
                color: Colors.redAccent,
              ),
            ),
            // Add other drawer items here if needed
          ],
        );
      }
      final userProfile = snapshot.data!;
      return Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userProfile.full_name),
            accountEmail: Text(userProfile.email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                //child: userProfile.profilePictureUrl != null
                   // ? Image.network(userProfile.profilePictureUrl!)
                    //: Icon(Icons.person),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
          ),

          ListTile(
            leading: const Icon(Icons.account_circle_sharp),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfile()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('My Wallet'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EWallet()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppSettings()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.edit_location_alt_rounded),
            title: const Text('Change my Route'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangeRoute()),
              );
            },
          ),

          Divider(),

          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Reviews and Feedbacks'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Feedbacks()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.support_agent_sharp),
            //leading: const Icon(Icons.help),
            title: const Text('Help and Support'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Help_support()),
              );
            },
          ),


          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Confirm'),
                      content: Text('Are you sure you want sign out?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Exit the app
                            FirebaseAuth.instance.signOut();
                            Navigator.pushNamed(context, "/login");
                            showToast(message: "Successfully signed out");
                          },
                          child: Text('Sign out'),
                        ),
                      ],
                    ),
                  );
                }
              ),
            ],
          );
        }
      ),
    ),

      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),

      //Middle Navigation Icon
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.share_location_sharp),
        onPressed: () {
         Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShuttleDetailsPage()),
         );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      //Bottom Navigation Bar
          //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                        currentScreen = MapFront();
                        //currentScreen = HomeContent(); // Placeholder for home content
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
                        currentScreen =  scanPay();
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
                        currentScreen = EWallet();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: currentTab == 2 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'E-Wallet',
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
                      setState(() {
                        currentScreen = SOS();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sos,
                          color: currentTab == 3 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'SOS',
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
      ),
    );
  }
}

// Placeholder widget for home content
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        final _HomePageState? state =
        context.findAncestorStateOfType<_HomePageState>();
        if (state != null) {
          state._onMapCreated(controller);
        }
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(6.81750000, 79.89027778),
        zoom: 16.0,
      ),
    );
  }
}

