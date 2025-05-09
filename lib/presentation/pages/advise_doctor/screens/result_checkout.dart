import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/presentation/pages/navigation_menu.dart';
import 'package:sep490/theme/color.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultCheckout extends StatefulWidget {
  final int accountId;
  final int elderlyId;
  final int comboId;
  final Map<String, dynamic>? bookingData;

  const ResultCheckout({
    super.key,
    required this.accountId,
    required this.elderlyId,
    required this.comboId,
    this.bookingData,
  });

  @override
  State<ResultCheckout> createState() => _ResultCheckoutState();
}

class _ResultCheckoutState extends State<ResultCheckout>
    with WidgetsBindingObserver {
  bool isLoading = false;
  bool isCheckoutSuccess = true;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  int _countdown = 3;
  Timer? _timer;
  late String trans_id = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    createCheckout();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkPaymentStatus();
    }
  }

  void createCheckout() async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.checkout(
        widget.accountId, widget.elderlyId, widget.comboId);
    Timer(Duration(seconds: 2), () async {
      if (!mounted) return;
      if (doctorController.checkoutResponse != null) {
        if (doctorController.checkoutResponse!.returnCode == 1) {
          setState(() {
            trans_id = doctorController.checkoutResponse!.appTransId;
          });
          await launchUrl(
              Uri.parse(doctorController.checkoutResponse!.orderUrl),
              mode: LaunchMode.externalApplication);
        } else {
          setState(() {
            isCheckoutSuccess = false;
          });
        }
      } else {
        setState(() {
          isCheckoutSuccess = false;
        });
      }
    });
  }

  void checkPaymentStatus() async {
    DoctorController doctorController = DoctorController();
    await doctorController.checkOrderStatus(trans_id);
    Timer(Duration(seconds: 2), () {
      if (!mounted) return;
      if (doctorController.isOrderSuccess) {
        confirmCheckout();
      } else {
        setState(() {
          isLoading = false;
          isCheckoutSuccess = false;
        });
      }
    });
  }

  void confirmCheckout() async {
    DoctorController doctorController = DoctorController();
    await doctorController.confirmCheckout(trans_id);
    Timer(Duration(seconds: 2), () async {
      if (!mounted) return;
      if (doctorController.isConfirmedSuccess) {
        if (widget.bookingData != null) {
          await doctorController.bookingAppointment(
              widget.bookingData!['elderlyId'],
              widget.bookingData!['professorId'],
              widget.bookingData!['startTime'],
              widget.bookingData!['endTime'],
              widget.bookingData!['day'],
              widget.bookingData!['description']);
          if (doctorController.isBookingAppointmentSuccess) {
            setState(() {
              isLoading = false;
              isCheckoutSuccess = true;
            });
          } else {
            setState(() {
              isLoading = false;
              isCheckoutSuccess = false;
            });
          }
        }
        setState(() {
          isLoading = false;
          isCheckoutSuccess = true;
        });
      } else {
        setState(() {
          isLoading = false;
          isCheckoutSuccess = false;
        });
        _startCountdown();
      }
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationMenu(keyIndex: 3),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: AppColors.bgColor,
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: isLoading
                ? Center(
                    child: GifView.asset(
                      'assets/gif/payment.gif',
                      width: 100,
                      height: 100,
                      frameRate: 60,
                    ),
                  )
                : isCheckoutSuccess
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/img/payment_success.png',
                              height: 150,
                              width: 150,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Thanh toán thành công!!',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            Center(
                              child: Text(
                                "$_countdown",
                                style: TextStyle(
                                    fontSize: 50,
                                    color: AppColors.secondaryColor),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/img/payment_failure.png',
                              height: 150,
                              width: 150,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Thanh toán thất bại!!',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            const Text(
                              'Vui lòng thử lại sau',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Quay lại',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.bgColor,
                                  )),
                            )
                          ],
                        ),
                      ),
          )),
    );
  }
}
