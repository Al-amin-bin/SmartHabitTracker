

import 'package:flutter/material.dart';
import 'package:smart_habit_tracker/feature/auth/ui/screens/splash_screen.dart';
import 'package:smart_habit_tracker/feature/home/ui/screens/home_screen.dart';

class AppRoutes{
  static Route<dynamic> route(RouteSettings settings){
  Widget screenWidget;
  if(settings.name == SplashScreen.name){
    screenWidget = SplashScreen();
  }else if(settings.name == HomeScreen.name){
    screenWidget = HomeScreen();

  }
  else{
    screenWidget = SplashScreen();
  }
  return MaterialPageRoute(builder: (context) => screenWidget);
}
}