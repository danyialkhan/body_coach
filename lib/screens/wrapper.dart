import 'package:body_coach/models/user.dart';
import 'package:body_coach/screens/authentication/landing/landing_screen.dart';
import 'package:body_coach/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return user == null ? LandingScreen() : HomeScreen();
  }
}
