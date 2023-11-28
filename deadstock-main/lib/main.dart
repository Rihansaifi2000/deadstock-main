import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:deadstock/Screens/intro_screen.dart';
import 'package:deadstock/Widgets/bottombar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "DeadStock",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () => checkLogin());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      nextScreen: const IntroScreen(),
      splash: Image.asset('assets/images/logo (1).png'),
      backgroundColor: Colors.white,
      duration: 3000,
      splashIconSize: 180,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.leftToRight,
    );
  }

  checkLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString("UserID");
    if (userID != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const IntroScreen()),
          (route) => false);
    }
  }
}
