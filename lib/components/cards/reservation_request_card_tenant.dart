import 'package:flutter/material.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/reservation.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReservationRequestCardTenant extends StatelessWidget{
  final Reservation reservationRequest;
  final void Function() onCancelRequest;
  final void Function() onReviewRequest;
  const ReservationRequestCardTenant({
    super.key,
    required this.reservationRequest,
    required this.onCancelRequest,
    required this.onReviewRequest,
  });

  @override
  build(BuildContext context) {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children : [
                Text(
                  "Request${reservationRequest.reservationId}",
                  style: const TextStyle(
                    color: MyColors.mainThemeDarkColor,
                    fontSize: 18,
                  ),
                ),
                Text(
                    style: const TextStyle(fontSize: 14),
                    reservationRequest.status == 3000 ?
                    "Approved" : reservationRequest.status == 2000 ? "Pending" : "Declined"
                )
              ]
            ),
          ),
          const SizedBox(height: 5),
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellowAccent.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Text(
                  reservationRequest.additionalMessage,
                  style: const TextStyle(
                      color: MyColors.bodyFontColor
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: CustomElevatedButton(
                      onPressed: onReviewRequest,
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
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                style: const TextStyle(fontSize: 12),
                  timeago.format(
                    DateTime.parse(reservationRequest.date)
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }
}