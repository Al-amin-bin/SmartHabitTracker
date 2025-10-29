import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smart_habit_tracker/feature/habit/data/model/habit_model.dart';

import '../../../habit/UI/controller/habit_controller.dart' show HabitController;
import '../../../habit/UI/screens/add_habit_screen.dart' show AddHabitScreen;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String name = '/home';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HabitController>();

    return   Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("My Habits 💪"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 2,
      ),
      body: Obx(() {
      if (controller.habits.isEmpty) {
        return const Center(
          child: Text(
            "No habits added yet 😴",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.habits.length,
        itemBuilder: (context, index) {
          final HabitModel habit = controller.habits[index];

          return GestureDetector(
            onTap: () => controller.toggleCompletion(index),
            onLongPress: () => _showEditHabitDialog(context, index, habit, controller),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) {
                final safeValue = value.clamp(0.0, 1.0);
                return Transform.scale(
                  scale: safeValue,
                  child: Opacity(
                    opacity: safeValue,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: habit.isCompleted
                                ? [Colors.greenAccent.shade400, Colors.green.shade600]
                                : [Colors.indigo.shade400, Colors.indigo.shade600],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                value: habit.isCompleted,
                                activeColor: Colors.white,
                                checkColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                onChanged: (_) => controller.toggleCompletion(index),
                              ),
                            ),
                            const SizedBox(width: 12),

                            /// ✅ Habit Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    habit.title,
                                    style: TextStyle(
                                      color: habit.isCompleted
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      decoration: habit.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (habit.description.isNotEmpty)
                                    Text(
                                      habit.description,
                                      style: TextStyle(
                                        color: (habit.isCompleted
                                            ? Colors.black87
                                            : Colors.white.withOpacity(0.85))
                                            .withOpacity(0.9),
                                        fontSize: 13,
                                      ),
                                    ),
                                  const SizedBox(height: 8),

                                  /// 🔥 Streak + Reminder Row
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.local_fire_department_rounded,
                                        color: Colors.orangeAccent,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${habit.streak} day streak",
                                        style: TextStyle(
                                          color: habit.isCompleted
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (habit.reminderTime != null)
                                        Builder(builder: (_) {
                                          final now = DateTime.now();
                                          final reminder = habit.reminderTime!;
                                          final difference =
                                          reminder.difference(now);

                                          String timeText;
                                          Color timeColor;

                                          if (difference.inMinutes > 0) {
                                            final hours = difference.inHours;
                                            final minutes =
                                            difference.inMinutes.remainder(60);
                                            timeText = "in ${hours}h ${minutes}m";
                                            timeColor = Colors.lightGreenAccent;
                                          } else {
                                            timeText = "missed ⏰";
                                            timeColor = Colors.redAccent;
                                          }

                                          return Row(
                                            children: [
                                              const Icon(
                                                Icons.alarm_rounded,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${reminder.hour.toString().padLeft(2, '0')}:${reminder.minute.toString().padLeft(2, '0')} ",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                timeText,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: timeColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    }),



    floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () => Get.to(() => AddHabitScreen()),
        child: const Icon(Icons.add_rounded, size: 30),
      ),

    );
  }
  void _showEditHabitDialog(
      BuildContext context,
      int index,
      HabitModel habit,
      HabitController controller,
      ) {
    final titleController = TextEditingController(text: habit.title);
    final descController = TextEditingController(text: habit.description);
    TimeOfDay? selectedTime = habit.reminderTime != null
        ? TimeOfDay.fromDateTime(habit.reminderTime!)
        : null;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    "Edit Habit ✏️",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Title
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Habit Title",
                    prefixIcon: const Icon(Icons.title_rounded, color: Colors.indigo),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description",
                    prefixIcon: const Icon(Icons.description_outlined, color: Colors.indigo),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Reminder
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime ?? TimeOfDay.now(),
                          );
                          if (picked != null) {
                            selectedTime = picked;
                          }
                        },
                        icon: const Icon(Icons.alarm_rounded, color: Colors.white,),
                        label: Text(
                          selectedTime == null
                              ? "Set Reminder,"
                              : "Reminder: ${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.indigo,
                          side: const BorderSide(color: Colors.indigo),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final updatedHabit = HabitModel(
                            title: titleController.text.trim(),
                            description: descController.text.trim(),
                            createdAt: habit.createdAt,
                            streak: habit.streak,
                            reminderTime: selectedTime != null
                                ? DateTime(
                              habit.createdAt.year,
                              habit.createdAt.month,
                              habit.createdAt.day,
                              selectedTime!.hour,
                              selectedTime!.minute,
                            )
                                : null,
                          );

                          controller.updateHabit(index, updatedHabit);
                          Navigator.pop(context);
                          Get.snackbar(
                            "Updated ✅",
                            "Habit updated successfully!",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}
