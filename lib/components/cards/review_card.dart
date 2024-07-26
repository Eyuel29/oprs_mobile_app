import 'package:flutter/material.dart';
import 'package:oprs/constant_values.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewCard extends StatelessWidget {
  final String reviewMessage, date;
  final String author;
  final int avevrageRating;
  const ReviewCard({
    super.key,
    required this.reviewMessage,
    required this.date,
    required this.avevrageRating,
    required this.author
  });

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.center,
              child:  Icon(Icons.account_circle_rounded, color: MyColors.bodyFontColor.withOpacity(0.2), size: 50)
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(reviewMessage),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                        alignment: WrapAlignment.end,
                        children: [...(List.generate(avevrageRating,(index){
                          return const Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.yellow,
                          );
                        })),
                          ...(List.generate(5 - avevrageRating,(index){
                            return Icon(
                              Icons.star,
                              size: 18,
                              color: MyColors.bodyFontColor.withOpacity(0.2),
                            );
                          }))
                        ]
                    ),
                    Text(timeago.format(DateTime.parse(date))),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}