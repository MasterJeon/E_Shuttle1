import 'package:flutter/material.dart';

class navbar extends StatelessWidget {
  const navbar({super.key});

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
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
            onTap: () => print('SOS-Emergency tapped'),
          ),

          ListTile(
            leading: const Icon(Icons.aod_sharp),
            title: const Text('E-Tickets'),
            onTap: () => print('E-Tickets tapped'),
          ),

          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('My Wallet'),
            onTap: () => print('My Wallet tapped'),
          ),

          ListTile(
            leading: const Icon(Icons.account_circle_sharp),
            title: const Text('My Profile'),
            onTap: () => print('My Profile tapped'),
          ),
          Divider(),
          
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Reviews and Feedbacks'),
            onTap: () => print('Reviews and Feedbacks tapped'),
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () => print('Logout tapped'),
          )
        ],
      ),
    );
  }
}