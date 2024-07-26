import 'package:flutter/cupertino.dart';
import 'package:oprs/model/reservation.dart';
import 'package:oprs/repo/reservation_repo.dart';

class ReservationProvider extends ChangeNotifier{
  List<Reservation> allReservations = [];
  String errorMessage = "";
  bool pageLoading = false, approvalWaiting = false, cancelWaiting = false, declineWaiting = false;

  Future<void> onPageRefresh() async {
    await loadReservations();
    notifyListeners();
  }

  void setPageStateLoading(bool loading) {
    pageLoading = loading;
    notifyListeners();
  }

  Future<void> loadReservations() async {
    pageLoading = true;
    notifyListeners();
    final value = await ReservationRepo().getAllReservations();
    if (value["status"] == 200) {
      allReservations = List<Reservation>.from(value["reservations"]);
      errorMessage = "";
     } else {
      allReservations = [];
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    pageLoading = false;
    notifyListeners();
  }

  Future<void> loadMyReservations() async {
    pageLoading = true;
    notifyListeners();
    final value = await ReservationRepo().getMyRequests();
    if (value["status"] == 200) {
      allReservations = List<Reservation>.from(value["reservations"]);
      errorMessage = "";
    } else {
      allReservations = [];
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    pageLoading = false;
    notifyListeners();
  }

  Future<void> approveReservation(int reservationId) async {
    approvalWaiting = true;
    notifyListeners();
    final value = await ReservationRepo().approveRequest(reservationId);
    if (value["status"] == 200) {
      errorMessage = "";
    } else {
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    approvalWaiting = false;
    notifyListeners();
  }

  Future<void> declineRequest(int reservationId) async {
    declineWaiting = true;
    notifyListeners();
    final value = await ReservationRepo().declineRequest(reservationId);
    if (value["status"] == 200) {
      errorMessage = "";
    } else {
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    declineWaiting = false;
    notifyListeners();
  }

  Future<void> cancelMyRequest(int reservationId) async {
    cancelWaiting = true;
    notifyListeners();
    final value = await ReservationRepo().cancelRequest(reservationId);
    if (value["status"] == 200) {
      errorMessage = "";
    } else {
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    cancelWaiting = false;
    notifyListeners();
  }
}