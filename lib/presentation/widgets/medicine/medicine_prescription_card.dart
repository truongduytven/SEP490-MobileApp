import 'package:flutter/material.dart';
import 'package:sep490/presentation/widgets/medicine/img_form.dart';
import 'package:sep490/theme/color.dart';

Widget buildMedicinePresciptionCard(
  String name,
  String dosage,
  String form,
  int remaining,
  String frequencyType,
  List<dynamic> frequencySelect,
  bool isBeforeMeal,
  List<dynamic> schedule,
  Function() onPressed,
) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.bgColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.grayColor1,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            buildImgForm(form),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // Cắt bớt nếu vẫn quá dài
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Còn lại: $remaining viên',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grayColor3),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'Dùng $dosage (${isBeforeMeal == true ? 'Trước' : 'Sau'} bữa ăn)',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.iconColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: AppColors.grayColor3),
                          children: [
                            const TextSpan(text: "Vào lúc: "),
                            TextSpan(
                              text: schedule.join(', '),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColors.iconColor), // In đậm phần này
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_right_rounded),
          ],
        ),
      ),
    ),
  );
}
