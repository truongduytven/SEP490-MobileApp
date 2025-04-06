import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/theme/color.dart';
import 'dart:io';

import 'package:sep490/theme/colors_game.dart';

class CreateReport extends StatefulWidget {
  const CreateReport({super.key});

  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _attachment;
  bool _isLoading = false;
  String? _selectedReportType;

  // Danh sách loại báo cáo
  final List<String> _reportTypes = [
    'Lỗi hệ thống',
    'Vấn đề tài khoản',
    'Báo cáo tư vấn sức khỏe',
    'Báo cáo bác sĩ',
    'Hỗ trợ tư vấn kết nối thiết bị',
    'Lỗi cuộc trò chuyện',
    'Báo cáo tiện ích',
    'Lỗi thanh toán',
    'Vấn đề liên kết tài khoản hỗ trợ',
    'Khác'
  ];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() {
        _attachment = File(pickedFile.path);
      });
    }
  }

  void _showConfirmationDialog() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Xác nhận gửi báo cáo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bạn có chắc chắn muốn gửi báo cáo này?'),
            if (_attachment != null) ...[
              const SizedBox(height: 12),
              Text(
                'Ảnh đính kèm: ${_attachment!.path.split('/').last}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitReport();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Gửi báo cáo',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReport() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
      final currentUserAccountID = sharedPrefsHelper.getInt("accountId");
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.diavan-valuation.asia/api/Report'),
      );

      request.fields['AccountId'] = currentUserAccountID.toString();
      request.fields['ReportTitle'] = _titleController.text;
      request.fields['ReportContent'] = _contentController.text;
      request.fields['ReportType'] = _selectedReportType ?? 'Khác';

      if (_attachment != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'Attachment',
            _attachment!.path,
            contentType: MediaType('image', 'png'),
          ),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        Navigator.pop(context);
        CherryToast.success(
          toastDuration: Duration(seconds: 3),
          title: Text(
            'Gửi báo cáo thành công',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ).show(context);
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 5),
          title: Text(
            'Gửi báo cáo thất bại. Vui lòng thử lại sau +${response.statusCode}',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ).show(context);
        throw Exception('Failed to submit report: ${response.statusCode}');
      }
    } catch (e) {
      CherryToast.error(
        toastDuration: Duration(seconds: 5),
        title: Text(
          'Gửi báo cáo thất bại. Vui lòng thử lại sau',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(
          AssetImage('https://cdn-icons-gif.flaticon.com/10826/10826774.gif'),
          context);
    });
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              RotationTransition(
                turns: const AlwaysStoppedAnimation(0.5),
                child: Icon(
                  Icons.autorenew,
                  color: AppColors.primaryColor,
                  size: 40,
                ),
              ),
              Image.network(
                'https://cdn-icons-gif.flaticon.com/10826/10826774.gif',
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 16),
              Text(
                'Đang gửi báo cáo...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo báo cáo mới'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề báo cáo
                Text(
                  'Thông tin báo cáo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                // Dropdown loại báo cáo
                DropdownButtonFormField<String>(
                  value: _selectedReportType,
                  decoration: InputDecoration(
                    labelText: 'Loại báo cáo',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 2),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  items: _reportTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedReportType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Vui lòng chọn loại báo cáo';
                    }
                    return null;
                  },
                  icon: const Icon(Icons.arrow_drop_down),
                  borderRadius: BorderRadius.circular(12),
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
                const SizedBox(height: 20),
                // Field tiêu đề
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Tiêu đề báo cáo',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  style: const TextStyle(fontSize: 15),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tiêu đề báo cáo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Field nội dung
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Nội dung chi tiết',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  maxLines: 5,
                  style: const TextStyle(fontSize: 15),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập nội dung báo cáo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Nút chọn ảnh
                OutlinedButton(
                  onPressed: _pickImage,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey[400]!),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.attach_file, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text(
                        _attachment == null
                            ? 'Thêm ảnh đính kèm (tùy chọn)'
                            : 'Đã chọn: ${_attachment!.path.split('/').last}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),

                // Hiển thị ảnh preview
                if (_attachment != null) ...[
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _attachment!,
                          height: 380,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _attachment = null;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 30),

                // Nút gửi báo cáo
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _showConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'GỬI BÁO CÁO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
