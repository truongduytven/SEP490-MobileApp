import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/group/controller/group_controller.dart';
import 'package:sep490/theme/color.dart';

final isLoadingProvider = StateProvider<bool>((ref) => false);

class ConfirmChangeAvatarGroupChatScreen extends ConsumerWidget {
  static const String routeName = '/confirm-avatar-screen';
  final File file;
  final String groupId;

  const ConfirmChangeAvatarGroupChatScreen({
    Key? key,
    required this.file,
    required this.groupId,
  }) : super(key: key);

  Future<void> changeAvatarGroup(WidgetRef ref, BuildContext context) async {
    final isLoading = ref.read(isLoadingProvider.notifier);
    isLoading.state = true; // Start loading

    bool success =
        await ref.read(groupControllerProvider).changeAvatarGroupChat(
              context,
              groupId,
              file,
            );

    isLoading.state = false; // Stop loading

    if (success) {
      ref.invalidate(groupControllerProvider); // Refresh provider
      Navigator.pop(context, true); 
      print("Đổi ảnh nhóm thành công");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenHeight = MediaQuery.of(context).size.height;
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.file(
              file,
              width: double.infinity,
              height: screenHeight * (2 / 3),
              fit: BoxFit.contain,
            ),
            if (isLoading)
              Container(
                width: double.infinity,
                height: screenHeight * (2 / 3),
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isLoading ? null : () => changeAvatarGroup(ref, context),
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
      ),
    );
  }
}
