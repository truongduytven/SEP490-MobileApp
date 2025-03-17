import 'dart:io';

import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

String convertTimeSession(String time) {
  // 8:00 -> 8:00 AM
  // 20:00 -> 8:00 PM
  if (time == "") return "";
  final timeSplit = time.split(":");
  final hour = int.parse(timeSplit[0]);
  final minute = timeSplit[1];
  if (hour < 12) {
    return "$hour:$minute AM";
  } else {
    return "${hour - 12}:$minute PM";
  }
}

String convertDate(String date) {
  // '2025-01-25' to '25/01/2025'
  var dateParts = date.split('-');
  var day = dateParts[2];
  var month = dateParts[1];
  var year = dateParts[0];
  var formattedDate = '$day/$month/$year';
  return formattedDate;
}

String convertTime(String time) {
  // '12:00:00' to '12:00'
  var timeParts = time.split(':');
  var hour = timeParts[0];
  var minute = timeParts[1];
  var formattedTime = '$hour:$minute';
  return formattedTime;
}

String addDaytoDate(String date, int day) {
  // '25-01-2025' add day day -> '27-01-2025'
  DateFormat format = DateFormat("dd/MM/yyyy");
  DateTime start = format.parse(date);
  DateTime endDate = start.add(Duration(days: day - 1));
  return format.format(endDate);
}

String convertDateTime(String dateTime) {
  // '25/02/2025' to '2025-02-25T00:00:00Z'
  var dateParts = dateTime.split('/');
  var day = dateParts[0];
  var month = dateParts[1];
  var year = dateParts[2];
  if (month.length == 1) {
    month = '0$month';
  }
  if (day.length == 1) {
    day = '0$day';
  }
  var formattedDateTime = '$year-$month-$day' 'T00:00:00.000Z';
  return formattedDateTime;
}

String convertDateTimeToString(String dateTime) {
  // '2025-02-25T03:00:00Z' to '03:00 ngày 25/02/2025'
  var dateParts = dateTime.split('T')[0].split('-');
  var day = dateParts[2];
  var month = dateParts[1];
  var year = dateParts[0];
  var time = dateTime.split('T')[1].split(':');
  var hour = time[0];
  var minute = time[1];
  var formattedDateTime = '$hour:$minute $day/$month/$year';
  return formattedDateTime;
}
