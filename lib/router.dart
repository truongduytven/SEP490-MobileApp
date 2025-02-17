import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sep490/common/widgets/error.dart';
import 'package:sep490/presentation/pages/chat/screens/mobile_chat_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // case LoginScreen.routeName:
    //   return MaterialPageRoute(
    //     builder: (context) => const LoginScreen(),
    //   );
    // case OTPScreen.routeName:
    //   final verificationId = settings.arguments as String;
    //   return MaterialPageRoute(
    //     builder: (context) => OTPScreen(
    //       verificationId: verificationId,
    //     ),
    //   );
    // case UserInformationScreen.routeName:
    //   return MaterialPageRoute(
    //     builder: (context) => UserInformationScreen(),
    //   );
    // case SelectContactsScreen.routeName:
    //   return MaterialPageRoute(
    //     builder: (context) => SelectContactsScreen(),
    //   );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments["name"];
      final uid = arguments["uid"];
      final isGroupChat = arguments["isGroupChat"];
      final profilePic = arguments["profilePic"];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
        ),
      );
    // case ConfirmStatusScreen.routeName:
    //   final file = settings.arguments as File;

    //   return MaterialPageRoute(
    //     builder: (context) => ConfirmStatusScreen(
    //       file: file,
    //     ),
    //   );
    // case StatusScreen.routeName:
    //   final status = settings.arguments as Status;

    //   return MaterialPageRoute(
    //     builder: (context) => StatusScreen(
    //       status: status,
    //     ),
    //   );
    // case CreateGroupScreen.routeName:
    //   return MaterialPageRoute(
    //     builder: (context) => CreateGroupScreen(),
    //   );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: "This page doesn't exist"),
        ),
      );
  }
}
