import 'package:sep490/models/schedule.dart';
import 'package:sep490/presentation/pages/schedule/Repository/schedule_reponsitory.dart';

class ScheduleController {
  List<Activity>? schedule;
  final ScheduleRepository scheduleRepository = ScheduleRepository();

  Future<void> getSchedule(int userId, String day) async {
    final response = await scheduleRepository.getSchedule(userId, day);
    if (response != null && response['isSuccess']) {
      List<dynamic> data = response['data']['data'];
      schedule = data.map((item) => Activity.fromJson(item)).toList();
    } else {
      schedule = null;
    }
  }
}