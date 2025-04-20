import 'package:flutter/material.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/result_checkout.dart';
import 'package:sep490/theme/color.dart';

class Checkout extends StatefulWidget {
  final ComboData comboData;
  final Map<String, dynamic>? timeSlots;
  final DoctorData? doctorData;
  final String? description;
  const Checkout(
      {super.key,
      required this.comboData,
      this.timeSlots,
      this.doctorData,
      this.description});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late final ComboData data;
  final List<String> list = [
    'Được chọn chuyên gia tư vấn',
    'Nhận thông báo khi có lịch tư vấn',
    'Cảnh báo khi có chỉ số bất thường',
    'Gặp mặt tư vấn online hoặc offline',
  ];
  String selectedMethod = 'ZaloPay';
  late int selectedElderlyId = 0;
  late String selectedElderlyUserName = '';
  late int accountId = 0;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();

  @override
  void initState() {
    super.initState();
    data = widget.comboData;
    selectedElderlyId = sharedPrefsHelper.getInt('selectedElderlyUserId') ?? 0;
    selectedElderlyUserName =
        sharedPrefsHelper.getString('selectedElderlyUserName') ?? '';
    accountId = sharedPrefsHelper.getInt('accountId') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Thanh toán',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryColor)),
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đơn hàng',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                  color: AppColors.grayColor2,
                  width: 1.0,
                ),
              ),
              color: AppColors.bgColor,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Người già:',
                            style: TextStyle(
                              fontSize: 14,
                            )),
                        Text(selectedElderlyUserName,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryColor)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tên gói:',
                            style: TextStyle(
                              fontSize: 14,
                            )),
                        Text(data.name,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mô tả: ',
                            style: TextStyle(
                              fontSize: 14,
                            )),
                        Text(data.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondaryColor)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Số lần tư vấn trong tháng: ',
                            style: TextStyle(
                              fontSize: 14,
                            )),
                        Text(data.numberOfMeeting.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondaryColor)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (widget.timeSlots == null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: list
                                .map((e) => Row(
                                      children: [
                                        Icon(Icons.check_circle, size: 15),
                                        SizedBox(width: 5),
                                        Text(e,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    AppColors.secondaryColor)),
                                      ],
                                    ))
                                .toList(),
                          )
                        ],
                      ),
                    if (widget.timeSlots != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Thời gian tư vấn:',
                              style: TextStyle(
                                fontSize: 14,
                              )),
                          const SizedBox(height: 10),
                          Text(
                            '${widget.timeSlots!['startTime']} - ${widget.timeSlots!['endTime']}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondaryColor),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    if (widget.timeSlots != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Ngày tư vấn:',
                              style: TextStyle(
                                fontSize: 14,
                              )),
                          const SizedBox(height: 10),
                          Text(
                            '${widget.timeSlots!['day']}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondaryColor),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    if (widget.timeSlots != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Bác sĩ tư vấn:',
                              style: TextStyle(
                                fontSize: 14,
                              )),
                          const SizedBox(height: 10),
                          Text(
                            widget.doctorData!.fullName,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondaryColor),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tổng tiền:',
                            style: TextStyle(
                              fontSize: 14,
                            )),
                        Text('${convertMoney(data.fee)} VNĐ',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Hình thức thanh toán',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                  color: AppColors.grayColor2,
                  width: 1.0,
                ),
              ),
              color: AppColors.bgColor,
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: 'ZaloPay',
                    groupValue: selectedMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedMethod = value!;
                      });
                    },
                    activeColor: AppColors.primaryColor,
                    contentPadding: const EdgeInsets.all(10),
                    title: Text('ZaloPay (Ví điện tử)',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryColor)),
                    secondary: Image.asset('assets/img/zalo.png', width: 50),
                  ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        'Xác nhận thanh toán',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryColor),
                      ),
                      content: SizedBox(
                        height: 250,
                        child: Column(
                          children: [
                            Text(
                                'Bạn có chắc chắn rằng mua gói cho người già này hay không!',
                                style: TextStyle(fontSize: 18)),
                            Text(
                              'Bất kỳ khó khăn nào trong tư vấn, bạn có thể liên hệ với chúng tôi qua số điện thoại 0964 160 769 hoặc thông qua báo cáo hệ thống (chạm vào avatar ở trang chủ, chọn báo cáo hệ thống).',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Hủy',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondaryColor)),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15)),
                            backgroundColor: WidgetStateProperty.all<Color>(
                                AppColors.primaryColor),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            if (widget.doctorData != null) {
                              final Map<String, dynamic> dataBooking = {
                                "elderlyId": selectedElderlyId,
                                "professorId": widget.doctorData!.accountId,
                                "day": widget.timeSlots!['day'],
                                "startTime": widget.timeSlots!['startTime'],
                                "endTime": widget.timeSlots!['endTime'],
                                "description": widget.description,
                              };
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultCheckout(
                                    accountId: accountId,
                                    elderlyId: selectedElderlyId,
                                    comboId: widget.comboData.subscriptionId,
                                    bookingData: dataBooking,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultCheckout(
                                    accountId: accountId,
                                    elderlyId: selectedElderlyId,
                                    comboId: widget.comboData.subscriptionId,
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text('Xác nhận',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text(
                  'Thanh toán',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
