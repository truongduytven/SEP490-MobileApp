import 'package:sep490/models/user_contact.dart';

class GroupResponse {
  final int status;
  final String message;
  final List<GroupMember> data;

  GroupResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GroupResponse.fromJson(Map<String, dynamic> json) {
    return GroupResponse(
      status: json['status'],
      message: json['message'],
      data: List<GroupMember>.from(
          json['data'].map((x) => GroupMember.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'GroupResponse(status: $status, message: $message, data: $data)';
  }
}

class GroupMember {
  final int groupId;
  final String groupName;
  final List<UserContact> members;

  GroupMember({
    required this.groupId,
    required this.groupName,
    required this.members,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      groupId: json['groupId'],
      groupName: json['groupName'],
      members: (json['members'] as List)
          .map((e) => UserContact.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'members': members.map((member) => member.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'GroupMember(groupId: $groupId, groupName: $groupName, members: $members)';
  }
}
