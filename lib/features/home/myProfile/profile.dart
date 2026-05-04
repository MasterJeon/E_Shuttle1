import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({
    super.key,
    this.showAppBar = true,
  });

  /// Set this to false when this screen is used inside another page/navigation.
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: const Text('My Profile'),
              centerTitle: true,
            )
          : null,
      body: const Center(
        child: Text('My Profile'),
      ),
    );
  }
}