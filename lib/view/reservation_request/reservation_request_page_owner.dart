import 'package:flutter/material.dart';
import 'package:oprs/components/cards/reservation_request_card_owner.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/provider/reservation_provider.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:provider/provider.dart';

class ReservationRequestPageOwner extends StatefulWidget {
  const ReservationRequestPageOwner({super.key});
  @override
  State<ReservationRequestPageOwner> createState() => _ReservationRequestPageOwnerState();
}

class _ReservationRequestPageOwnerState extends State<ReservationRequestPageOwner> {
  @override
  Widget build(BuildContext context) {
    var reservationProvider = Provider.of<ReservationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation requests'),
        backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor:MyColors.mainThemeLightColor,
      ),
      body: RefreshIndicator(
        onRefresh: reservationProvider.onPageRefresh,
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
        ) : reservationProvider.allReservations.isEmpty || reservationProvider.errorMessage.isNotEmpty ?
        Container(
          height: 300,
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              Text(
                reservationProvider.errorMessage.isNotEmpty ?
                reservationProvider.errorMessage :
                "No Reservations",
                style: const TextStyle(fontSize: 14)
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  reservationProvider.loadReservations().then((value) {
                    if (reservationProvider.errorMessage.isNotEmpty) {
                      SnackBarMessage.make(context, reservationProvider.errorMessage);
                    }
                  });
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ) :
        ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          itemCount: reservationProvider.allReservations.length,
          itemBuilder: (context, index) {
            var reservation = reservationProvider.allReservations.reversed.toList()[index];
            return ReservationRequestCardOwner(
              reservationRequest: reservation,
            );
          },
        ),
      ),
    );
  }
}
