import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/listing.dart';
import 'package:oprs/view/home/property_detail_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class PropertyCardTenant extends StatelessWidget{
  final Listing listing;
  final double radius;
  const PropertyCardTenant({
    super.key,
    this.radius = 10,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ru', timeago.RuMessages());
    final int averageRating = listing.averageRating;
    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsScreen(listing: listing)
            )
        );
      },
      child: Ink(
        width: screenWidth / 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          boxShadow: [
            BoxShadow(
              color: MyColors.bodyFontColor.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
          color:MyColors.mainThemeLightColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.circular(radius)
              ),
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.5,
                imageUrl: listing.urlImages[0],
                placeholder: (context, url) => Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(40),
                    child: const CircularProgressIndicator(
                      color: MyColors.mainThemeDarkColor,
                      strokeWidth: 1,
                    )
                  )
                ),
                errorWidget: (context, url, error){
                    return const SizedBox(
                    height: 100,width: 100,
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Row(
                          children: [
                            Icon(Icons.error),
                            SizedBox(width: 2),
                            Text("Error")
                          ],
                        )
                      ),
                    );
                  },
                fit: BoxFit.cover,
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title.length > 16 ? "${listing.title.substring(0, 16)}..." :
                    listing.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: MyColors.headerFontColor
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: listing.reviewCount == 0 ? [] :
                        [
                          ...(
                          List.generate(averageRating,(index){
                                return const Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.yellow,
                                );
                              }
                            )
                          ),
                          ...(
                          List.generate(5 - averageRating,(index){
                              return Icon(
                                Icons.star,
                                size: 15,
                                color: MyColors.bodyFontColor.withOpacity(0.2),
                              );
                            }
                          )
                        )
                      ]
                    )
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    child:
                    Text(
                      listing.description.length > 100 ?
                      "${listing.description.substring(0, 100)}..." : listing.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: MyColors.bodyFontColor
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15,width: 15,
                        child: SvgPicture.asset("assets/icons/location.svg", color: Colors.lightBlue,)
                      ),
                      Expanded(
                        flex: 1,
                        child : Text(
                          " ${listing.subCity}, ${listing.areaName}",
                          style: const TextStyle(
                              fontSize: 12,
                              color: MyColors.bodyFontColor
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15,width: 15,
                        child: SvgPicture.asset("assets/icons/price.svg", color: Colors.red,)
                      ),
                      Expanded(
                        flex: 1,
                        child: Wrap(
                          children: [
                            Text(
                              " ${listing.pricePerDuration} ${listing.paymentCurrency} / ${listing.leaseDurationDays == 1 ?
                              "Day" : listing.leaseDurationDays == 7 ?
                              "Week" : "Month"}",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: MyColors.bodyFontColor
                              ),
                            )
                          ]
                        )
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          Text(
                            timeago.format(DateTime.parse(listing.dateCreate)),
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          )
                        ]
                      )
                    ],
                  )
                ],
              ),
            )
          ]
        ),
      ),
    );
  }
}