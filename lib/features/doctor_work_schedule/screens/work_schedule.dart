// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class WorkSchedule extends StatefulWidget {
//   const WorkSchedule({super.key});

//   @override
//   State<WorkSchedule> createState() => _WorkScheduleState();
// }

// class _WorkScheduleState extends State<WorkSchedule> {
//   final List<String> _days = [
//     'THỨ HAI',
//     'THỨ BA',
//     'THỨ TƯ',
//     'THỨ NĂM',
//     'THỨ SÁU',
//     'THỨ BẢY',
//     'CN'
//   ];
//   List<List<bool>> _timeSlots = List.generate(7, (_) => List.filled(24, false));
//   final List<String> _timeLabels =
//       List.generate(24, (index) => '${index.toString().padLeft(2, '0')}:00');
//   DateTime _currentWeekStart =
//       DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
//   final ScrollController _horizontalScrollController = ScrollController();
//   final ScrollController _headerScrollController = ScrollController();
//   final ScrollController _verticalScrollController = ScrollController();
//   final ScrollController _timeColumnScrollController = ScrollController();
//   @override
//   void initState() {
//     super.initState();
//     _initializeTimeSlots();
//     _headerScrollController.addListener(_syncHeaderToContent);
//     _horizontalScrollController.addListener(_syncContentToHeader);
//     _verticalScrollController.addListener(_syncContentToTimeColumn);
//     _timeColumnScrollController.addListener(_syncTimeColumnToContent);
//   }

//   @override
//   void dispose() {
//     _headerScrollController.removeListener(_syncHeaderToContent);
//     _horizontalScrollController.removeListener(_syncContentToHeader);
//     _verticalScrollController.removeListener(_syncContentToTimeColumn);
//     _timeColumnScrollController.removeListener(_syncTimeColumnToContent);
//     _horizontalScrollController.dispose();
//     _headerScrollController.dispose();
//     _verticalScrollController.dispose();
//     _timeColumnScrollController.dispose();
//     super.dispose();
//   }

//   void _syncHeaderScroll() {
//     _horizontalScrollController.jumpTo(_headerScrollController.offset);
//   }

//   void _initializeTimeSlots() {
//     for (int day = 0; day < 5; day++) {
//       for (int hour = 8; hour < 17; hour++) {
//         _timeSlots[day][hour] = true;
//       }
//     }
//   }

//   void _syncContentToTimeColumn() {
//     if (_verticalScrollController.hasClients &&
//         _timeColumnScrollController.hasClients) {
//       final contentOffset = _verticalScrollController.offset;
//       if ((contentOffset - _timeColumnScrollController.offset).abs() > 1.0) {
//         _timeColumnScrollController.jumpTo(contentOffset);
//       }
//     }
//   }

//   // Đồng bộ cuộn từ cột giờ sang nội dung chính
//   void _syncTimeColumnToContent() {
//     if (_timeColumnScrollController.hasClients &&
//         _verticalScrollController.hasClients) {
//       final timeColumnOffset = _timeColumnScrollController.offset;
//       if ((timeColumnOffset - _verticalScrollController.offset).abs() > 1.0) {
//         _verticalScrollController.jumpTo(timeColumnOffset);
//       }
//     }
//   }

//   void _syncHeaderToContent() {
//     if (_headerScrollController.hasClients &&
//         _horizontalScrollController.hasClients) {
//       final headerOffset = _headerScrollController.offset;
//       if ((headerOffset - _horizontalScrollController.offset).abs() > 1.0) {
//         _horizontalScrollController.animateTo(
//           headerOffset,
//           duration: const Duration(milliseconds: 100),
//           curve: Curves.easeInOut,
//         );
//       }
//     }
//   }

//   void _syncContentToHeader() {
//     if (_horizontalScrollController.hasClients &&
//         _headerScrollController.hasClients) {
//       final contentOffset = _horizontalScrollController.offset;
//       if (contentOffset != _headerScrollController.offset) {
//         _headerScrollController.jumpTo(contentOffset);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;
//     final textTheme = theme.textTheme;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('THỜI KHÓA BIỂU LÀM VIỆC'),
//         centerTitle: true,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [colors.primary, colors.primaryContainer],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.today, size: 28),
//             tooltip: 'Tuần hiện tại',
//             onPressed: _showCurrentWeek,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           _buildWeekSelector(theme),
//           const SizedBox(height: 8),
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: colors.surfaceVariant.withOpacity(0.1),
//               ),
//               child: _buildTimeTable(theme),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         icon: const Icon(Icons.save_rounded, size: 28),
//         label: const Text('LƯU LỊCH', style: TextStyle(fontSize: 16)),
//         onPressed: _saveSchedule,
//         backgroundColor: colors.primary,
//         foregroundColor: colors.onPrimary,
//         elevation: 4,
//       ),
//     );
//   }

