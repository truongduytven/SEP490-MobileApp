import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/home_model.dart';
import 'package:sep490/presentation/pages/home/controller/home_controller.dart';
import 'package:sep490/theme/color.dart';

class HistoryTransaction extends StatefulWidget {
  const HistoryTransaction({super.key});

  @override
  State<HistoryTransaction> createState() => _HistoryTransactionState();
}

class _HistoryTransactionState extends State<HistoryTransaction> {
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int accountId = sharedPrefsHelper.getInt('accountId') ?? 0;
  late bool isLoading = false;
  // ignore: avoid_init_to_null
  late List<HistoryTransactionData>? historyTransactions = null;

  @override
  void initState() {
    super.initState();
    getHistoryTransaction();
  }

  void getHistoryTransaction() async {
    setState(() {
      isLoading = true;
    });
    HomeController homeController = HomeController();
    await homeController.getHistoryTransaction(accountId);
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (homeController.historyTransactions != null) {
        setState(() {
          historyTransactions = homeController.historyTransactions;
          isLoading = false;
        });
      } else {
        setState(() {
          historyTransactions = null;
          isLoading = false;
        });
        if (homeController.errorMessage != null) {
          CherryToast.error(
            toastDuration: Duration(seconds: 2),
            title: Text(
              homeController.errorMessage.toString(),
              style: TextStyle(color: Colors.black),
            ),
          ).show(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử giao dịch",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
                color: AppColors.secondaryColor)),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
                strokeWidth: 2,
              ),
            )
          : historyTransactions != null && historyTransactions!.isNotEmpty
              ? ListView.builder(
                  itemCount: historyTransactions!.length,
                  itemBuilder: (context, index) {
                    final transaction = historyTransactions![index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                          border: Border.all(
                              color: Colors.grey.shade300), // Border color
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // Shadow position
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.all(16), // Padding inside tile
                          title: Text(transaction.package.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text("Ngày mua: ${convertDateTimeToDate(
                                transaction.bookingDate.isEmpty
                                    ? "2025-04-08T23:40:52.263"
                                    : transaction.bookingDate,
                              )}"),
                              Text(
                                  "Người dùng: ${transaction.elderly.fullName}"),
                            ],
                          ),
                          trailing: Text(
                            '${convertMoney(transaction.price.toDouble())} vnđ',
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text(
                    "Không có lịch sử giao dịch nào",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryColor),
                  ),
                ),
    );
  }
}
