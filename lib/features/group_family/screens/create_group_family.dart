// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:cherry_toast/cherry_toast.dart';
// import 'package:sep490/theme/color.dart';

// class CreateGroupFamily extends StatefulWidget {
//   final int currentUserAccountID;

//   const CreateGroupFamily({super.key, required this.currentUserAccountID});

//   @override
//   State<CreateGroupFamily> createState() => _CreateGroupFamilyState();
// }

// class _CreateGroupFamilyState extends State<CreateGroupFamily> {
//   final TextEditingController _groupNameController = TextEditingController();
//   bool _isCreating = false;
//   bool _isLoadingMembers = false;
//   List<Map<String, dynamic>> _availableMembers = [];
//   final List<int> _selectedMembers = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadAvailableMembers();
//   }

//   @override
//   void dispose() {
//     _groupNameController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadAvailableMembers() async {
//     setState(() => _isLoadingMembers = true);
//     try {
//       final response = await http.get(Uri.parse(
//           'https://api.diavan-valuation.asia/groups/relationship-information/member-not-in-group/family-member/${widget.currentUserAccountID}'));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 1 && data['data'] != null) {
//           setState(() {
//             _availableMembers = List<Map<String, dynamic>>.from(data['data']);
//           });
//         } else {
//           CherryToast.error(
//             title: Text(data['message'] ?? 'Không có thành viên nào để thêm'),
//           ).show(context);
//         }
//       } else {
//         throw Exception('Failed to load members: ${response.statusCode}');
//       }
//     } catch (e) {
//       CherryToast.error(
//         title: Text('Lỗi: ${e.toString()}'),
//       ).show(context);
//     } finally {
//       if (mounted) setState(() => _isLoadingMembers = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tạo nhóm gia đình mới'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _groupNameController,
//               decoration: InputDecoration(
//                 labelStyle:
//                     TextStyle(color: AppColors.primaryColor.withOpacity(0.6)),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: AppColors.primaryColor),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide:
//                       BorderSide(color: AppColors.primaryColor, width: 2),
//                 ),
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 labelText: 'Tên nhóm',
//                 prefixIcon: const Icon(
//                   Icons.group,
//                   color: AppColors.primaryColor,
//                 ),
//               ),
//               maxLength: 50,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Chọn thành viên:',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             _buildMembersList(),
//             const SizedBox(height: 20),
//             _isCreating
//                 ? const Center(child: CircularProgressIndicator())
//                 : ElevatedButton.icon(
//                     icon: const Icon(
//                       Icons.create,
//                       color: AppColors.primaryColor,
//                     ),
//                     label: const Text(
//                       'Tạo nhóm',
//                       style: TextStyle(
//                         color: AppColors.primaryColor,
//                       ),
//                     ),
//                     onPressed: () async {
//                       if (_groupNameController.text.trim().isEmpty) {
//                         CherryToast.error(
//                           title: const Text('Vui lòng nhập tên nhóm'),
//                         ).show(context);
//                         return;
//                       }
//                       await _createGroup();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMembersList() {
//     if (_isLoadingMembers) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_availableMembers.isEmpty) {
//       return const Center(
//         child: Column(
//           children: [
//             Icon(Icons.group_off, size: 50, color: Colors.grey),
//             SizedBox(height: 8),
//             Text('Không có thành viên nào để thêm'),
//           ],
//         ),
//       );
//     }

