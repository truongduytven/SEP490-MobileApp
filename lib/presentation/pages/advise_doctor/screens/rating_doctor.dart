import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/theme/color.dart';

class RatingDoctor extends StatefulWidget {
  final AppoimentDoctor? appoimentDoctor;
  const RatingDoctor({super.key, this.appoimentDoctor});

  @override
  State<RatingDoctor> createState() => _RatingDoctorState();
}

class _RatingDoctorState extends State<RatingDoctor> {
  TextEditingController commentController = TextEditingController();
  double rating = 0.0;
  bool isLoading = false;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late String fullName = '';

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    fullName = sharedPrefsHelper.getString('fullName') ?? '';
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void handleRatingDoctor() async {
    if (rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn đánh giá')),
      );
      return;
    }
    if (commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nhận xét')),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();

    await doctorController.ratingDoctor(
      widget.appoimentDoctor?.professorAppointmentId ?? 0,
      commentController.text,
      int.parse(rating.toStringAsFixed(0)),
      fullName,
    );

    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (doctorController.isRatingSuccess) {
        CherryToast.success(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Đánh giá thành công",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        Navigator.pop(context, true);
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Đánh giá thất bại, vui lòng thử lại",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Đánh giá bác sĩ',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 25)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        widget.appoimentDoctor?.professorAvatar ?? ''),
                    radius: 30,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.appoimentDoctor?.professorName ?? '',
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600)),
                      Text(widget.appoimentDoctor?.dateTime ?? '',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Đánh giá',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        rating = index + 1.0;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              const Text('Nhận xét',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              TextField(
                controller: commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusColor: AppColors.primaryColor,
                  hintText: 'Nhập nhận xét của bạn',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      handleRatingDoctor();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator()
                        : const Text('Gửi đánh giá',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// import 'package:cherry_toast/cherry_toast.dart';
// import 'package:flutter/material.dart';
// import 'package:sep490/data/helper/shared_prefs_helper.dart';
// import 'package:sep490/models/doctor.dart';
// import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
// import 'package:sep490/theme/color.dart';

// class RatingDoctor extends StatefulWidget {
//   final AppoimentDoctor? appoimentDoctor;
//   const RatingDoctor({super.key, this.appoimentDoctor});

//   @override
//   State<RatingDoctor> createState() => _RatingDoctorState();
// }

// class _RatingDoctorState extends State<RatingDoctor> {
//   TextEditingController commentController = TextEditingController();
//   double rating = 0.0;
//   bool isLoading = false;
//   SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
//   late String fullName = '';

//   @override
//   void initState() {
//     super.initState();
//     commentController = TextEditingController();
//     fullName = sharedPrefsHelper.getString('fullName') ?? '';
//   }

//   @override
//   void dispose() {
//     commentController.dispose();
//     super.dispose();
//   }

//   void handleRatingDoctor() async {
//     if (rating == 0.0) {
//       _showErrorDialog('Thiếu đánh giá', 'Vui lòng chọn số sao đánh giá');
//       return;
//     }

//     if (commentController.text.isEmpty) {
//       _showErrorDialog('Thiếu nhận xét', 'Vui lòng nhập nhận xét của bạn');
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       DoctorController doctorController = DoctorController();
//       await doctorController.ratingDoctor(
//         widget.appoimentDoctor?.professorAppointmentId ?? 0,
//         commentController.text,
//         int.parse(rating.toStringAsFixed(0)),
//         fullName,
//       );

//       if (!mounted) return;

//       if (doctorController.isRatingSuccess) {
//         CherryToast.success(
//           toastDuration: Duration(seconds: 3),
//           animationDuration: Duration(milliseconds: 500),
//           animationCurve: Curves.easeInOut,
//           borderRadius: 12,
//           title: Text(
//             "Đánh giá thành công!",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.green[800],
//             ),
//           ),
//           description: Text(
//             "Cảm ơn bạn đã dành thời gian đánh giá",
//             style: TextStyle(
//               fontSize: 15,
//               color: Colors.green[700],
//             ),
//           ),
//         ).show(context);

//         Navigator.pop(context, true);
//       } else {
//         CherryToast.error(
//           toastDuration: Duration(seconds: 3),
//           title: Text(
//             "Đánh giá không thành công",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.red[800],
//             ),
//           ),
//           description: Text(
//             "Vui lòng thử lại sau",
//             style: TextStyle(
//               fontSize: 15,
//               color: Colors.red[700],
//             ),
//           ),
//         ).show(context);
//       }
//     } catch (e) {
//       CherryToast.error(
//         title: Text("Lỗi hệ thống"),
//         description: Text("Đã xảy ra lỗi không mong muốn"),
//       ).show(context);
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }

//   void _showErrorDialog(String title, String content) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//         content: Text(content),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child:
//                 Text('Đóng', style: TextStyle(color: AppColors.primaryColor)),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getRatingDescription(double rating) {
//     if (rating == 0) return 'Chọn số sao';
//     if (rating == 1) return 'Rất không hài lòng';
//     if (rating == 2) return 'Không hài lòng';
//     if (rating == 3) return 'Bình thường';
//     if (rating == 4) return 'Hài lòng';
//     return 'Rất hài lòng';
//   }

//   Color _getRatingColor(double rating) {
//     if (rating == 0) return Colors.grey;
//     if (rating <= 2) return Colors.red.shade700;
//     if (rating == 3) return Colors.amber.shade700;
//     return Colors.green.shade700;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF8F9FB),
//       appBar: AppBar(
//         title: Text(
//           'Đánh giá bác sĩ',
//           style: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.black87),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Card thông tin bác sĩ
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Row(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: Colors.grey.shade200,
//                               width: 2,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 8,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: CircleAvatar(
//                             radius: 35,
//                             backgroundImage: NetworkImage(
//                               widget.appoimentDoctor?.professorAvatar ?? '',
//                             ),
//                             backgroundColor: Colors.grey[100],
//                           ),
//                         ),
//                         SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 widget.appoimentDoctor?.professorName ?? '',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.black87,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 'Chuyên khoa Tim mạch',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: AppColors.primaryColor,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               SizedBox(height: 6),
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 10, vertical: 6),
//                                 decoration: BoxDecoration(
//                                   color: Colors.blue.shade50,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(
//                                       Icons.calendar_today_rounded,
//                                       size: 14,
//                                       color: Colors.blue.shade700,
//                                     ),
//                                     SizedBox(width: 6),
//                                     Text(
//                                       widget.appoimentDoctor?.dateTime ?? '',
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         color: Colors.blue.shade700,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 28),

//                 // Section title
//                 Container(
//                   margin: EdgeInsets.only(left: 4, bottom: 12),
//                   child: Text(
//                     'Mức độ hài lòng',
//                     style: TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),

//                 // Phần đánh giá sao
//                 Container(
//                   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         padding:
//                             EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                         decoration: BoxDecoration(
//                           color: _getRatingColor(rating).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Text(
//                           _getRatingDescription(rating),
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: _getRatingColor(rating),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(5, (index) {
//                           return Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 8),
//                             child: GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   rating = index + 1.0;
//                                 });
//                               },
//                               child: AnimatedContainer(
//                                 duration: Duration(milliseconds: 200),
//                                 curve: Curves.easeInOut,
//                                 child: Icon(
//                                   index < rating
//                                       ? Icons.star_rounded
//                                       : Icons.star_border_rounded,
//                                   color: index < rating
//                                       ? Colors.amber
//                                       : Colors.grey.shade400,
//                                   size: 38,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 28),

//                 // Section title
//                 Container(
//                   margin: EdgeInsets.only(left: 4, bottom: 12),
//                   child: Text(
//                     'Nhận xét của bạn',
//                     style: TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),

//                 // Phần nhận xét
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: commentController,
//                     maxLines: 5,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                       hintText:
//                           'Hãy chia sẻ trải nghiệm của bạn về buổi tư vấn...',
//                       hintStyle: TextStyle(
//                         color: Colors.grey[400],
//                         fontStyle: FontStyle.italic,
//                       ),
//                       fillColor: Colors.white,
//                       filled: true,
//                     ),
//                     style: TextStyle(fontSize: 15, height: 1.5),
//                   ),
//                 ),
//                 SizedBox(height: 36),

//                 // Nút gửi
//                 Container(
//                   width: double.infinity,
//                   height: 54,
//                   child: ElevatedButton(
//                     onPressed: isLoading ? null : handleRatingDoctor,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       elevation: 0,
//                       shadowColor: AppColors.primaryColor.withOpacity(0.4),
//                     ),
//                     child: isLoading
//                         ? SizedBox(
//                             width: 24,
//                             height: 24,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2.5,
//                             ),
//                           )
//                         : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.send_rounded, size: 20),
//                               SizedBox(width: 10),
//                               Text(
//                                 'GỬI ĐÁNH GIÁ',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   letterSpacing: 1,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
