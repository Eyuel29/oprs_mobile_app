import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/listing.dart';
import 'package:oprs/provider/reservation_provider.dart';
import 'package:oprs/view/owner/owner_property_details_page.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PropertyCardOwner extends StatelessWidget{
  final Listing listing;
  final double radius;

  const PropertyCardOwner({
    super.key,
    this.radius = 10,
    required this.listing,
  });

  @override
  Widget build(BuildContext context){
    final int averageRating = listing.averageRating;
    timeago.setLocaleMessages('ru', timeago.RuMessages());
    var reservationProvider = Provider.of<ReservationProvider>(context);

    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(listing: listing)
          )
        );
      },
      child: Ink(
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
            if (listing.urlImages.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius)
                ),
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.7,
                  imageUrl: listing.urlImages[0],
                  placeholder: (context, url) => const Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                          color: MyColors.mainThemeDarkColor,
                          strokeWidth: 1,
                        )
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
                            Text("Error!")
                          ],
                        )
                      ),
                    );
                  }, // Widget to display on error
                  fit: BoxFit.cover,
                )
              ),
            ] else ...[
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: MyColors.bodyFontColor.withOpacity(0.2),
                child: const Center(
                  child: Text("No Image Available"),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: MyColors.headerFontColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: listing.reviewCount == 0 ? [] :
                        [
                          ...(List.generate(averageRating,(index){
                                return const Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.yellow,
                                );
                              }
                            )
                          ),
                          ...(List.generate(5 - averageRating,(index){
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
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 4,
                            child: Wrap(
                              children: [
                                Icon(
                                  Icons.rate_review_sharp,
                                  color: MyColors.mainThemeDarkColor,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Review Count",
                                  style: TextStyle(
                                    fontSize: 11,
                                  ),
                                )
                              ],
                            )
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${listing.reviewCount}",
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            )
                          )
                        ],
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      child: Row(
                        children: [
                          const Expanded(
                              flex: 4,
                              child: Wrap(
                                children: [
                                  Icon(
                                    Icons.show_chart_rounded,
                                    color: MyColors.mainThemeDarkColor,
                                    size: 18,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Reach",
                                    style: TextStyle(
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              )
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${listing.views}",
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            )
                          )
                        ],
                      )
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 4,
                              child: Wrap(
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    color: MyColors.mainThemeDarkColor,
                                    size: 18,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Average rating",
                                    style: TextStyle(
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "${listing.averageRating}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            )
                          ],
                       )
                    ),

                    Container(
                      margin: const EdgeInsets
                      .symmetric(
                        vertical: 5,
                        horizontal: 0
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 4,
                            child: Wrap(
                              children: [
                                Icon(
                                  Icons.question_mark_sharp,
                                  color: MyColors.mainThemeDarkColor,
                                  size: 18,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Reservations Requests",
                                  style: TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            )
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${reservationProvider.allReservations.length}",
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            )
                          )
                        ],
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                color: listing.listingStatus == 3000 ? Colors.green :
                                Colors.red,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10)
                                )
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                listing.listingStatus == 3000 ?
                                "Available" :
                                "Not available",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color:MyColors.mainThemeLightColor
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            timeago.format(DateTime.parse(listing.dateCreate)),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 11,
                            ),
                          ),
                        )
                      ],
                    )
                 ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}