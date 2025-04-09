// report_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'dart:convert';

import 'package:sep490/features/report/screens/create_report.dart';
import 'package:sep490/features/select_contacts/screens/user_information_screen.dart';
import 'package:sep490/main.dart';
import 'package:sep490/theme/color.dart';

class Report {
  final int reportId;
  final int accountId;
  final String? fullName;
  final String? phoneNumber;
  final String reportTitle;
  final String reportContent;
  final String? attachmentUrl;
  final String reportType;
  final String status;
  final DateTime createdAt;

  Report({
    required this.reportId,
    required this.accountId,
    this.fullName,
    this.phoneNumber,
    required this.reportTitle,
    required this.reportContent,
    this.attachmentUrl,
    required this.reportType,
    required this.status,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportId: json['reportId'],
      accountId: json['accountId'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      reportTitle: json['reportTitle'],
      reportContent: json['reportContent'],
      attachmentUrl: json['attachmentUrl'],
      reportType: json['reportType'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin, RouteAware, WidgetsBindingObserver {
  late TabController _tabController;
  List<Report> reports = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    fetchReports();
  }

  @override
  void dispose() {
    _tabController.dispose();

    WidgetsBinding.instance
        .removeObserver(this); // Xóa observer khi widget bị hủy
    routeObserver.unsubscribe(this); // Hủy đăng ký RouteAware khi widget bị hủy
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Đăng ký RouteAware để theo dõi sự kiện navigation
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      // Kiểm tra xem route có phải là PageRoute không
      routeObserver.subscribe(this,
          route as PageRoute<dynamic>); // Ép kiểu thành PageRoute<dynamic>
    }
  }

  @override
  void didPopNext() {
    // Khi màn hình này được hiển thị lại sau khi pop từ màn hình khác
    fetchReports(); // Gọi lại API
  }

  Future<void> fetchReports() async {
    try {
      SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
      final currentUserAccountID = sharedPrefsHelper.getInt("accountId");
      final response = await http.get(
        Uri.parse(
            'https://api.diavan-valuation.asia/api/Report/${currentUserAccountID}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          setState(() {
            reports = (data['data'] as List)
                .map((item) => Report.fromJson(item))
                .toList();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = data['message'] ?? 'Failed to load reports';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load reports (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  List<Report> get filteredReports {
    switch (_tabController.index) {
      case 1:
        return reports.where((r) => r.status == 'Đang chờ xử lí').toList();
      case 2:
        return reports.where((r) => r.status == 'Đã xử lí').toList();
      default:
        return reports;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo hệ thống'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          // indicatorColor: Colors.white,
          indicatorColor: AppColors.primaryColor,
          indicatorWeight: 4,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: AppColors.secondaryColor,
          labelStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Đang chờ xử lí'),
            Tab(text: 'Đã xử lí'),
          ],
          onTap: (index) {
            setState(() {});
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildReportList(filteredReports),
                    _buildReportList(filteredReports),
                    _buildReportList(filteredReports),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateReport()),
          );
        },
        backgroundColor: AppColors.primaryColor,
        elevation: 4,
        child: Icon(
          Icons.add,
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildReportList(List<Report> reportsToShow) {
    if (reportsToShow.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.report_off,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Không có báo cáo nào',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchReports,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reportsToShow.length,
        itemBuilder: (context, index) {
          final report = reportsToShow[index];
          return _buildReportCard(report);
        },
      ),
    );
  }

  Widget _buildReportCard(Report report) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      report.reportTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: report.status == 'Đã xử lí'
                          ? Colors.green[50]
                          : Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: report.status == 'Đã xử lí'
                            ? Colors.green
                            : Colors.orange,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      report.status,
                      style: TextStyle(
                        color: report.status == 'Đã xử lí'
                            ? Colors.green[800]
                            : Colors.orange[800],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                report.reportContent,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              if (report.attachmentUrl != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    report.attachmentUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              if (report.fullName != null)
                _buildInfoRow('Họ tên', report.fullName!),
              if (report.phoneNumber != null)
                _buildInfoRow('Số điện thoại', report.phoneNumber!),
              _buildInfoRow('Loại báo cáo', report.reportType),
              _buildInfoRow(
                'Ngày tạo',
                '${_formatDate(report.createdAt)} ${_formatTime(report.createdAt)}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isImage = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.pink[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                if (isImage)
                  GestureDetector(
                    onTap: () {
                      // Xử lý phóng to ảnh khi nhấn
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        value,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      color: valueColor ?? Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
