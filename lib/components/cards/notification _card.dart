import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/notification.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends StatelessWidget {
  final NotificationModel notificationModel;
  const NotificationCard({super.key, required this.notificationModel});
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              notificationModel.type == "BILL" ? const Icon(Icons.payment, size: 25) :
              SvgPicture.asset(
                  "assets/icons/notification.svg",
                  height: 25,
                  width: 25
              ),
              const SizedBox(width: 16.0),
              Expanded(
                  child: Text(
                      notificationModel.title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: MyColors.mainThemeDarkColor,
                      )
                  )
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        notificationModel.body,
                        style: const TextStyle(
                            fontSize: 12
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: Text(
                  timeago.format(
                      DateTime.parse(notificationModel.date)
                  ),
                  style: const TextStyle(
                      color: MyColors.bodyFontColor,
                      fontSize: 12
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}