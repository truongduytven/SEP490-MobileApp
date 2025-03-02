import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/features/group/controller/group_controller.dart';
import 'package:sep490/features/group/widgets/select_contacts_group.dart';
import 'package:sep490/theme/color.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-group';
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  File? image;
  bool isLoading = false;
  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup() async {
    final selectedContacts = ref.read(selectedGroupContacts);

    if (groupNameController.text.trim().isEmpty) {
      // Show error if group name is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Vui lòng nhập tên nhóm."),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }

    if (selectedContacts.length < 2) {
      // Show error if less than 2 members selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Nhóm phải có ít nhất 2 thành viên."),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }
    if (image == null) {
      // Check if image is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Vui lòng chọn ảnh nhóm."),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }
    setState(() {
      isLoading = true; // Start loading
    });

    bool success = await ref.read(groupControllerProvider).createGroup(
          context,
          groupNameController.text.trim(),
          image,
          selectedContacts,
        );

    if (success) {
      ref.read(selectedGroupContacts.state).update((state) => []);
      ref.read(selectedGroupIdProvider.state).update((state) => null);
      Navigator.pop(context);
    }

    setState(() {
      isLoading = false; // Stop loading
    });
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Reset selected contacts before leaving
        ref.read(selectedGroupContacts.state).update((state) => []);
        ref.read(selectedGroupIdProvider.state).update((state) => null);
        return true; // Allow back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tạo mới nhóm'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: image == null
                      ? const NetworkImage(
                          "https://i.pinimg.com/736x/44/6d/5d/446d5df6c8837382b80c16b6cde11175.jpg")
                      : FileImage(image!) as ImageProvider,
                  radius: 64,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo,
                        color: Colors.white, size: 30),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: groupNameController,
                decoration: InputDecoration(
                  hintText: "Enter group name",
                  filled: true,
                  fillColor: AppColors.borderColor,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
              child: Column(
                // Change Row to Column to prevent horizontal overflow
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Vui lòng chọn thành viên",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4), // Add some spacing
                  const Text(
                    "*Bạn chỉ được tạo nhóm với những thành viên cùng nhóm gia đình",
                    style: TextStyle(
                      fontSize: 14, // Reduce font size
                      fontWeight: FontWeight.w600,
                      color: AppColors.errorColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  SelectContactsGroup(), // This will take up the remaining height
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: isLoading ? null : createGroup,
          backgroundColor: AppColors.primaryColor,
          child: isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Icon(Icons.done, color: Colors.white),
        ),
      ),
    );
  }
}
