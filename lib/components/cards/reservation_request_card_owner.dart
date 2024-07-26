import 'package:flutter/material.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/reservation.dart';
import 'package:oprs/view/reservation_request/reservation_request_detail_page.dart';
import 'package:timeago/timeago.dart' as timeago;
class ReservationRequestCardOwner extends StatelessWidget {
  final Reservation reservationRequest;
  const ReservationRequestCardOwner({ super.key, required this.reservationRequest  });
  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ru', timeago.RuMessages());
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: MyColors.bodyFontColor.withOpacity(0.06),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
        color:MyColors.mainThemeLightColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              "Request ${reservationRequest.reservationId}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: MyColors.mainThemeDarkColor,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Listing ID",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Listing ${reservationRequest.listingId}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Status",
                style: TextStyle(
                  fontSize: 14,
                  color: MyColors.headerFontColor,
                ),
              ),
              const SizedBox(width: 8),
              reservationRequest.status == 3000 ?
              const Text("Approved") : reservationRequest.status == 2000 ?
              const Text("Pending") : const Text("Declined"),
            ],
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Message",
                style: TextStyle(
                  fontSize: 14,
                  color: MyColors.headerFontColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Wrap(
            children: [
              Text(
                reservationRequest.additionalMessage,
                style: const TextStyle(
                    color: MyColors.bodyFontColor
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Date",
                style: TextStyle(
                  fontSize: 14,
                  color: MyColors.headerFontColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(reservationRequest.date.substring(0,10)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: CustomElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                ReservationRequestDetailPage(reservation: reservationRequest)
                        ));
                      },
                      isLoading: false,
                      loadingText: "Loading",
                      loadingTextColor:MyColors.mainThemeLightColor,
                      buttonText: "View",
                      buttonTextColor:MyColors.mainThemeLightColor,
                      buttonTextBackgroundColor: Colors.redAccent
                  )
              )
            ],
          ),
        ],
      ),
    );
  }
}