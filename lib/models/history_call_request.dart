class CallHistoryRequest {
  final int callerId;
  final List<int> listReceiverId;
  final String duration;
  final bool status;
  final bool isVideo;

  CallHistoryRequest({
    required this.callerId,
    required this.listReceiverId,
    required this.duration,
    required this.status,
    required this.isVideo,
  });

  Map<String, dynamic> toJson() {
    return {
      'callerId': callerId,
      'listReceiverId': listReceiverId,
      'duration': duration,
      'status': status,
      'isVideo': isVideo,
    };
  }
}
