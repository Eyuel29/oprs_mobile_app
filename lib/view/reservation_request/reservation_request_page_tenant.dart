import 'package:flutter/material.dart';
import 'package:oprs/components/cards/reservation_request_card_tenant.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/provider/reservation_provider.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/reservation_request/reservation_request_detail_page.dart';
import 'package:provider/provider.dart';

class ReservationRequestPageTenant extends StatefulWidget {
  const ReservationRequestPageTenant({super.key});
  @override
  State<ReservationRequestPageTenant> createState() => _ReservationRequestPageTenantState();
}

class _ReservationRequestPageTenantState extends State<ReservationRequestPageTenant> {
  @override
  Widget build(BuildContext context) {
    var reservationProvider = Provider.of<ReservationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests'),
         backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor:MyColors.mainThemeLightColor,
      ),
      body: RefreshIndicator(
        onRefresh: reservationProvider.loadMyReservations,
        child: reservationProvider.pageLoading ? Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(top: 100),
          child: const SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(
              color: MyColors.mainThemeDarkColor,
              strokeWidth: 3,
            ),
          ),
        ) : reservationProvider.allReservations.isEmpty ? Container(
          height: 300,
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              Text(
                reservationProvider.errorMessage.isNotEmpty ? reservationProvider.errorMessage : "No requests!",
                style: const TextStyle(fontSize: 14)
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  reservationProvider.loadMyReservations();
                },
                child: const Text("Retry"),
              )
            ],
          ),
        ) : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        itemCount: reservationProvider.allReservations.length,
        itemBuilder: (context, index) {
          var reservation = reservationProvider.allReservations.reversed.toList()[index];
          return ReservationRequestCardTenant(
            reservationRequest: reservation,
            onCancelRequest: () {

              validateCancel(context).then((value){
                if(value ?? false){
                  reservationProvider.cancelMyRequest(reservation.reservationId).then((value) {
                    if (reservationProvider.errorMessage.isEmpty) {
                      SnackBarMessage.make(context, "Reservation request has been cancelled!");
                      reservationProvider.loadMyReservations();
                    } else {
                      SnackBarMessage.make(context, reservationProvider.errorMessage);
                    }
                  });
                }
              });
            },
            onReviewRequest: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReservationRequestDetailPage(
                    reservation: reservation,
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}

  Future<bool?> validateCancel(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          alignment: Alignment.center,
          title: const Text('Cancel Reservation?'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text('Yes'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text('No'),
              ),
            ),
          ],
        );
      },
    );
  }
}
