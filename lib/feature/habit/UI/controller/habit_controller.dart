import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:smart_habit_tracker/feature/habit/data/model/habit_model.dart';

class HabitController extends GetxController {
  late Box<HabitModel> _habitBox;

  // Reactive habit list
  var habitList = <HabitModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _habitBox = Hive.box<HabitModel>('habits');
    loadHabits();
  }

  void loadHabits() {
    habitList.value = _habitBox.values.toList();
  }

  void addHabit(HabitModel habit) {
    _habitBox.add(habit);
    loadHabits();
  }

  void deleteHabit(int index) {
    _habitBox.deleteAt(index);
    loadHabits();
  }

  void toggleComplete(int index) {
    final habit = habitList[index];
    habit.isCompleted = !habit.isCompleted;
    habit.save();
    loadHabits();
  }

  void updateHabit(int index, HabitModel updatedHabit) {
    _habitBox.putAt(index, updatedHabit);
    loadHabits();
  }

  void clearAll() {
    _habitBox.clear();
    loadHabits();
  }
}
