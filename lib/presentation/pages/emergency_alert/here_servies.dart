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

        return hospitals.map((hospital) {
          return {
            "name": hospital["title"] ?? "Không có tên",
            "lat": hospital["position"]["lat"],
            "lon": hospital["position"]["lng"],
            "phone": hospital["contacts"]?[0]?["phone"]?[0]?["value"] ??
                "Không có số điện thoại",
          };
        }).toList();
      }
    } catch (e) {
      print("Lỗi khi lấy danh sách bệnh viện: $e");
    }

    return [];
  }
}
