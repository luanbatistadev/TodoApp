import 'package:flutter/material.dart';
import 'package:tads_design_system/tads_design_system.dart';

class SplashPageMain extends StatelessWidget {
  const SplashPageMain({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: CustomColors.background,
        body: Center(
          child: AspectRatio(
            aspectRatio: 21 / 9,
            child: Image.asset(
              'assets/logo.png',
            ),
          ),
        ),
      ),
    );
  }
}
