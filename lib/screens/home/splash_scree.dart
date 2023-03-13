import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ratezilla_user/main.dart';
import 'package:ratezilla_user/utils/fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthWrapper()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  "Ratezilla",
                  style: klargefont,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Image(
                image: AssetImage(
                  "assets/images/coinfalling.gif",
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
