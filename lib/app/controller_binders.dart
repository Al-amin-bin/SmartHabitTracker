import 'package:get/get.dart';
import 'package:smart_habit_tracker/feature/habit/UI/controller/habit_controller.dart';

class ControllerBinders extends Bindings{
  void dependencies(){
    Get.put(HabitController());
  }
}