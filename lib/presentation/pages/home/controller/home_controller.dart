import 'package:sep490/models/home_model.dart';
import 'package:sep490/presentation/pages/home/repository/home_repository.dart';

class HomeController {
  final HomeRepository _homeRepository = HomeRepository();
  List<HomeHealthIndicator>? homeHealthIndicators;
  List<ElderlyUser>? elderlyUsers;

  Future<void> getHealthIndicator(int account) async {
    final response = await _homeRepository.getHealthIndicator(account);
    if (response != null && response['isSuccess']) {
      List<dynamic> data = response['data']['data'];
      homeHealthIndicators =
          data.map((item) => HomeHealthIndicator.fromJson(item)).toList();
    } else {
      homeHealthIndicators = null;
    }
  }
  
  Future<void> getElderlyUser(int account) async {
    final response = await _homeRepository.getElderlyUser(account);
    if (response != null && response['isSuccess']) {
      List<dynamic> data = response['data']['data'];
      if (data.isNotEmpty) {
        elderlyUsers = (data[0]['members'] as List<dynamic>)
          .map((item) => ElderlyUser.fromJson(item as Map<String, dynamic>))
          .toList();
      } else {
        elderlyUsers = null;
      }
    } else {
      elderlyUsers = null;
    }
  }
}