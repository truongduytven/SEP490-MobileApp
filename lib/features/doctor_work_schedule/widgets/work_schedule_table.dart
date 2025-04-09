import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/theme/color.dart';
import 'work_schedule_controller.dart';
class WorkScheduleTable extends StatefulWidget {
  final WorkScheduleController controller;
  const WorkScheduleTable({super.key, required this.controller});
  @override
  State<WorkScheduleTable> createState() => _WorkScheduleTableState();
}

class _WorkScheduleTableState extends State<WorkScheduleTable> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.attachContext(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        _buildHeaderRow(theme),
        Expanded(child: _buildTimeTable(theme)),
      ],
    );
  }

  Widget _buildHeaderRow(ThemeData theme) {
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SizedBox(
      height: 72,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Center(
              child: Text(
                'GIỜ',
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: widget.controller.headerScrollController,
              child: Row(
                children:
                    List.generate(7, (day) => _buildDayHeader(day, theme)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeader(int day, ThemeData theme) {
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final date = widget.controller.currentWeekStart.add(Duration(days: day));
    final isToday = widget.controller.isSameDay(date, DateTime.now());

    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              color: isToday ? AppColors.primaryColor : colors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isToday
                    ? AppColors.primaryColor
                    : colors.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  widget.controller.days[day],
                  style: textTheme.labelSmall?.copyWith(
                    color: isToday ? colors.onPrimary : colors.onSurface,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd').format(date),
                  style: textTheme.titleMedium?.copyWith(
                    color: isToday ? colors.onPrimary : AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeTable(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: ListView.builder(
            controller: widget.controller.timeColumnScrollController,
            physics: const ClampingScrollPhysics(),
            itemCount: 24,
            itemBuilder: (context, hour) => _buildTimeLabel(hour, theme),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: widget.controller.horizontalScrollController,
            child: SizedBox(
              width: 700,
              child: ListView.builder(
                controller: widget.controller.verticalScrollController,
                physics: const ClampingScrollPhysics(),
                itemCount: 24,
                itemBuilder: (context, hour) => _buildTimeRow(hour, theme),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeLabel(int hour, ThemeData theme) {
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isCurrentHour = hour == DateTime.now().hour;

    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.outline.withOpacity(0.1)),
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isCurrentHour ? AppColors.primaryLowColor : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.controller.timeLabels[hour],
            style: textTheme.bodyMedium?.copyWith(
              color: isCurrentHour ? AppColors.primaryColor : colors.onSurface,
              fontWeight: isCurrentHour ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRow(int hour, ThemeData theme) {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: List.generate(7, (day) => _buildTimeSlot(day, hour, theme)),
      ),
    );
  }

  Widget _buildTimeSlot(int day, int hour, ThemeData theme) {
    final colors = theme.colorScheme;
    final isSelected = widget.controller.timeSlots[day][hour];
    final date = widget.controller.currentWeekStart.add(Duration(days: day));
    final isToday = widget.controller.isSameDay(date, DateTime.now());
    final isCurrentHour = hour == DateTime.now().hour;
    final isCurrentTimeSlot = isToday && isCurrentHour;

    return GestureDetector(
      onTap: () {
        setState(() {
          widget.controller.toggleTimeSlot(day, hour);
        });
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(4),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor
                    .withOpacity(isCurrentTimeSlot ? 0.4 : 0.2)
                : (isCurrentTimeSlot
                    ? AppColors.primaryColor.withOpacity(0.2)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColor.withOpacity(0.6)
                  : colors.outline.withOpacity(0.1),
              width: isSelected ? 1.5 : 0.8,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2)),
                  ]
                : null,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: isSelected
                  ? Icon(Icons.check_circle_rounded,
                      key: const ValueKey('selected'),
                      color: AppColors.primaryColor,
                      size: 24)
                  : Icon(Icons.circle_outlined,
                      key: const ValueKey('unselected'),
                      color: AppColors.primaryColor.withOpacity(0.3),
                      size: 24),
            ),
          ),
        ),
      ),
    );
  }
}
