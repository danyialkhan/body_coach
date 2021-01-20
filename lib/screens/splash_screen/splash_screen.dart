import 'dart:async';
import 'package:body_coach/screens/wrapper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  _startTimer() async {
    var duration = Duration(seconds: 4);
    return Timer(duration, _route);
  }

  _route() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => Wrapper(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/icons/BodyCo_Logo_White.png",
              width: MediaQuery.of(context).size.width * 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
