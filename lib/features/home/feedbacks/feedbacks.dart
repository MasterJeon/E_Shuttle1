import 'package:flutter/material.dart';

class Feedbacks extends StatelessWidget {
  const Feedbacks({
    super.key,
    this.showAppBar = true,
  });

  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: const Text('Reviews and Feedbacks'),
              centerTitle: true,
            )
          : null,
      body: const Center(
        child: Text('Reviews and Feedbacks'),
      ),
    );
  }
}