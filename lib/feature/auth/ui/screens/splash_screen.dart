import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_habit_tracker/feature/home/ui/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static final String name = "/";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer( Duration(seconds: 3),()async{
      await Navigator.pushNamedAndRemoveUntil(context, HomeScreen.name, (_)=> false);
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:Colors.blue,
        title: Text("Smart Habit Tracker"),
      ),
      body: Center(
        child: Image.asset("asset/images/splash.png"),
      ),
    );
  }
}
