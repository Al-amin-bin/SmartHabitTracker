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
  DateTime? selectedTime;

  final controller = Get.find<HabitController>();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(BuildContext context) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );
    if (picked != null) {
      final nowDate = DateTime.now();
      setState(() {
        selectedTime =
            DateTime(nowDate.year, nowDate.month, nowDate.day, picked.hour, picked.minute);
      });
    }
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final newHabit = HabitModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        createdAt: DateTime.now(),
        reminderTime: selectedTime,
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
        title: const Text('Add New Habit'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
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
                    const Text(
                      "Create a New Habit 🧠",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Habit Title",
                        hintText: "e.g., Morning Exercise",
                        prefixIcon: Icon(Icons.title_rounded, color: Colors.indigo),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a habit title";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        hintText: "Write a short description about your habit...",
                        prefixIcon: Icon(Icons.description_outlined, color: Colors.indigo),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a description";
                        }
                        if (value.length < 5) {
                          return "Description must be at least 5 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Reminder Time
                    ElevatedButton.icon(
                      onPressed: () => _pickTime(context),
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        selectedTime == null
                            ? "Select Reminder Time"
                            : "Reminder: ${TimeOfDay.fromDateTime(selectedTime!).format(context)}",
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveHabit,
                        icon: const Icon(Icons.save_rounded,color: Colors.white,),
                        label: const Text("Save Habit",style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.018),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
