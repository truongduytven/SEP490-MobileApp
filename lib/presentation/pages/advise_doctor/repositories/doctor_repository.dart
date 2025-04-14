import 'dart:convert';
import 'package:http/http.dart' as http;

class DoctorRepository {
  final String baseUrl = 'https://api.diavan-valuation.asia';

  Future<dynamic> getDoctorDataById(int account) async {
    try {
      final response = await http.get(Uri.parse(
          "$baseUrl/api/Professor/elderly/professor/detail/$account"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> getDoctorDetails(int account) async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/api/Professor/$account"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> getPackageUser(int account) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/booking-management/user-booking/$account"));

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> getComboData() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/combo-management"));

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> getAppointmentByID(int account, String type) async {
    try {
      final response = await http.get(Uri.parse(
          "$baseUrl/api/Professor/elderly/schedules/$account?type=$type"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> getReportById(int appointmentId) async {
    try {
      final response = await http.get(Uri.parse(
          "$baseUrl/api/Professor/report/appointment/$appointmentId"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> getTimeSlotById(int accountId, String date) async {
    try {
      final response = await http.get(Uri.parse(
          "$baseUrl/api/Professor/time-slot?professorId=$accountId&date=$date"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> getFilterDoctor(List<String> filterEnter) async {
    Map<String, dynamic> data = handleDataFilter(filterEnter);
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/Professor/filter"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Map<String, dynamic> handleDataFilter(List<String> filterEnter) {
    Map<String, dynamic> data = {
      "nameSortOrder": null,
      "dayOfWeekFilter": [],
      "ratingSortOrder": null
    };
    for (var element in filterEnter) {
      switch (element) {
        case "A-Z":
          data["nameSortOrder"] = "asc";
          break;
        case "Z-A":
          data["nameSortOrder"] = "desc";
          break;
        case "Thứ hai":
          data["dayOfWeekFilter"].add('Monday');
          break;
        case "Thứ ba":
          data["dayOfWeekFilter"].add('Tuesday');
          break;
        case "Thứ tư":
          data["dayOfWeekFilter"].add('Wednesday');
          break;
        case "Thứ năm":
          data["dayOfWeekFilter"].add('Thursday');
          break;
        case "Thứ sáu":
          data["dayOfWeekFilter"].add('Friday');
          break;
        case "Thứ bảy":
          data["dayOfWeekFilter"].add('Saturday');
          break;
        case "Chủ nhật":
          data["dayOfWeekFilter"].add('Sunday');
          break;
        case "Tăng dần":
          data["ratingSortOrder"] = "asc";
          break;
        case "Giảm dần":
          data["ratingSortOrder"] = "desc";
          break;
        default:
          break;
      }
    }
    return data;
  }

  Future<dynamic> checkout(
      int accountId, int elderlyId, int subscriptionId) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/booking-management"),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "accountId": accountId,
            "elderlyId": elderlyId,
            "subscriptionId": subscriptionId
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> checkOrderStatus(String transId) async {
    try {
      final response = await http.get(Uri.parse(
          "$baseUrl/booking-management/order-status?appTransId=$transId"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> confirmCheckout(String transId) async {
    try {
      final response = await http.put(
          Uri.parse("$baseUrl/booking-management/confirm?apptransid=$transId"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> selectDoctor(int professorId, int elderlyId) async {
    try {
      final response = await http.put(
          Uri.parse("$baseUrl/api/Professor/user-subscription-professor"),
          headers: {
            'Content-Type': 'application/json',
          },
          body:
              jsonEncode({"professorId": professorId, "elderlyId": elderlyId}));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> bookingAppointment(
      int elderlyId, String startTime, String endTime, String day, String description) async {
    try {
      final response = await http.post(
          Uri.parse("$baseUrl/api/Professor/professor-appointment"),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "elderlyId": elderlyId,
            "startTime": startTime,
            "endTime": endTime,
            "day": day,
            "description": description
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> cancelAppointment(int appointmentId) async {
    try {
      final response = await http
          .put(Uri.parse("$baseUrl/api/Professor/cancel/$appointmentId"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> ratingDoctor(
      int appointmentId, String content, int star, String createdBy) async {
    try {
      final req = {
        "appointmentId": appointmentId,
        "content": content,
        "star": star,
        "createdBy": createdBy
      };
      final response =
          await http.post(Uri.parse("$baseUrl/api/Professor/feedback"),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode(req));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> reportDoctor(
      int appointmentId, String content, String solution) async {
    try {
      final req = {
        "appointmentId": appointmentId,
        "content": content,
        "solution": solution,
      };
      final response = await http.post(
          Uri.parse("$baseUrl/api/Professor/professor-appointment/report"),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(req));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> getFeedbackDoctor(int professorId) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/api/Professor/feedback/$professorId"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> getNumberMeeting(int elderlyId) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/api/Professor/number-of-meeting/elderly/$elderlyId"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }
}
