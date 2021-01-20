import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/screens/splash_screen/splash_screen.dart';
import 'package:body_coach/services/auth.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:body_coach/shared/image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'models/user_profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: Auth().user,
        ),
        ChangeNotifierProvider<AllVideos>.value(
          value: AllVideos(),
        ),
        ChangeNotifierProvider<DOB>.value(
          value: DOB(),
        ),
        ChangeNotifierProvider<ImagePath>.value(
          value: ImagePath(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black87,
          primaryColor: Colors.black,

          accentColor: whiteShad,
          accentColorBrightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
      ),
    );
  }
}