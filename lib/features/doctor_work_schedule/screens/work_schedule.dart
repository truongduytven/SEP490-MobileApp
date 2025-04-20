import 'package:flutter/material.dart';
import 'package:sep490/features/doctor_work_schedule/widgets/work_schedule_controller.dart';
import 'package:sep490/features/doctor_work_schedule/widgets/work_schedule_header.dart';
import 'package:sep490/features/doctor_work_schedule/widgets/work_schedule_table.dart';
import 'package:sep490/theme/color.dart';

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
              colors: [AppColors.primaryLowColor, AppColors.primaryLowColor],
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
    final List<Widget> slots = [];

    // Lọc ra các khung giờ có lịch
    for (int hour = 0; hour < 24; hour++) {
      bool hasSchedule = false;
      for (int day = 0; day < 7; day++) {
        if (_controller.timeSlots[day][hour]) {
          hasSchedule = true;
          break;
        }
      }

      if (hasSchedule) {
        slots.add(
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                // Cột giờ
                SizedBox(
                  width: 70,
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
                                  ? AppColors.primaryColor.withOpacity(0.2)
                                  : AppColors.primaryLowColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: colors.outline.withOpacity(0.1),
                              ),
                            ),
                            child: _controller.timeSlots[day][hour]
                                ? Icon(Icons.check_circle,
                                    color: AppColors.primaryColor, size: 20)
                                : null,
                          ),
                        )),
              ],
            ),
          ),
        );
      }
    }

    // Nếu không có lịch nào trong tuần
    if (slots.isEmpty) {
      return [_buildEmptyScheduleUI(theme)];
    }

    return slots;
  }

  Widget _buildEmptyScheduleUI(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.schedule_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Chưa có lịch làm việc',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Bạn chưa thiết lập lịch làm việc cho tuần này. '
              'Hãy bắt đầu bằng cách nhấn nút bên dưới.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('TẠO LỊCH LÀM VIỆC'),
            onPressed: () {
              _controller.initializeTimeSlots();
              setState(() {
                _controller.hasData = true;
                _isEditing = true;
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton(ColorScheme colors) {
    if (!_controller.hasData) {
      return FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('THÊM LỊCH'),
        onPressed: () {
          _controller.initializeTimeSlots();
          setState(
            () {
              _controller.hasData = true;
              _isEditing = true; // Tự động vào chế độ chỉnh sửa
            },
          );
        },
      );
    }

    if (_isEditing) {
      return FloatingActionButton.extended(
        backgroundColor: AppColors.primaryLowColor.withOpacity(0.9),
        icon: const Icon(
          Icons.save,
          color: AppColors.primaryColor,
        ),
        label: const Text(
          'LƯU LỊCH',
          style: TextStyle(
            color: AppColors.primaryColor,
          ),
        ),
        // onPressed: () async {
        //   await _controller.saveSchedule();
        //   setState(() {
        //     _isEditing = false;
        //   });
        // },
        onPressed: () => _showSaveConfirmationDialog(),
      );
    }

    return null;
  }

  Future<void> _showSaveConfirmationDialog() async {
    final selectedSlots = <String>[];

    for (int day = 0; day < 7; day++) {
      for (int hour = 0; hour < 24; hour++) {
        if (_controller.timeSlots[day][hour]) {
          selectedSlots
              .add('${_controller.days[day]} ${_controller.timeLabels[hour]}');
        }
      }
    }

    // Group time slots by day (your existing implementation)
    Map<String, List<String>> _groupTimeSlots(List<String> slots) {
      final Map<String, List<String>> grouped = {};
      for (final slot in slots) {
        final lastSpaceIndex = slot.lastIndexOf(' ');
        if (lastSpaceIndex == -1) continue;
        final day = slot.substring(0, lastSpaceIndex);
        final time = slot.substring(lastSpaceIndex + 1);
        grouped.putIfAbsent(day, () => []).add(time);
      }
      for (final times in grouped.values) {
        times.sort();
      }
      return grouped;
    }

    // Format grouped time slots (your existing implementation)
    List<String> _formatGroupedTimeSlots(Map<String, List<String>> grouped) {
      final List<String> results = [];
      for (final entry in grouped.entries) {
        final day = entry.key;
        final times = entry.value;
        if (times.isEmpty) continue;
        List<List<String>> ranges = [];
        List<String> currentRange = [times.first];
        for (int i = 1; i < times.length; i++) {
          final prev = int.parse(times[i - 1].split(':')[0]);
          final current = int.parse(times[i].split(':')[0]);
          if (current == prev + 1) {
            currentRange.add(times[i]);
          } else {
            ranges.add(currentRange);
            currentRange = [times[i]];
          }
        }
        ranges.add(currentRange);
        final formattedRanges = ranges.map((range) {
          final startTime = range.first;
          final endHour = int.parse(range.last.split(':')[0]) + 1;
          final endTime = '${endHour.toString().padLeft(2, '0')}:00';
          return '$startTime - $endTime';
        }).join(', ');
        results.add('$day: $formattedRanges');
      }
      return results;
    }

    final groupedSlots = _groupTimeSlots(selectedSlots);
    final formattedSlots = _formatGroupedTimeSlots(groupedSlots);

    final shouldSave = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 24,
                right: 24,
                top: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Center(
                    child: Text(
                      'XÁC NHẬN LỊCH LÀM VIỆC',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Information card about existing appointments
                  Card(
                    elevation: 0,
                    color: AppColors.primaryColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: AppColors.primaryColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Lịch mới sẽ áp dụng cho các cuộc hẹn sau này. '
                              'Các cuộc hẹn đã đặt trước đó vẫn được giữ nguyên '
                              'và bạn vẫn cần tư vấn theo những lịch đã xác nhận.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey[800],
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Selected time slots
                  if (selectedSlots.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Chưa có khung giờ nào được chọn',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Các khung giờ đã chọn:',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        ...formattedSlots
                            .map((slot) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.circle,
                                          size: 8,
                                          color: AppColors.primaryColor),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          slot,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ],
                    ),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: const Text('HỦY'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('LƯU LỊCH'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (shouldSave == true) {
      await _controller.saveSchedule();
      setState(() {
        _isEditing = false;
      });
    }
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
