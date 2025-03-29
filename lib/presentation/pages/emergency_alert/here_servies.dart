import 'package:dio/dio.dart';

class HereService {
  static const String apiKey =
      "ssc7HJ2D3isw5gqCLduFMWE4Drrp5Z_Wsu1ZQ20NZtE"; // Thay bằng API Key mới của bạn

  static Future<List<Map<String, dynamic>>> getNearbyHospitals(
      double lat, double lng) async {
    String url =
        "https://discover.search.hereapi.com/v1/discover?at=$lat,$lng&q=hospital&limit=10&apiKey=$apiKey";

    try {
      var response = await Dio().get(url);
      if (response.statusCode == 200) {
        List hospitals = response.data["items"];
        List<Map<String, dynamic>> hospitalList = [];
        for (var hospital in hospitals) {
          double hospitalLat = hospital["position"]["lat"];
          double hospitalLng = hospital["position"]["lng"];

          Map<String, String> address =
              await getAddress(hospitalLat, hospitalLng);

          hospitalList.add({
            "name": hospital["title"] ?? "Không có tên",
            "lat": hospitalLat,
            "lon": hospitalLng,
            "phone": hospital["contacts"]?[0]?["phone"]?[0]?["value"] ??
                "Không có số điện thoại",
            "address":
                address["address"] ?? "Không có dữ liệu",
          });
        }

        return hospitalList;
      }
    } catch (e) {
      print("Lỗi khi lấy danh sách bệnh viện: $e");
    }

    return [];
  }

  static Future<Map<String, String>> getAddress(double lat, double lng) async {
    String url =
        "https://revgeocode.search.hereapi.com/v1/revgeocode?at=$lat,$lng&lang=vi-VN&apiKey=$apiKey";

    try {
      var response = await Dio().get(url);
      if (response.statusCode == 200) {
        var data = response.data;
        if (data["items"] != null && data["items"].isNotEmpty) {
          var address = data["items"][0]["address"];

          return {
            "address": address["label"] ?? "Không có dữ liệu",
          };
        }
      }
    } catch (e) {
      print("Lỗi khi lấy địa chỉ: $e");
    }
    return {"error": "Không thể lấy dữ liệu"};
  }
}
