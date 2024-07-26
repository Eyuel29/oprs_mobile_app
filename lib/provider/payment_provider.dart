import 'package:flutter/material.dart';
import 'package:oprs/model/payment_info.dart';
import 'package:oprs/repo/payment_repo.dart';
class PaymentProvider extends ChangeNotifier {
  List<PaymentInfo> myPaymentInfo = [];
  bool pageLoading = false;
  String errorMessage = "";

  Future<void> loadMyPaymentInfo() async {
    pageLoading = true;
    notifyListeners();
    final value = await PaymentRepo().getMypaymentInfo();
    if (value["status"] == 200) {
      myPaymentInfo.clear();
      myPaymentInfo.add(value["accountInfo"]);
      errorMessage = "";
    } else {
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    pageLoading = false;
    notifyListeners();
  }

  Future<void> createSubAccount(Map<String, String> paymentInfo) async {
    pageLoading = true;
    notifyListeners();
    final value = await PaymentRepo().createSubAccount(paymentInfo);
    if (value["status"] == 200) {
      errorMessage = "";
    } else {
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    pageLoading = false;
    notifyListeners();
  }

  Future<void> deleteSubAccount() async {
    pageLoading = true;
    notifyListeners();
    final value = await PaymentRepo().deleteSubAccount();
    if (value["status"] == 200) {
      errorMessage = value["message"] ?? "Your sub-account has been deleted";
    } else {
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    pageLoading = false;
    notifyListeners();
  }
}