//   Widget _buildWeekSelector(ThemeData theme) {
//     final colors = theme.colorScheme;
//     final textTheme = theme.textTheme;

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: colors.surface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: colors.shadow.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//               icon: Icon(Icons.chevron_left_rounded,
//                   size: 32, color: colors.primary),
//               onPressed: () => _changeWeek(-1),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: colors.primary.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: 'TUẦN ',
//                       style: textTheme.titleMedium?.copyWith(
//                         color: colors.primary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextSpan(
//                       text: DateFormat('dd/MM').format(_currentWeekStart),
//                       style: textTheme.titleMedium?.copyWith(
//                         color: colors.onSurface,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextSpan(
//                       text: ' - ',
//                       style: textTheme.titleMedium?.copyWith(
//                         color: colors.primary,
//                       ),
//                     ),
//                     TextSpan(
//                       text: DateFormat('dd/MM').format(
//                           _currentWeekStart.add(const Duration(days: 6))),
//                       style: textTheme.titleMedium?.copyWith(
//                         color: colors.onSurface,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.chevron_right_rounded,
//                   size: 32, color: colors.primary),
//               onPressed: () => _changeWeek(1),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeTable(ThemeData theme) {
//     final colors = theme.colorScheme;
//     final textTheme = theme.textTheme;

//     return Column(
//       children: [
//         // Header row (fixed)
//         SizedBox(
//           height: 72,
//           child: Row(
//             children: [
//               // Fixed time column header
//               SizedBox(
//                 width: 80,
//                 child: Center(
//                   child: Text(
//                     'GIỜ',
//                     style: textTheme.titleSmall?.copyWith(
//                       color: colors.primary,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1,
//                     ),
//                   ),
//                 ),
//               ),
//               // Scrollable day headers
//               Expanded(
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   controller: _headerScrollController,
//                   child: Row(
//                     children:
//                         List.generate(7, (day) => _buildDayHeader(day, theme)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Time slots (fixed time column + scrollable content)
//         Expanded(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Fixed time column với ScrollController mới
//               SizedBox(
//                 width: 80,
//                 child: ListView.builder(
//                   controller:
//                       _timeColumnScrollController, // Thêm controller này
//                   physics: const ClampingScrollPhysics(),
//                   itemCount: 24,
//                   itemBuilder: (context, hour) => _buildTimeLabel(hour, theme),
//                 ),
//               ),
//               // Scrollable content
//               Expanded(
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   controller: _horizontalScrollController,
//                   child: SizedBox(
//                     width: 700,
//                     child: ListView.builder(
//                       controller:
//                           _verticalScrollController, // Sử dụng controller này cho cuộn dọc
//                       physics: const ClampingScrollPhysics(),
//                       itemCount: 24,
//                       itemBuilder: (context, hour) =>
//                           _buildTimeRow(hour, theme),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTimeLabel(int hour, ThemeData theme) {
//     final colors = theme.colorScheme;
//     final textTheme = theme.textTheme;
//     final isCurrentHour = hour == DateTime.now().hour;

//     return Container(
//       height: 56,
//       margin: const EdgeInsets.symmetric(vertical: 2),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: colors.outline.withOpacity(0.1)),
//         ),
//       ),
//       child: Center(
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//           decoration: BoxDecoration(
//             color: isCurrentHour ? colors.primaryContainer : null,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             _timeLabels[hour],
//             style: textTheme.bodyMedium?.copyWith(
//               color:
//                   isCurrentHour ? colors.onPrimaryContainer : colors.onSurface,
//               fontWeight: isCurrentHour ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDayHeader(int day, ThemeData theme) {
//     final colors = theme.colorScheme;
//     final textTheme = theme.textTheme;
//     final date = _currentWeekStart.add(Duration(days: day));
//     final isToday = isSameDay(date, DateTime.now());

