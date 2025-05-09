import 'package:sep490/models/schedule.dart';
import 'package:sep490/presentation/pages/schedule/Repository/schedule_reponsitory.dart';

class ScheduleController {
  List<Activity>? schedule;
  final ScheduleRepository scheduleRepository = ScheduleRepository();
  bool isCreateSuccess = false;
  bool isUpdateSuccess = false;
  bool isChangeStatusSuccess = false;
  String message = "";

  Future<void> getSchedule(int userId, String day) async {
    final response = await scheduleRepository.getSchedule(userId, day);
    if (response != null && response['isSuccess']) {
      List<dynamic> data = response['data']['data'];
      schedule = data.map((item) => Activity.fromJson(item)).toList();
    } else {
      schedule = null;
    }
  }

  Future<void> createActivity(Map<String, dynamic> activity) async {
    final response = await scheduleRepository.createActivity(activity);
    if (response != null && response['isSuccess']) {
      isCreateSuccess = true;
    } else {
      isCreateSuccess = false;
      message = response != null ? response['data']['message'] : "Có lỗi trong quá trình xử lý!";
    }
  }

  Future<void> updateActivity(Map<String, dynamic> activity) async {
    final response = await scheduleRepository.updateActivity(activity);
    if (response != null && response['isSuccess']) {
      isUpdateSuccess = true;
    } else {
      isUpdateSuccess = false;
    }
  }
  
  Future<void> changeStatusActivity(int activityId, String date) async {
    final response = await scheduleRepository.changeStatusActivity(activityId, date);
    if (response != null && response['isSuccess']) {
      isChangeStatusSuccess = true;
    } else {
      isChangeStatusSuccess = false;
    }
  }
}