import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../data/model/habit_model.dart';
import 'package:timezone/timezone.dart' as tz;

class HabitController extends GetxController {
  final RxList<HabitModel> habits = <HabitModel>[].obs;
  late Box<HabitModel> _habitBox;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    _initHive();
    _initNotification();
  }

  Future<void> _initHive() async {
    _habitBox = await Hive.openBox<HabitModel>('habits');
    habits.assignAll(_habitBox.values.toList());
  }

  Future<void> _initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// 🔹 Add new habit + schedule notification
  void addHabit(HabitModel habit) async {
    final key = await _habitBox.add(habit);
    habits.add(habit);

    if (habit.reminderTime != null) {
      _scheduleDailyNotification(habit, key: key);
    }
  }

  /// 🔹 Update habit + re-schedule notification if time changed
  void updateHabit(int index, HabitModel updatedHabit) async {
    final oldHabit = habits[index];
    await _habitBox.putAt(index, updatedHabit);
    habits[index] = updatedHabit;

    // Cancel old notification
    await flutterLocalNotificationsPlugin.cancel(oldHabit.key);

    // Schedule new notification
    if (updatedHabit.reminderTime != null) {
      _scheduleDailyNotification(updatedHabit, key: updatedHabit.key);
    }
  }

  /// 🔹 Delete habit + cancel notification
  void deleteHabit(int index) async {
    final habit = habits[index];
    await flutterLocalNotificationsPlugin.cancel(habit.key);
    await _habitBox.deleteAt(index);
    habits.removeAt(index);
  }

  /// 🔹 Clear all habits + cancel all notifications
  void clearAll() async {
    for (var habit in habits) {
      await flutterLocalNotificationsPlugin.cancel(habit.key);
    }
    await _habitBox.clear();
    habits.clear();
  }

  /// 🔹 Toggle completion + streak logic
  void toggleCompletion(int index) {
    final habit = habits[index];
    habit.isCompleted = !habit.isCompleted;

    // Streak logic: increase if completed today
    if (habit.isCompleted) {
      final lastCompleted = habit.createdAt;
      final today = DateTime.now();
      if (lastCompleted.year == today.year &&
          lastCompleted.month == today.month &&
          lastCompleted.day == today.day) {
        habit.streak += 1;
      } else {
        habit.streak = 1;
      }
    } else {
      habit.streak = 0;
    }

    habit.save();
    habits[index] = habit;
  }

  /// 🔹 Schedule daily notification (17+ version)
  void _scheduleDailyNotification(HabitModel habit, {required int key}) async {
    if (habit.reminderTime == null) return;

    final now = DateTime.now();
    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      habit.reminderTime!.hour,
      habit.reminderTime!.minute,
    );

    var tzScheduled = tz.TZDateTime.from(scheduledDate, tz.local);

    // If time already passed today, schedule for next day
    if (tzScheduled.isBefore(tz.TZDateTime.now(tz.local))) {
      tzScheduled = tzScheduled.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      key,
      'Habit Reminder ⏰',
      'Time to do your habit: ${habit.title}',
      tzScheduled,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_channel',
          'Habit Reminders',
          channelDescription: 'Reminds you to complete your daily habits',
          importance: Importance.max,
          priority: Priority.high,
          // allowWhileIdle is now handled automatically in v17+
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time, // daily repeat
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // required
    );


  }
}
