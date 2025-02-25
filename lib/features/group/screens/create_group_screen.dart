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
  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup() {
    if (groupNameController.text.trim().isNotEmpty) {
      print("vo day");
      ref.read(groupControllerProvider).createGroup(
          context,
          groupNameController.text.trim(),
          image,
          ref.read(
            selectedGroupContacts,
          ));
      ref.read(selectedGroupContacts.state).update((state) => []);

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo mới nhóm'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Stack(
              alignment:
                  Alignment.center, // Centering all children inside the Stack
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
                    color: Colors.black
                        .withOpacity(0.6), // Semi-transparent background
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo,
                        color: Colors.white, size: 28),
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: TextField(
            //     controller: groupNameController,
            //     decoration: InputDecoration(
            //       hintText: "Enter group name",
            //     ),
            //   ),
            // ),
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
              child: const Text(
                "Chọn liên hệ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SelectContactsGroup(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: AppColors.primaryColor,
        child: Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
