import 'package:flutter/material.dart';
import 'package:sep490/features/health/widgets/skeleton_list.dart';

class GroupMemberScreen extends StatefulWidget {
  const GroupMemberScreen({super.key});

  @override
  State<GroupMemberScreen> createState() => _GroupMemberScreenState();
}

class _GroupMemberScreenState extends State<GroupMemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Member'),
      ),
      body: Column(
        children: [Text('Group Member Screen')],
      ),
    );
  }
}
