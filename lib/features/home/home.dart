import 'package:e_shuttle/core/constants/app_dimensions.dart';
import 'package:e_shuttle/core/utils/responsive_helper.dart';
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

  static const List<({IconData icon, String label})> _navItems = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.aod_sharp, label: 'E-Tickets'),
    (icon: Icons.sos, label: 'SOS'),
    (icon: Icons.account_circle_sharp, label: 'Profile'),
  ];

  late final List<Widget> _screens = [
    const HomeContent(),
    scanPay(),
    SOS(),
    MyProfile(),
  ];

  void _setTab(int index) {
    setState(() {
      _currentTab = index;
      _currentScreen = _screens[index];
    });
  }

  void _navigate(Widget page) {
    Navigator.pop(context); // closes drawer first
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveHelper.isMobile(context);
    final bool isWideLayout = !isMobile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Shuttle'),
        centerTitle: true,
      ),

      drawer: isMobile ? _buildDrawer(context) : null,

      body: SafeArea(
        child: Row(
          children: [
            if (isWideLayout) _buildNavigationRail(context),

            Expanded(
              child: PageStorage(
                bucket: _bucket,
                child: _currentScreen,
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: connect this to live location/map/change route
        },
        child: Icon(
          Icons.share_location_sharp,
          size: ResponsiveHelper.bottomNavIconSize(context),
        ),
      ),

      floatingActionButtonLocation: isMobile
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: isMobile ? _buildBottomBar(context) : null,
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    return NavigationRail(
      selectedIndex: _currentTab,
      onDestinationSelected: _setTab,
      labelType: NavigationRailLabelType.all,
      minWidth: ResponsiveHelper.value(
        context,
        mobile: 72.0,
        tablet: 90.0,
        large: 110.0,
      ),
      leading: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.drawerAvatarPaddingV,
        ),
        child: CircleAvatar(
          radius: AppDimensions.drawerAvatarRadius,
          child: ClipOval(
            child: Image.asset(
              'images/profile.jpg',
              width: AppDimensions.drawerAvatarRadius * 2,
              height: AppDimensions.drawerAvatarRadius * 2,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.person);
              },
            ),
          ),
        ),
      ),
      destinations: _navItems.map((item) {
        return NavigationRailDestination(
          icon: Icon(
            item.icon,
            size: ResponsiveHelper.bottomNavIconSize(context),
          ),
          label: Text(item.label),
        );
      }).toList(),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: AppDimensions.bottomNavNotchMargin,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool showLabels =
              constraints.maxWidth >= AppDimensions.minLabelWidth;

          return SizedBox(
            height: AppDimensions.bottomNavHeight,
            child: Row(
              children: [
                Expanded(child: _navButton(context, 0, showLabels)),
                Expanded(child: _navButton(context, 1, showLabels)),

                const SizedBox(width: AppDimensions.bottomNavFabGap),

                Expanded(child: _navButton(context, 2, showLabels)),
                Expanded(child: _navButton(context, 3, showLabels)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _navButton(BuildContext context, int index, bool showLabel) {
    final bool isSelected = _currentTab == index;

    return InkWell(
      onTap: () => _setTab(index),
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.xs,
          horizontal: AppDimensions.xs,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _navItems[index].icon,
              size: ResponsiveHelper.bottomNavIconSize(context),
              color: isSelected ? Colors.blue : Colors.grey,
            ),

            if (showLabel) ...[
              const SizedBox(height: AppDimensions.xs),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _navItems[index].label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppDimensions.bottomNavLabelSize,
                    color: isSelected ? Colors.blue : Colors.grey,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Sasini Lekamge'),
              accountEmail: const Text('sasini@gmail.com'),
              currentAccountPicture: CircleAvatar(
                radius: AppDimensions.drawerAvatarRadius,
                child: ClipOval(
                  child: Image.asset(
                    'images/profile.jpg',
                    width: AppDimensions.drawerAvatarRadius * 2,
                    height: AppDimensions.drawerAvatarRadius * 2,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person);
                    },
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
            ),

            _drawerTile(
              icon: Icons.account_circle_sharp,
              title: 'My Profile',
              onTap: () => _navigate(MyProfile()),
            ),

            _drawerTile(
              icon: Icons.account_balance_wallet,
              title: 'My Wallet',
              onTap: () => _navigate(EWallet()),
            ),

            _drawerTile(
              icon: Icons.settings_rounded,
              title: 'Settings',
              onTap: () => _navigate(AppSettings()),
            ),

            _drawerTile(
              icon: Icons.edit_location_alt_rounded,
              title: 'Change my Route',
              onTap: () => _navigate(changeRoute()),
            ),

            const Divider(),

            _drawerTile(
              icon: Icons.message,
              title: 'Reviews and Feedbacks',
              onTap: () => _navigate(Feedbacks()),
            ),

            _drawerTile(
              icon: Icons.support_agent_sharp,
              title: 'Help and Support',
              onTap: () => _navigate(Help_support()),
            ),

            _drawerTile(
              icon: Icons.logout,
              title: 'Sign Out',
              onTap: () {
                Navigator.pop(context);
                // TODO: add Firebase sign out later
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile _drawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.maxContentWidth(context),
        ),
        child: Padding(
          padding: ResponsiveHelper.pagePadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_bus_filled_rounded,
                size: ResponsiveHelper.value(
                  context,
                  mobile: 64.0,
                  tablet: 80.0,
                  large: 96.0,
                ),
                color: Colors.blue,
              ),

              const SizedBox(height: AppDimensions.md),

              Text(
                'Home Content',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.sectionTitleSize(context),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: AppDimensions.sm),

              Text(
                'Welcome to E-Shuttle',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.bodyTextSize(context),
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}