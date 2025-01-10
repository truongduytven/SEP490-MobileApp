import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/auth/signup_screen.dart';
import 'package:sep490/theme/color.dart';

class SelectRoleScreen extends StatefulWidget {
  final String sign;
  const SelectRoleScreen({super.key, required this.sign});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  final List roleData = [
    {
      'role': 'user',
      'title': 'Người cao tuổi',
      'description':
          'Quản lý sức khỏe, lịch uống thuốc, lịch khám bệnh, trò chơi giải trí, ...',
      'image': 'assets/img/role1.jpg',
    },
    {
      'role': 'caregiver',
      'title': 'Người thân',
      'description':
          'Quản lý sức khỏe người cao tuổi, nhận thông báo khẩn cấp, ...',
      'image': 'assets/img/role2.jpg',
    },
    // {
    //   'role': 'doctor',
    //   'title': 'Bác sĩ',
    //   'description':
    //       'Nhận lịch tư vấn bệnh nhân, xem thông tin sức khỏe, gửi lời cảnh báo, ...',
    //   'image': 'assets/img/role3.jpg',
    // },
  ];

  int? _selectedRole;

  void _selectRole(int index) {
    setState(() {
      _selectedRole = index;
    });
  }

  void _continue() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role to continue')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => SignUpScreen(role: roleData[_selectedRole!]['role']),
        builder: (context) => SignUpScreen(role: roleData[_selectedRole!]['role']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        title: Text(
          widget.sign == 'signin' ? 'Đăng nhập với quyền' : 'Đăng ký với quyền',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                  itemCount: roleData.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedRole == index;

                    return InkWell(
                      onTap: () => _selectRole(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.secondaryColor
                                  : Colors.grey.shade300,
                              width: isSelected ? 2.0 : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.secondaryColor.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ]),
                        child: Row(
                          children: [
                            // Text section
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    roleData[index]['title'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    roleData[index]['description'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                roleData[index]['image'] ?? '',
                                width: 140,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _continue(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                    child: const Text('Tiếp tục',
                        style: TextStyle(
                          fontSize: 28,
                          color: AppColors.bgColor,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
