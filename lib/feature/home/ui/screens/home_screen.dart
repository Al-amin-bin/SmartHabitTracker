import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smart_habit_tracker/feature/habit/data/model/habit_model.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String name = '/home';

  @override
  Widget build(BuildContext context) {
    final habitBox = Hive.box<HabitModel>('habits');

    return Scaffold(
      appBar: AppBar(title: const Text('Smart Habit Tracker')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final habit = HabitModel(
              title: 'Morning Walk',
              description: 'Go for a 15 min walk',
              createdAt: DateTime.now(),
            );
            habitBox.add(habit);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Habit Added ✅')),
            );
          },
          child: const Text('Add Habit'),
        ),
      ),
    );
  }
}
