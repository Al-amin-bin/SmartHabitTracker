import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smart_habit_tracker/feature/habit/data/model/habit_model.dart';

import '../../../habit/UI/controller/habit_controller.dart' show HabitController;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String name = '/home';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HabitController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Smart Habit Tracker')),
      body: Obx(() {
        if (controller.habitList.isEmpty) {
          return const Center(child: Text("No habits yet 😴"));
        }
        return ListView.builder(
          itemCount: controller.habitList.length,
          itemBuilder: (context, index) {
            final habit = controller.habitList[index];
            return ListTile(
              title: Text(habit.title),
              subtitle: Text(habit.description),
              trailing: Checkbox(
                value: habit.isCompleted,
                onChanged: (_) => controller.toggleComplete(index),
              ),
              onLongPress: () => controller.deleteHabit(index),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newHabit = HabitModel(
            title: 'New Habit',
            description: 'Example habit added',
            createdAt: DateTime.now(),
          );
          controller.addHabit(newHabit);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