//     return Expanded(
//       child: ListView.builder(
//         itemCount: _availableMembers.length,
//         itemBuilder: (context, index) {
//           final member = _availableMembers[index];
//           final isSelected = _selectedMembers.contains(member['accountId']);
//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 4),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundImage: NetworkImage(member['avatar'] ?? ''),
//                 child:
//                     member['avatar'] == null ? const Icon(Icons.person) : null,
//               ),
//               title: Text(member['fullName'] ?? 'Không có tên'),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(member['phoneNumber'] ?? ''),
//                   if (member['dateOfBirth'] != null)
//                     Text(
//                       'Năm sinh: ${DateTime.parse(member['dateOfBirth']).year}',
//                       style: const TextStyle(fontSize: 12),
//                     ),
//                 ],
//               ),
//               trailing: Checkbox(
//                 activeColor: AppColors.primaryColor,
//                 value: isSelected,
//                 onChanged: (value) {
//                   setState(() {
//                     if (value == true) {
//                       _selectedMembers.add(member['accountId']);
//                     } else {
//                       _selectedMembers.remove(member['accountId']);
//                     }
//                   });
//                 },
//               ),
//               onTap: () {
//                 setState(() {
//                   if (_selectedMembers.contains(member['accountId'])) {
//                     _selectedMembers.remove(member['accountId']);
//                   } else {
//                     _selectedMembers.add(member['accountId']);
//                   }
//                 });
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<void> _createGroup() async {
//     setState(() => _isCreating = true);
//     try {
//       // First create the group
//       final createResponse = await http.post(
//         Uri.parse('https://api.diavan-valuation.asia/groups'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'groupName': _groupNameController.text.trim(),
//           'createdBy': widget.currentUserAccountID,
//         }),
//       );

//       if (createResponse.statusCode == 200) {
//         final createData = json.decode(createResponse.body);
//         if (createData['status'] == 1) {
//           CherryToast.success(
//             title: const Text('Tạo nhóm thành công'),
//           ).show(context);
//           Navigator.pop(context, true);
//         } else {
//           CherryToast.error(
//             title: Text(createData['message'] ?? 'Tạo nhóm thất bại'),
//           ).show(context);
//         }
//       } else {
//         throw Exception('Failed with status ${createResponse.statusCode}');
//       }
//     } catch (e) {
//       CherryToast.error(
//         title: Text('Lỗi: ${e.toString()}'),
//       ).show(context);
//     } finally {
//       if (mounted) setState(() => _isCreating = false);
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:sep490/theme/color.dart';

class CreateGroupFamily extends StatefulWidget {
  final int currentUserAccountID;

  const CreateGroupFamily({super.key, required this.currentUserAccountID});

  @override
  State<CreateGroupFamily> createState() => _CreateGroupFamilyState();
}

class _CreateGroupFamilyState extends State<CreateGroupFamily> {
  final TextEditingController _groupNameController = TextEditingController();
  bool _isCreating = false;
  bool _isLoadingMembers = false;
  List<Map<String, dynamic>> _availableMembers = [];
  final List<int> _selectedMembers = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableMembers();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailableMembers() async {
    setState(() => _isLoadingMembers = true);
    try {
      final response = await http.get(Uri.parse(
          'https://api.diavan-valuation.asia/groups/relationship-information/member-not-in-group/family-member/${widget.currentUserAccountID}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1 && data['data'] != null) {
          setState(() {
            _availableMembers = List<Map<String, dynamic>>.from(data['data']);
          });
        } else {
          CherryToast.error(
            title: Text(data['message'] ?? 'Không có thành viên nào để thêm'),
          ).show(context);
        }
      } else {
        throw Exception('Failed to load members: ${response.statusCode}');
      }
    } catch (e) {
      CherryToast.error(
        title: Text('Lỗi: ${e.toString()}'),
      ).show(context);
    } finally {
      if (mounted) setState(() => _isLoadingMembers = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo nhóm gia đình mới'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group Name Input
              TextField(
                controller: _groupNameController,
                decoration: InputDecoration(
                  labelText: 'Tên nhóm',
                  labelStyle: TextStyle(
                    color: AppColors.primaryColor.withOpacity(0.8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor.withOpacity(0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.group,
                    color: AppColors.primaryColor,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                maxLength: 50,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Members Section
              const Text(
                'Chọn thành viên:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Chỉ được tạo nhóm khi tất cả thành viên có mối quan hệ gia đình',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_selectedMembers.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Đã chọn ${_selectedMembers.length} thành viên',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              _buildMembersList(),
              const SizedBox(height: 20),

              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isCreating
                      ? null
                      : () async {
                          if (_groupNameController.text.trim().isEmpty) {
                            CherryToast.error(
                              title: const Text('Vui lòng nhập tên nhóm'),
                            ).show(context);
                            return;
                          }
                          if (_selectedMembers.isEmpty) {
                            CherryToast.error(
                              title: const Text(
                                  'Vui lòng chọn ít nhất một thành viên'),
                            ).show(context);
                            return;
                          }
                          await _createGroup();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: _isCreating
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'TẠO NHÓM',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembersList() {
    if (_isLoadingMembers) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        ),
      );
    }

    if (_availableMembers.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.group_off,
              size: 50,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'Không có thành viên nào để thêm',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loadAvailableMembers,
              child: Text(
                'Thử lại',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _availableMembers.length,
        itemBuilder: (context, index) {
          final member = _availableMembers[index];
          final isSelected = _selectedMembers.contains(member['accountId']);
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor
                    : Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                backgroundImage: member['avatar'] != null
                    ? NetworkImage(member['avatar'])
                    : null,
                child: member['avatar'] == null
                    ? Icon(
                        Icons.person,
                        color: AppColors.primaryColor,
                      )
                    : null,
              ),
              title: Text(
                member['fullName'] ?? 'Không có tên',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.primaryColor : Colors.black87,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member['phoneNumber'] ?? '',
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (member['dateOfBirth'] != null)
                    Text(
                      'Năm sinh: ${DateTime.parse(member['dateOfBirth']).year}',
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
              trailing: Checkbox(
                activeColor: AppColors.primaryColor,
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedMembers.add(member['accountId']);
                    } else {
                      _selectedMembers.remove(member['accountId']);
                    }
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onTap: () {
                setState(() {
                  if (_selectedMembers.contains(member['accountId'])) {
                    _selectedMembers.remove(member['accountId']);
                  } else {
                    _selectedMembers.add(member['accountId']);
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _createGroup() async {
    setState(() => _isCreating = true);
    try {
      // Prepare members list including the creator
      final members = [
        {
          'accountId': widget.currentUserAccountID,
          'isCreator': true,
        },
        ..._selectedMembers.map((id) => {
              'accountId': id,
              'isCreator': false,
            }),
      ];

      final response = await http.post(
        Uri.parse('https://api.diavan-valuation.asia/groups'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'groupName': _groupNameController.text.trim(),
          'creatorAccountId': widget.currentUserAccountID,
          'members': members,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          CherryToast.success(
            title: const Text('Tạo nhóm thành công'),
            action: Text(
              "Xem chi tiết",
              style: TextStyle(color: AppColors.primaryColor),
            ),
            actionHandler: () {
              Navigator.pop(context, true);
            },
          ).show(context);
          Navigator.pop(context, true);
        } else {
          CherryToast.error(
            title: Text(data['data'] ?? 'Tạo nhóm thất bại'),
          ).show(context);
        }
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      CherryToast.error(
        title: Text('Lỗi: ${e.toString()}'),
      ).show(context);
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }
}
