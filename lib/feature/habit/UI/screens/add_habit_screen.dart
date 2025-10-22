import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/habit_model.dart';
import '../controller/habit_controller.dart' show HabitController;

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final controller = Get.find<HabitController>();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final newHabit = HabitModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        createdAt: DateTime.now(),
      );

      controller.addHabit(newHabit);
      Get.back();
      Get.snackbar(
        "Success 🎉",
        "Habit added successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Add New Habit',style: TextStyle(color: Colors.white),),
        elevation: 0,
        backgroundColor: Colors.indigo,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600), // 🧩 For tablet/desktop
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06,
                vertical: size.height * 0.03,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create a New Habit 🧠",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // ---- Title Field ----
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Habit Title",
                        hintText: "e.g., Morning Exercise",
                        prefixIcon:
                        Icon(Icons.title_rounded, color: Colors.indigo),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a habit title";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // ---- Description Field ----
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        hintText:
                        "Write a short description about your habit...",
                        prefixIcon: Icon(Icons.description_outlined,
                            color: Colors.indigo),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a short description";
                        }
                        if (value.length < 5) {
                          return "Description must be at least 5 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 35),

                    // ---- Save Button ----
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.018,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        onPressed: _saveHabit,
                        icon:
                        const Icon(Icons.save_rounded, color: Colors.white),
                        label: const Text(
                          "Save Habit",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
