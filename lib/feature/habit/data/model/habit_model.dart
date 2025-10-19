

import 'package:hive_flutter/hive_flutter.dart';
part 'habit_model.g.dart';

@HiveType(typeId: 0)
class HabitModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  int streak;

  @HiveField(5)
  DateTime? reminderTime;

  HabitModel({
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
    this.streak = 0,
    this.reminderTime,
  });
}
