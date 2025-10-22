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
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.indigo),
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        primarySwatch: Colors.indigo,
      ),
    );
  }
}
