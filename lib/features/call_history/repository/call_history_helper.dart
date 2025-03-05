import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/models/call_history.dart';
import 'package:http/http.dart' as http;
import 'package:sep490/models/history_call_request.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:convert';

class CallHistoryHelper {
  static const String _apiUrl =
      'https://api.diavan-valuation.asia/video-call-management';

  static Future<void> saveCallHistory(CallHistory callHistory) async {
    try {
      // Convert CallHistory to API request model
      final request = CallHistoryRequest(
        callerId: int.parse(callHistory.callerId),
        listReceiverId: [int.parse(callHistory.calleeId)],
        duration: callHistory.duration?.inSeconds.toString() ?? '0',
        status: callHistory.callStatus == CallStatus.success,
        isVideo: callHistory.callType == ZegoCallType.videoCall,
      );

      // Send POST request to the API
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      // Check the response status
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 0) {
          print('Failed to save call history: ${responseData['message']}');
        } else {
          print('Call history saved successfully');
        }
      } else {
        print(
            'Failed to save call history. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving call history: $e');
    }
  }
}
