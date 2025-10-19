import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_habit_tracker/app/app.dart';

import 'feature/habit/data/model/habit_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(HabitModelAdapter());
  await Hive.openBox<HabitModel>('habits');
  runApp(const SmartHabitTracker());
}
