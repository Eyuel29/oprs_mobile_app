import 'package:flutter/cupertino.dart';
import 'package:oprs/model/agreement.dart';
import 'package:oprs/repo/agreement_repo.dart';

class AgreementProvider extends ChangeNotifier{
  List<Agreement> allAgreements = [];
  bool pageLoading = false;
  String errorMessage = "";

  Future<void> onPageRefresh() async {
    await loadAgreements();
    notifyListeners();
  }

  Future<void> loadAgreements() async {
    pageLoading = true;
    notifyListeners();
    final value = await AgreementRepo().getMyAgreements();
    if (value["status"] == 200) {
      allAgreements = List<Agreement>.from(value["agreements"]);
      errorMessage = "";
    } else {
      allAgreements = [];
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    pageLoading = false;
    notifyListeners();
  }
}