import 'dart:io';

import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sep490/theme/color.dart';

// void showSnackBar({required BuildContext context, required String content}) {
//   if (context.mounted) {
//     // Check if the widget is still in the tree
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(content),
//         backgroundColor: AppColors.errorColor,
//       ),
//     );
//   }
// }
void showSnackBar(
    {required BuildContext context, required String content, String? type}) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).clearSnackBars(); // Clear previous snackbars
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        backgroundColor: type == "green" ? Colors.green : AppColors.errorColor,
      ),
    );
  }
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickImage != null) {
      image = File(pickImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickVideo = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (pickVideo != null) {
      video = File(pickVideo.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return video;
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
    debugPrint("GIF Picker function started");
    gif = await GiphyPicker.pickGif(
      showPreviewPage: false,
      context: context,
      apiKey: "yBjYxE5qBvwXedy6GtrGGPH8PnVR8jh0",
    );
    debugPrint("GIF selected: $gif");
  } catch (e) {
    debugPrint("Error selecting GIF: ${e.toString()}");
    showSnackBar(context: context, content: e.toString());
  }
  debugPrint("Returning GIF: $gif");
  return gif;
}

String convertDate (String date) {
  // '2025-01-25' to '25/01/2025'
  var dateParts = date.split('-');
  var day = dateParts[2];
  var month = dateParts[1];
  var year = dateParts[0];
  var formattedDate = '$day/$month/$year';
  return formattedDate;
}

String convertTime (String time) {
  // '12:00:00' to '12:00'
  var timeParts = time.split(':');
  var hour = timeParts[0];
  var minute = timeParts[1];
  var formattedTime = '$hour:$minute';
  return formattedTime;
}

String convertDateTime (String dateTime) {
  // '25/02/2025' to '2025-02-25T00:00:00Z'
  var dateParts = dateTime.split('/');
  var day = dateParts[0];
  var month = dateParts[1];
  var year = dateParts[2];
  if (month.length == 1) {
    month = '0$month';
  }
  var formattedDateTime = '$year-$month-$day''T00:00:00Z';
  return formattedDateTime;
}
