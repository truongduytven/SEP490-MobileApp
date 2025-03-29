import 'package:flutter/material.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/models/call_history.dart';
import 'package:http/http.dart' as http;
import 'package:sep490/models/history_call_request.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:convert';

class CallHistoryHelper {
  static const String _apiUrl =
      'https://api.diavan-valuation.asia/video-call-management';

  static Future<void> saveCallHistory(
      BuildContext context, CallHistory callHistory) async {
    try {
      print("list user ${callHistory.calleeIds}");

      List<int> listReceiverId = callHistory.calleeIds
          .map((id) => int.parse(id)) // Convert each String to int
          .toList();

      final request = CallHistoryRequest(
        callerId: int.parse(callHistory.callerId),
        // listReceiverId: [int.parse(callHistory.calleeId)],
        listReceiverId: listReceiverId,
        duration: callHistory.duration ?? "0 giây",
        status: callHistory.callStatus == CallStatus.success,
        isVideo: callHistory.callType == ZegoCallType.videoCall,
      );
      if (!request.duration.contains("giây") ||
          !request.duration.contains("phút") ||
          !request.duration.contains("giờ")) {
        print("Request duration does not contain 'giây', skipping API call.");
        return;
      }

      print("lịch sử cuộc gọi nè ${request.toString()}");
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
          showSnackBar(
              context: context,
              content: "Lỗi lưu lịch sử cuộc gọi ${responseData['message']}");
          print('Failed to save call history: ${responseData['message']}');
        } else {
          showSnackBar(
              context: context,
              content: "Lưu lịch sử cuộc gọi thành công",
              type: "green");
          print('Call history saved successfully');
        }
      } else {
        showSnackBar(
            context: context,
            content: "Lỗi lưu lịch sử cuộc gọi ${response.statusCode}");

        print(
            'Failed to save call history. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showSnackBar(
          context: context,
          content: "Lỗi lưu lịch sử cuộc gọi ${e.toString()}");
      print('Error saving call history: $e');
    }
  }
}
