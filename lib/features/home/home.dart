import 'package:e_shuttle/features/home/Help.dart';
import 'package:e_shuttle/features/home/SOS/SOS.dart';
import 'package:e_shuttle/features/home/changeRoute.dart';
import 'package:e_shuttle/features/home/e_tickets/scanPay.dart';
import 'package:e_shuttle/features/home/feedbacks/feedbacks.dart';
import 'package:e_shuttle/features/home/myProfile/appSettings.dart';
import 'package:e_shuttle/features/home/myProfile/myProfile.dart';
import 'package:e_shuttle/features/home/myWallet/eWallet.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTab = 0;
  Widget _currentScreen = const HomeContent();
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Sasini Lekamge'),
              accountEmail: const Text('sasini@gmail.com'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(child: Image.asset('images/profile.jpg')),
              ),
              decoration: const BoxDecoration(color: Colors.blueAccent),
            ),
            _drawerTile(Icons.account_circle_sharp, 'My Profile', () => _navigate(MyProfile())),
            _drawerTile(Icons.account_balance_wallet, 'My Wallet', () => _navigate(EWallet())),
            _drawerTile(Icons.settings_rounded, 'Settings', () => _navigate(AppSettings())),
            _drawerTile(Icons.edit_location_alt_rounded, 'Change my Route', () => _navigate(changeRoute())),
            const Divider(),
            _drawerTile(Icons.message, 'Reviews and Feedbacks', () => _navigate(Feedbacks())),
            _drawerTile(Icons.support_agent_sharp, 'Help and Support', () => _navigate(Help_support())),
            _drawerTile(Icons.logout, 'Sign Out', () {}),
          ],
        ),
      ),
      body: PageStorage(bucket: _bucket, child: _currentScreen),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.share_location_sharp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _navButton(Icons.home_rounded, 'Home', 0, const HomeContent()),
                _navButton(Icons.aod_sharp, 'E-Tickets', 1, scanPay()),
              ]),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _navButton(Icons.sos, 'SOS', 2, SOS()),
                _navButton(Icons.account_circle_sharp, 'My Profile', 3, MyProfile()),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  ListTile _drawerTile(IconData icon, String title, VoidCallback onTap) =>
      ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);

  Widget _navButton(IconData icon, String label, int index, Widget screen) =>
      MaterialButton(
        minWidth: 40,
        onPressed: () => setState(() {
          _currentScreen = screen;
          _currentTab = index;
        }),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _currentTab == index ? Colors.blue : Colors.grey),
            Text(label, style: TextStyle(color: _currentTab == index ? Colors.blue : Colors.grey)),
          ],
        ),
      );
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: Text('Home Content'));
}