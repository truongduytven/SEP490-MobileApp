import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

enum CallStatus {
  success,
  declined,
  timedOut,
  canceled,
  busy,
  missed,
}

class CallHistory {
  final String callId;
  final String callerId;
  final List<String> calleeIds;
  final ZegoCallType callType;
  final DateTime startTime;
  final DateTime? endTime;
  final String? duration;
  final CallStatus callStatus; // Add this field

  CallHistory({
    required this.callId,
    required this.callerId,
    required this.calleeIds,
    required this.callType,
    required this.startTime,
    this.endTime,
    this.duration,
    required this.callStatus, // Add this field
  });

  Map<String, dynamic> toMap() {
    return {
      'callId': callId,
      'callerId': callerId,
      'calleeId': calleeIds,
      'callType': callType.toString(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration?.toString(),
      'callStatus': callStatus.toString(), // Add this field
    };
  }

  factory CallHistory.fromMap(Map<String, dynamic> map) {
    return CallHistory(
      callId: map['callId'],
      callerId: map['callerId'],
      calleeIds: List<String>.from(map['calleeIds']),
      callType: ZegoCallType.values
          .firstWhere((e) => e.toString() == map['callType']),
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      duration: map['duration'],
      // map['duration'] != null ? Duration(seconds: map['duration']) : null,
      callStatus: CallStatus.values.firstWhere(
          (e) => e.toString() == map['callStatus']), // Add this field
    );
  }
}
