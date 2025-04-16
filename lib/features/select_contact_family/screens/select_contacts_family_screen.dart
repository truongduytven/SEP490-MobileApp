import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/widgets/error.dart';
import 'package:sep490/common/widgets/loader.dart';
import 'package:sep490/features/select_contact_family/controller/select_contact_family_controller.dart';

// Provider to store the search query
final searchQueryProvider = StateProvider<String>((ref) => "");

class SelectContactsFamilyScreen extends ConsumerStatefulWidget {
  const SelectContactsFamilyScreen({super.key});

  @override
  ConsumerState<SelectContactsFamilyScreen> createState() =>
      _SelectContactsFamilyScreenState();
}

class _SelectContactsFamilyScreenState
    extends ConsumerState<SelectContactsFamilyScreen> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chọn liên hệ"),
      ),
      body: ref.watch(getContactsFamilyProvider).when(
            data: (contactList) {
              // Filter contacts based on search query
              final filteredContacts = contactList
                  .where((contact) =>
                      contact.displayName
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      (contact.phones.isNotEmpty &&
                          contact.phones[0].number.contains(searchQuery)))
                  .toList();

              return Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        ref.read(searchQueryProvider.notifier).state = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm liên hệ...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchController.clear();
                                  ref.read(searchQueryProvider.notifier).state =
                                      "";
                                },
                              )
                            : null,
                      ),
                    ),
                  ),

                  // Contact List or "No contact matches"
                  Expanded(
                    child: filteredContacts.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/img/no_contact.webp',
                                width: 200,
                                height: 200,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Không tìm thấy liên hệ ",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: filteredContacts.length,
                            itemBuilder: (context, index) {
                              final contact = filteredContacts[index];
                              return InkWell(
                                onTap: () => ref
                                    .read(selectContactFamilyControllerProvider)
                                    .selectContact(contact, context),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 8.0),
                                  child: ListTile(
                                    title: Text(
                                      contact.displayName,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    subtitle: Text(
                                      contact.phones.isNotEmpty
                                          ? contact.phones[0].number
                                          : "Không có số điện thoại",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    leading: contact.photo == null
                                        ? const CircleAvatar(
                                            radius: 30,
                                            child: Icon(Icons.person),
                                          )
                                        : CircleAvatar(
                                            backgroundImage:
                                                MemoryImage(contact.photo!),
                                            radius: 30,
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
