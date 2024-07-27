import 'dart:ffi';
import 'package:e_shuttle/home/SOS/SOS.dart';
import 'package:e_shuttle/home/eTickets/scanPay.dart';
import 'package:e_shuttle/home/myProfile/appSettings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class homePage extends StatefulWidget{
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override

  int currentTab = 0;
  final List<Widget> screens = [
    homePage(),
    ScanPay(),
    SOS(),
    MyProfile()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = homePage();

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('home')),
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
        ),

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
              children: <Widget> [
                Row(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = homePage();
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
                                color: currentTab == 0 ? Colors.blue : Colors.grey),
                            ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          

              )
            ],
          ),
        ),
      );
  }
}
  /*int _selectedIndex = 0;

  static final List<Widget> _screens = [
    Container(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'), 
          backgroundColor: Colors.blue,
          ),

          body: _screens[_selectedIndex],

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
                  onTap: (){
                    //go to sos
                    Navigator.pushNamed(context, '/sos');
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.aod_sharp),
                  title: const Text('E-Tickets'),
                  onTap: (){
                    Navigator.pushNamed(context, '/tickets');
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.account_balance_wallet),
                  title: const Text('My Wallet'),
                  onTap: () {
                    Navigator.pushNamed(context,'/wallet');
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.account_circle_sharp),
                  title: const Text('My Profile'),
                  onTap: (){
                    Navigator.pushNamed(context, '/profilePage');
                  },
                ),
                Divider(),
                
                ListTile(
                  leading: const Icon(Icons.message),
                  title: const Text('Reviews and Feedbacks'),
                  onTap: (){
                    Navigator.pushNamed(context, '/feedbacks');
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign Out'),
                  onTap: () => print('Logout tapped'),
                )
              ],
            ),
          ),

          bottomNavigationBar: NavigationBar(
            height: 80,
            elevation:0,
            selectedIndex:0,
            onDestinationSelected:(index)=> ,

            destinations: const[
             NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
             NavigationDestination(icon: Icon(Icons.aod_sharp), label: 'E-Tickets'),
             NavigationDestination(icon: Icon(Icons.sos), label: 'SOS'),
             NavigationDestination(icon: Icon(Icons.notifications_active), label: 'Notifications'), 
            ],
          ),


          //bottomNavigationBar: BottomAppBar(
            //child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              //children: [
                //buildNavBarItem(Icons.home_rounded, 'Home', 0),
                //buildNavBarItem(Icons.aod_sharp, 'E-Tickets', 1),
                //const SizedBox(width:20),
                //buildNavBarItem(Icons.sos, 'SOS', 3),
                //buildNavBarItem(Icons.notifications_active, 'Notifications', 4),
              //],
            //),
          //),

          floatingActionButton: ClipOval(
            child: Material(
              color: Color(0xFF7861FF),
              elevation:10,
              child: InkWell(
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(
                    Icons.share_location_sharp,
                    size:35,
                    color: Colors.white,
                    ),
                  ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, String label,int index){
   return InkWell(
    onTap: () => _onItemTapped(index),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      Icon(
        icon,
        color: _selectedIndex == index ? Color(0xFF7861FF) : Colors.black87,
      ),
      Text(label, style: TextStyle(
        color: _selectedIndex == index ? Color(0xFF) : Colors.black87, ),
      ),
    ],
    ),
   ); 
  }
}*/