//     return SizedBox(
//       width: 100,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//             decoration: BoxDecoration(
//               color: isToday ? colors.primary : colors.surface,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(
//                 color:
//                     isToday ? colors.primary : colors.outline.withOpacity(0.2),
//                 width: 1,
//               ),
//             ),
//             child: Column(
//               children: [
//                 Text(
//                   _days[day],
//                   style: textTheme.labelSmall?.copyWith(
//                     color: isToday ? colors.onPrimary : colors.onSurface,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   DateFormat('dd').format(date),
//                   style: textTheme.titleMedium?.copyWith(
//                     color: isToday ? colors.onPrimary : colors.primary,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimeRow(int hour, ThemeData theme) {
//     return Container(
//       height: 56,
//       margin: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         children: List.generate(7, (day) => _buildTimeSlot(day, hour, theme)),
//       ),
//     );
//   }

//   Widget _buildTimeSlot(int day, int hour, ThemeData theme) {
//     final colors = theme.colorScheme;
//     final isSelected = _timeSlots[day][hour];
//     final date = _currentWeekStart.add(Duration(days: day));
//     final isToday = isSameDay(date, DateTime.now());
//     final isCurrentHour = hour == DateTime.now().hour;
//     final isCurrentTimeSlot = isToday && isCurrentHour;

//     return GestureDetector(
//       onTap: () => _toggleTimeSlot(day, hour),
//       onLongPress: () => _showSlotOptions(day, hour),
//       child: Container(
//         width: 100,
//         padding: const EdgeInsets.all(4),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           curve: Curves.easeInOut,
//           decoration: BoxDecoration(
//             color: isSelected
//                 ? colors.primary.withOpacity(isCurrentTimeSlot ? 0.4 : 0.2)
//                 : (isCurrentTimeSlot
//                     ? colors.primaryContainer.withOpacity(0.3)
//                     : Colors.transparent),
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: isSelected
//                   ? colors.primary.withOpacity(0.6)
//                   : colors.outline.withOpacity(0.1),
//               width: isSelected ? 1.5 : 0.8,
//             ),
//             boxShadow: isSelected
//                 ? [
//                     BoxShadow(
//                         color: colors.primary.withOpacity(0.1),
//                         blurRadius: 6,
//                         offset: const Offset(0, 2)),
//                   ]
//                 : null,
//           ),
//           child: Center(
//             child: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               transitionBuilder: (child, animation) => ScaleTransition(
//                 scale: animation,
//                 child: FadeTransition(opacity: animation, child: child),
//               ),
//               child: isSelected
//                   ? Icon(Icons.check_circle_rounded,
//                       key: const ValueKey('selected'),
//                       color: colors.primary,
//                       size: 24)
//                   : Icon(Icons.circle_outlined,
//                       key: const ValueKey('unselected'),
//                       color: colors.outline.withOpacity(0.3),
//                       size: 24),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _toggleTimeSlot(int day, int hour) {
//     setState(() {
//       _timeSlots[day][hour] = !_timeSlots[day][hour];
//     });
//   }

//   void _showSlotOptions(int day, int hour) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('${_days[day]} ${_timeLabels[hour]}'),
//         content: const Text('Tùy chọn cho khung giờ này'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Hủy'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Chi tiết'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showCurrentWeek() {
//     setState(() {
//       _currentWeekStart =
//           DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Đã chuyển đến tuần hiện tại'),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }

//   void _changeWeek(int delta) {
//     setState(() {
//       _currentWeekStart = _currentWeekStart.add(Duration(days: 7 * delta));
//     });
//   }

//   void _saveSchedule() {
//     final selectedSlots = <String>[];

