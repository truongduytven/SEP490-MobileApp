import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class WorkScheduleController {
  final List<String> days = [
    'THỨ HAI',
    'THỨ BA',
    'THỨ TƯ',
    'THỨ NĂM',
    'THỨ SÁU',
    'THỨ BẢY',
    'CN'
  ];

  final List<String> timeLabels =
      List.generate(24, (index) => '${index.toString().padLeft(2, '0')}:00');

  List<List<bool>> timeSlots = List.generate(7, (_) => List.filled(24, false));
  DateTime currentWeekStart =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  final ScrollController horizontalScrollController = ScrollController();
  final ScrollController headerScrollController = ScrollController();
  final ScrollController verticalScrollController = ScrollController();
  final ScrollController timeColumnScrollController = ScrollController();

  BuildContext? _context;

  bool _isLoading = true;
  bool _hasData = false;

  bool get isLoading => _isLoading;
  bool get hasData => _hasData;
  set hasData(bool value) {
    _hasData = value;
  }

  void initializeTimeSlots() {
    _initializeTimeSlots();
  }

  Future<void> fetchSchedule(int accountId) async {
    try {
      _isLoading = true;
      final response = await http.get(
        Uri.parse(
            'https://api.diavan-valuation.asia/api/Professor/schedule/$accountId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1 && data['data'] != null) {
          print('schedule nè ${data['data']}');
          _parseApiData(data['data']);
          _hasData = true;
        } else {
          _hasData = false;
        }
      } else {
        _hasData = false;
        throw Exception('Failed to load schedule');
      }
    } catch (e) {
      _hasData = false;
      debugPrint('Error fetching schedule: $e');
    } finally {
      _isLoading = false;
    }
  }

  Future<void> saveSchedule() async {
    if (_context == null) return;

    try {
      // Chuẩn bị dữ liệu để gửi lên API
      final scheduleData = _convertToApiFormat();

      // Gọi API để lưu lịch
      final response = await http.post(
        Uri.parse('https://api.diavan-valuation.asia/api/Professor/schedule'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(scheduleData),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 1) {
          _showSnackBar('Đã lưu lịch làm việc thành công');
        } else {
          _showSnackBar('Lưu lịch không thành công: ${result['message']}');
        }
      } else {
        _showSnackBar('Lỗi khi lưu lịch: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Lỗi kết nối: $e');
    }
  }

  List<Map<String, dynamic>> _convertToApiFormat() {
    final List<Map<String, dynamic>> result = [];
    const dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    for (int day = 0; day < 7; day++) {
      final timeSlotsForDay = <Map<String, String>>[];
      int? startHour;

      for (int hour = 0; hour < 24; hour++) {
        if (timeSlots[day][hour]) {
          startHour ??= hour;
        } else if (startHour != null) {
          timeSlotsForDay.add({
            'start': '${startHour.toString().padLeft(2, '0')}:00',
            'end': '${hour.toString().padLeft(2, '0')}:00',
          });
          startHour = null;
        }
      }

      // Thêm slot cuối cùng nếu có
      if (startHour != null) {
        timeSlotsForDay.add({
          'start': '${startHour.toString().padLeft(2, '0')}:00',
          'end': '24:00',
        });
      }

      result.add({
        'dayOfWeek': dayNames[day],
        'times': timeSlotsForDay,
      });
    }

    return result;
  }

  void _parseApiData(List<dynamic> apiData) {
    // Reset all slots to false
    timeSlots = List.generate(7, (_) => List.filled(24, false));

    for (var dayData in apiData) {
      final dayIndex = _getDayIndex(dayData['dayOfWeek']);
      if (dayIndex == -1) continue;

      for (var timeSlot in dayData['times']) {
        final startHour = _parseHour(timeSlot['start']);
        final endHour = _parseHour(timeSlot['end']);

        for (var hour = startHour; hour < endHour; hour++) {
          if (hour >= 0 && hour < 24) {
            timeSlots[dayIndex][hour] = true;
          }
        }
      }
    }
  }

  int _getDayIndex(String dayOfWeek) {
    const dayMap = {
      'Monday': 0,
      'Tuesday': 1,
      'Wednesday': 2,
      'Thursday': 3,
      'Friday': 4,
      'Saturday': 5,
      'Sunday': 6,
    };
    return dayMap[dayOfWeek] ?? -1;
  }

  int _parseHour(String time) {
    try {
      final parts = time.split(':');
      return int.parse(parts[0]);
    } catch (e) {
      return -1;
    }
  }

  void init() {
    _initializeTimeSlots();
    headerScrollController.addListener(_syncHeaderToContent);
    horizontalScrollController.addListener(_syncContentToHeader);
    verticalScrollController.addListener(_syncContentToTimeColumn);
    timeColumnScrollController.addListener(_syncTimeColumnToContent);
  }

  void dispose() {
    headerScrollController.removeListener(_syncHeaderToContent);
    horizontalScrollController.removeListener(_syncContentToHeader);
    verticalScrollController.removeListener(_syncContentToTimeColumn);
    timeColumnScrollController.removeListener(_syncTimeColumnToContent);
    horizontalScrollController.dispose();
    headerScrollController.dispose();
    verticalScrollController.dispose();
    timeColumnScrollController.dispose();
  }

  void attachContext(BuildContext context) {
    _context = context;
  }

  void _initializeTimeSlots() {
    for (int day = 0; day < 5; day++) {
      for (int hour = 8; hour < 17; hour++) {
        timeSlots[day][hour] = true;
      }
    }
  }

  void _syncContentToTimeColumn() {
    if (verticalScrollController.hasClients &&
        timeColumnScrollController.hasClients) {
      final contentOffset = verticalScrollController.offset;
      if ((contentOffset - timeColumnScrollController.offset).abs() > 1.0) {
        timeColumnScrollController.jumpTo(contentOffset);
      }
    }
  }

  void _syncTimeColumnToContent() {
    if (timeColumnScrollController.hasClients &&
        verticalScrollController.hasClients) {
      final timeColumnOffset = timeColumnScrollController.offset;
      if ((timeColumnOffset - verticalScrollController.offset).abs() > 1.0) {
        verticalScrollController.jumpTo(timeColumnOffset);
      }
    }
  }

  void _syncHeaderToContent() {
    if (headerScrollController.hasClients &&
        horizontalScrollController.hasClients) {
      final headerOffset = headerScrollController.offset;
      if ((headerOffset - horizontalScrollController.offset).abs() > 1.0) {
        horizontalScrollController.animateTo(
          headerOffset,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _syncContentToHeader() {
    if (horizontalScrollController.hasClients &&
        headerScrollController.hasClients) {
      final contentOffset = horizontalScrollController.offset;
      if (contentOffset != headerScrollController.offset) {
        headerScrollController.jumpTo(contentOffset);
      }
    }
  }

  void toggleTimeSlot(int day, int hour) {
    timeSlots[day][hour] = !timeSlots[day][hour];
  }

  void showCurrentWeek() {
    currentWeekStart =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    _showSnackBar('Đã chuyển đến tuần hiện tại');
  }

  void changeWeek(int delta) {
    currentWeekStart = currentWeekStart.add(Duration(days: 7 * delta));
  }

  Widget _buildSaveScheduleDialog(List<String> selectedSlots) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'XÁC NHẬN LỊCH LÀM VIỆC',
            style: Theme.of(_context!).textTheme.titleLarge?.copyWith(
                  color: Theme.of(_context!).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Bạn đã chọn ${selectedSlots.length} khung giờ làm việc',
            style: Theme.of(_context!).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          if (selectedSlots.isEmpty)
            const Text('Chưa có khung giờ nào được chọn')
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: selectedSlots.length,
                itemBuilder: (context, index) => ListTile(
                  leading: Icon(Icons.access_time_rounded,
                      color: Theme.of(_context!).colorScheme.primary),
                  title: Text(selectedSlots[index]),
                ),
              ),
            ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(_context!),
                  child: const Text('HỦY'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(_context!);
                    _showSnackBar('Đã lưu lịch làm việc thành công');
                  },
                  child: const Text('LƯU LỊCH'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    if (_context == null) return;

    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
