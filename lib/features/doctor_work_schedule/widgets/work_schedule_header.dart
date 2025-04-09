import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';
import 'work_schedule_controller.dart';
class WorkScheduleHeader extends StatelessWidget {
  final WorkScheduleController controller;

  const WorkScheduleHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // decoration: BoxDecoration(
      //   color: colors.surface,
      //   borderRadius: BorderRadius.circular(16),
      //   boxShadow: [
      //     BoxShadow(
      //       color: colors.shadow.withOpacity(0.1),
      //       blurRadius: 8,
      //       offset: const Offset(0, 2),
      //     ),
      //   ],
      // ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // IconButton(
            //   icon: Icon(Icons.chevron_left_rounded,
            //       size: 32, color: colors.primary),
            //   onPressed: () => controller.changeWeek(-1),
            // ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'LỊCH LÀM VIỆC THEO TUẦN ',
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // TextSpan(
                    //   text: DateFormat('dd/MM')
                    //       .format(controller.currentWeekStart),
                    //   style: textTheme.titleMedium?.copyWith(
                    //     color: colors.onSurface,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // TextSpan(
                    //   text: ' - ',
                    //   style: textTheme.titleMedium?.copyWith(
                    //     color: colors.primary,
                    //   ),
                    // ),
                    // TextSpan(
                    //   text: DateFormat('dd/MM').format(controller
                    //       .currentWeekStart
                    //       .add(const Duration(days: 6))),
                    //   style: textTheme.titleMedium?.copyWith(
                    //     color: colors.onSurface,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            // IconButton(
            //   icon: Icon(Icons.chevron_right_rounded,
            //       size: 32, color: colors.primary),
            //   onPressed: () => controller.changeWeek(1),
            // ),
          ],
        ),
      ),
    );
  }
}
