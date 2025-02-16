import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/presentation/pages/chat/widgets/contacts_list.dart';
import 'package:sep490/theme/color.dart';
class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print("resumed");
        // ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        // ref.read(authControllerProvider).setUserState(false);
        break;
      default:
        // ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: AppColors.bgColor,
          centerTitle: true,
          title: const Text(
            'Trò chuyện',
            style: TextStyle(
              fontSize: 25,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.secondaryColor),
              onPressed: () {},
            ),
            // IconButton(
            //   icon: const Icon(Icons.more_vert, color: Colors.grey),
            //   onPressed: () {},
            // ),
            PopupMenuButton(
              icon:
                  const Icon(Icons.more_vert, color: AppColors.secondaryColor),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text(
                    "Create Group",
                  ),
                  // onTap: () => Future(
                  //   () => Navigator.pushNamed(
                  //     context,
                  //     CreateGroupScreen.routeName,
                  //   ),
                  // ),
                )
              ],
            )
          ],
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: AppColors.primaryColor,
            indicatorWeight: 4,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.secondaryColor,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: 'Đoạn chat',
              ),
              Tab(
                text: 'Dòng trạng thái',
              ),
              Tab(
                text: 'Lời mời kết bạn',
              ),
            ],
          ),
        ),
        body: TabBarView(controller: tabBarController, children: [
          ContactsList(),
          // StatusContactsScreen(),
          // const Text("COntact list"),
          const Text("Dòng trạng thái"),
          const Text("Lời mời kết bạn"),
        ]),
        floatingActionButton: FloatingActionButton(
          // onPressed: () async {
          //   if (tabBarController.index == 0) {
          //     Navigator.pushNamed(context, SelectContactsScreen.routeName);
          //   } else {
          //     File? pickedImage = await pickImageFromGallery(context);
          //     if (pickedImage != null) {
          //       Navigator.pushNamed(
          //         context,
          //         ConfirmStatusScreen.routeName,
          //         arguments: pickedImage,
          //       );
          //     }
          //   }
          // },
          onPressed: () {},
          backgroundColor: AppColors.primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
