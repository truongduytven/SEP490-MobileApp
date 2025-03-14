import 'package:flutter/material.dart';
import 'package:sep490/common/widgets/error.dart';
import 'package:sep490/features/chat/screens/confirm_avatar_group_screen.dart';
import 'package:sep490/features/chat/screens/mobile_chat_screen.dart';
import 'package:sep490/features/group/screens/create_group_screen.dart';
import 'package:sep490/features/select_contacts/screens/select_contacts_screen.dart';

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
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => SelectContactsScreen(),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments["name"];
      final uid = arguments["uid"];
      final isGroupChat = arguments["isGroupChat"];
      final profilePic = arguments["profilePic"];
      final users = arguments["users"];

      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
            name: name,
            uid: uid,
            isGroupChat: isGroupChat,
            profilePic: profilePic,
            users: users),
      );
    case ConfirmChangeAvatarGroupChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      // final file = settings.arguments as File;

      return MaterialPageRoute(
        builder: (context) => ConfirmChangeAvatarGroupChatScreen(
          file: arguments["file"] as File,
          groupId: arguments["groupId"] as String,
        ),
      );

    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => CreateGroupScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: "This page doesn't exist"),
        ),
      );
  }
}
