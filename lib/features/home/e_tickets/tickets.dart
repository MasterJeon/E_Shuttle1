import 'package:flutter/material.dart';

class Tickets extends StatelessWidget {
  const Tickets({
    super.key,
    this.showAppBar = true,
  });

  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar(title: const Text('E-Tickets')) : null,
      body: const Center(
        child: Text('E-Tickets'),
      ),
    );
  }
}