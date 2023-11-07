import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weatherapi/view-model/homepage_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePagescreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset('assets/launcherIcon/news.png'));
  }
}