//     for (int day = 0; day < 7; day++) {
//       for (int hour = 0; hour < 24; hour++) {
//         if (_timeSlots[day][hour]) {
//           selectedSlots.add('${_days[day]} ${_timeLabels[hour]}');
//         }
//       }
//     }

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'XÁC NHẬN LỊCH LÀM VIỆC',
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     color: Theme.of(context).colorScheme.primary,
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Bạn đã chọn ${selectedSlots.length} khung giờ làm việc',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 16),
//             if (selectedSlots.isEmpty)
//               const Text('Chưa có khung giờ nào được chọn')
//             else
//               Flexible(
//                 child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: selectedSlots.length,
//                     itemBuilder: (context, index) => ListTile(
//                           leading: Icon(Icons.access_time_rounded,
//                               color: Theme.of(context).colorScheme.primary),
//                           title: Text(selectedSlots[index]),
//                         )),
//               ),
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text('HỦY'),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content:
//                               const Text('Đã lưu lịch làm việc thành công'),
//                           behavior: SnackBarBehavior.floating,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           backgroundColor:
//                               Theme.of(context).colorScheme.primary,
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text('LƯU LỊCH'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   bool isSameDay(DateTime a, DateTime b) {
//     return a.year == b.year && a.month == b.month && a.day == b.day;
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/features/doctor_work_schedule/widgets/work_schedule_controller.dart';
import 'package:sep490/features/doctor_work_schedule/widgets/work_schedule_header.dart';
import 'package:sep490/features/doctor_work_schedule/widgets/work_schedule_table.dart';

class WorkSchedule extends StatefulWidget {
  final int accountId;

  const WorkSchedule({super.key, required this.accountId});

  @override
  State<WorkSchedule> createState() => _WorkScheduleState();
}

class _WorkScheduleState extends State<WorkSchedule> {
  final WorkScheduleController _controller = WorkScheduleController();
  bool _isEditing = false;
  Future<void> _loadSchedule() async {
    await _controller.fetchSchedule(widget.accountId);
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller.init();
    _loadSchedule();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('THỜI KHÓA BIỂU LÀM VIỆC'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, colors.primaryContainer],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.today, size: 28),
        //     tooltip: 'Tuần hiện tại',
        //     onPressed: _controller.showCurrentWeek,
        //   ),
        // ],
        actions: [
          if (_controller.hasData && !_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          if (_controller.hasData && _isEditing)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
              },
            ),
          if (_controller.hasData && _isEditing)
            IconButton(
              icon: const Icon(Icons.today),
              onPressed: _controller.showCurrentWeek,
            ),
        ],
      ),
      body: _buildBody(theme, colors),
      floatingActionButton: _buildFloatingActionButton(colors),
    );
  }

  Widget _buildBody(ThemeData theme, ColorScheme colors) {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_controller.hasData) {
      return _buildNoScheduleUI();
    }

    return Column(
      children: [
        WorkScheduleHeader(controller: _controller),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: colors.surfaceVariant.withOpacity(0.1),
            ),
            child: _isEditing
                ? WorkScheduleTable(controller: _controller)
                : _buildScheduleView(theme, colors),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleView(ThemeData theme, ColorScheme colors) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header với các ngày trong tuần
          _buildDayHeaders(theme),
          // Danh sách các khung giờ
          ..._buildTimeSlots(theme, colors),
        ],
      ),
    );
  }

  Widget _buildDayHeaders(ThemeData theme) {
    return Row(
      children: [
        const SizedBox(width: 80), // Cột giờ
        ...List.generate(
            7,
            (day) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _controller.days[day],
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
      ],
    );
  }

  List<Widget> _buildTimeSlots(ThemeData theme, ColorScheme colors) {
    return List.generate(24, (hour) {
      return Row(
        children: [
          // Cột giờ
          SizedBox(
            width: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                _controller.timeLabels[hour],
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
          // Các ô lịch
          ...List.generate(
              7,
              (day) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      height: 40,
                      decoration: BoxDecoration(
                        color: _controller.timeSlots[day][hour]
                            ? colors.primary.withOpacity(0.2)
                            : colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: colors.outline.withOpacity(0.1),
                        ),
                      ),
                      child: _controller.timeSlots[day][hour]
                          ? Icon(Icons.check_circle,
                              color: colors.primary, size: 20)
                          : null,
                    ),
                  )),
        ],
      );
    });
  }

  Widget? _buildFloatingActionButton(ColorScheme colors) {
    if (!_controller.hasData) {
      return FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('THÊM LỊCH'),
        onPressed: () {
          _controller.initializeTimeSlots();
          setState(() {
            _controller.hasData = true;
            _isEditing = true; // Tự động vào chế độ chỉnh sửa
          });
        },
      );
    }

    if (_isEditing) {
      return FloatingActionButton.extended(
        icon: const Icon(Icons.save),
        label: const Text('LƯU LỊCH'),
        onPressed: () async {
          await _controller.saveSchedule();
          setState(() {
            _isEditing = false;
          });
        },
      );
    }

    return null;
  }

  Widget _buildNoScheduleUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            'Bạn chưa có lịch làm việc',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Hãy thêm lịch làm việc bằng cách nhấn nút bên dưới',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
