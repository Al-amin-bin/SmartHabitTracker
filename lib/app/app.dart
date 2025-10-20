import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_habit_tracker/app/app_route.dart';
import 'package:smart_habit_tracker/app/controller_binders.dart';
import 'package:smart_habit_tracker/feature/auth/ui/screens/splash_screen.dart';

class SmartHabitTracker extends StatelessWidget {
  const SmartHabitTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      title: 'Smart Habit Tracker',
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.name,
      onGenerateRoute: AppRoutes.route,
      initialBinding: ControllerBinders(),
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
    );
  }
}
