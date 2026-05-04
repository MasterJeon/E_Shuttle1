import 'package:e_shuttle/core/constants/app_dimensions.dart';
import 'package:e_shuttle/core/utils/responsive_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({
    super.key,
    this.showAppBar = true,
  });

  /// Set this to false when this screen is used inside bottom navigation.
  final bool showAppBar;

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    final avatarRadius = ResponsiveHelper.value<double>(
      context,
      mobile: 60.0,
      tablet: 72.0,
      large: 84.0,
    );

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('My Profile'),
              centerTitle: true,
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.pagePadding(context),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.maxContentWidth(context),
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppDimensions.md),

                  Text(
                    'My Profile',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.sectionTitleSize(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.lg),

                  // TODO: Replace with actual user profile image from Firebase/storage.
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundImage: const AssetImage('assets/logo.png'),
                  ),

                  const SizedBox(height: AppDimensions.lg),

                  Text(
                    'Sasini Lekamge',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.value<double>(
                        context,
                        mobile: 20.0,
                        tablet: 24.0,
                        large: 28.0,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.xs),

                  Text(
                    'sasinilekamge@gmail.com',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.bodyTextSize(context),
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.xl),

                  _profileTile(
                    title: 'My Information',
                    iconData: CupertinoIcons.person,
                    onTap: () {
                      // TODO: Navigate to my information screen.
                    },
                  ),

                  const SizedBox(height: AppDimensions.sm),

                  _profileTile(
                    title: 'Notifications',
                    iconData: CupertinoIcons.news,
                    onTap: () {
                      // TODO: Navigate to notifications screen.
                    },
                  ),

                  const SizedBox(height: AppDimensions.sm),

                  _profileTile(
                    title: 'Share Live Location',
                    iconData: CupertinoIcons.location,
                    onTap: () {
                      // TODO: Navigate to live location screen.
                    },
                  ),

                  const SizedBox(height: AppDimensions.sm),

                  _profileTile(
                    title: 'Trusted Contacts',
                    iconData: CupertinoIcons.person_2,
                    onTap: () {
                      // TODO: Navigate to trusted contacts screen.
                    },
                  ),

                  const SizedBox(height: AppDimensions.sm),

                  _profileTile(
                    title: 'App Settings',
                    iconData: CupertinoIcons.settings,
                    onTap: () {
                      // TODO: Navigate to app settings screen.
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable profile option tile.
  Widget _profileTile({
    required String title,
    required IconData iconData,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.blue.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        leading: Icon(iconData),
        title: Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveHelper.bodyTextSize(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.grey,
          size: AppDimensions.iconSm,
        ),
      ),
    );
  }
}