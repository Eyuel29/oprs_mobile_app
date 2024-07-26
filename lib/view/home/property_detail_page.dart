import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:latlong2/latlong.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/button/custom_outlined_button.dart';
import 'package:oprs/components/cards/review_card.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/listing.dart';
import 'package:oprs/model/review.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oprs/repo/review_repo.dart';
import 'package:oprs/provider/custom_image_provider.dart';
import 'package:oprs/view/map/map_view.dart';
import 'package:oprs/view/home/property_category.dart';
import 'package:oprs/view/reservation_request/reservation_request_form_page.dart';
import 'package:oprs/view/review/write_review.dart';

class DetailsScreen extends StatefulWidget {
  final Listing listing;
  final bool reserved;
  const DetailsScreen({
    super.key,
    required this.listing, this.reserved = false
  });

  @override
  State<StatefulWidget> createState() => _DetailsScreenState();
}
class _DetailsScreenState extends State<DetailsScreen> {

  bool reviewsWaiting = false;
  late CustomImageProvider customImageProvider;
  late String leaseDuration;
  late int averageRating;
  late List<CachedNetworkImage> cachedImages;


  @override
  void initState() {
    super.initState();
    customImageProvider = CustomImageProvider(photos: widget.listing.urlImages);
    leaseDuration = widget.listing.leaseDurationDays == 1 ?
    "Day" : widget.listing.leaseDurationDays == 7 ? "Week" : "Month";
    averageRating = widget.listing.averageRating;
    cachedImages = List.generate(widget.listing.urlImages.length, (index){
      return CachedNetworkImage(
        imageUrl: widget.listing.urlImages[index],
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Padding(
              padding: EdgeInsets.all(60),
              child: CircularProgressIndicator(
                color:MyColors.mainThemeLightColor,
                strokeWidth: 2
              )
            )
          )
        ),
        errorWidget: (context, url, error){
          return const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color:MyColors.mainThemeLightColor),
                Text(
                  "  No internet!",
                  style: TextStyle(
                    fontSize: 14,
                    color:MyColors.mainThemeLightColor
                  )
                )
              ]
            )
          );
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Listing Information"),
           backgroundColor: MyColors.mainThemeDarkColor,
          foregroundColor:MyColors.mainThemeLightColor,
        ),
        body: SingleChildScrollView(
          controller: ScrollController(

          ),
          child: Column(
            children: [
              Container(
                color: MyColors.headerFontColor,
                height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child:  GestureDetector(
                    onTap : () {
                      showImageViewerPager(
                        context,
                        customImageProvider,
                        doubleTapZoomable: true,
                        swipeDismissible: true,
                      );
                    },
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.6,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        viewportFraction: 1,
                      ),
                      items: cachedImages,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 20,left: 10,bottom: 5),
                      child: Text(
                        widget.listing.title,
                        style: const TextStyle(
                            fontSize: 20,
                            color: MyColors.headerFontColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("${widget.listing.reviewCount}"
                              " Review${widget.listing.reviewCount == 1 ? "" : "s"}"),
                          Wrap(
                              alignment: WrapAlignment.end,
                              children: widget.listing.reviewCount == 0 ? [] :
                              [
                                ...(List.generate(averageRating,(index){
                                  return const Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.yellow,
                                  );
                                }
                                )
                                ),
                                ...(List.generate(5 - averageRating,(index){
                                  return Icon(
                                    Icons.star,
                                    size: 18,
                                    color: MyColors.bodyFontColor.withOpacity(0.2),
                                  );
                                }
                                )
                                )
                              ]
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(bottom: 10,left: 10,top: 5),
                      child: Text("Price ${widget.listing.pricePerDuration} "
                          "${widget.listing.paymentCurrency} /"
                          "$leaseDuration"),
                    ),
                    const Divider(height: 1),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Text(
                        widget.listing.description,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(color: MyColors.bodyFontColor),
                      ),
                    ),
                    const Divider(height: 1),
                    createDetail(
                        "Addis Ababa, "
                            "${widget.listing.subCity}",
                        "assets/icons/location.svg",
                        2, 10
                    ),
                    createDetail(
                        "Specific location Woreda ${widget.listing.woreda}, "
                            "${widget.listing.areaName}",
                        "assets/icons/location.svg",
                        2, 10
                    ),
                    createDetail(
                        "Type ${widget.listing.describingTerms.join(", ")}",
                        "assets/icons/home.svg",
                        2, 10
                    ),
                    createDetail(
                        "Distance from road: ${widget.listing.distanceFromRoadInMeters}"
                            " m",
                        "assets/icons/road.svg",
                        2, 10
                    ),
                    const Divider(height: 1),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: const Text(
                        "About the Property",
                        style: TextStyle(
                            fontSize: 18,
                            color: MyColors.headerFontColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    ...getlistingModelDescription(widget.listing),
                    const Divider(height: 1),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: const Text(
                        "Location on Map",
                        style: TextStyle(
                            fontSize: 18,
                            color: MyColors.headerFontColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: MapLocationView(
                          latLng: widget.listing.latLng != null ?
                          widget.listing.latLng! :
                          const LatLng(9.031189291103262,38.752624277434705),
                        )
                    ),
                    const Divider(height: 1),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                      child: const Text(
                        "Amenities",
                        style: TextStyle(
                            fontSize: 18,
                            color: MyColors.headerFontColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.listing.amenities.isEmpty ?
                      [Container(
                        padding : const EdgeInsets.all(15),
                        child: const Text(
                          "No amenities",
                          style: TextStyle(
                              fontSize: 13,
                              color: MyColors.headerFontColor,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      )] : List.generate(widget.listing.amenities.length , (index){
                        return Container(
                            decoration: BoxDecoration(
                              color: MyColors.bodyFontColor.withOpacity(0.1),
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                            ),
                            padding : const EdgeInsets.all(15),
                            child: Wrap(
                              runSpacing: 10,
                              children: [
                                Text(
                                    widget.listing.amenities[index],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: MyColors.headerFontColor,
                                    )
                                ),
                              ],
                            )
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: const Text(
                        "Reviews",
                        style: TextStyle(
                            fontSize: 18,
                            color: MyColors.headerFontColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children : [
                          Expanded(
                            child: CustomOutlinedButton(
                                onPressed: (){
                                  showOwnerBottomSheet(context);
                                },
                                isLoading: reviewsWaiting,
                                loadingText: "Waiting",
                                loadingTextColor: MyColors.mainThemeDarkColor,
                                buttonText: "Show Reviews",
                                buttonTextColor: MyColors.mainThemeDarkColor,
                                buttonTextBackgroundColor: MyColors.mainThemeLightColor,
                                radius: 10,
                                insetV: 25
                            ),
                          ),
                        ]
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                              onPressed: (){
                                showReviewBottomSheet(context);
                              },
                              isLoading: false,
                              loadingText: "Waiting",
                              loadingTextColor:MyColors.mainThemeLightColor,
                              buttonText: "Write review",
                              buttonTextColor:MyColors.mainThemeLightColor,
                              buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                              radius: 10,
                              insetV: 25
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 90)
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: widget.reserved ? Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(22.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: Colors.redAccent,
              foregroundColor:MyColors.mainThemeLightColor,
            ),
            onPressed: () {

            },
            child: const Text('Reserved'),
          ),
        ) :
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(22.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)
              ),
              backgroundColor: MyColors.mainThemeDarkColor,
              foregroundColor:MyColors.mainThemeLightColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReservationRequestFormPage(listing: widget.listing)),
              );
            },
            child: const Text('Reserve'),
          ),
        )
    );
  }

  void showReviewBottomSheet (BuildContext context) {
    showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.90,
      builder: (context){
        return ReviewPage(userId: widget.listing.ownerId, listingId: widget.listing.listingId);
    }).then((value) {

    });
  }

  void showOwnerBottomSheet(BuildContext context){
    late List<Review> reviews;
    setState(() { reviewsWaiting = true; });
    ReviewRepo().getUserReview(widget.listing.ownerId).then((value){
      setState(() { reviewsWaiting = false; });
      reviews = value["reviews"].where((l) => l.reviewedListingId == widget.listing.listingId).toList();
      showModalBottomSheet(
          context: context,
          scrollControlDisabledMaxHeightRatio: 0.90,
          builder: (BuildContext context) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 100,
                      width: 100,
                      child: SvgPicture.asset('assets/icons/pen.svg', color: MyColors.mainThemeDarkColor),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: const
                      Text(
                        "Reviews",
                        style: TextStyle(
                          fontSize: 18,
                          color: MyColors.headerFontColor,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    ...(
                      reviews.isEmpty ? [
                        Container(
                          padding : const EdgeInsets.all(10),
                          child: const
                          Text(
                            "This owner has no reviews!",
                            style: TextStyle(
                              fontSize: 13,
                              color: MyColors.headerFontColor,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ] : List.generate((reviews.length) , (index){
                        return ReviewCard(
                          author: reviews[index].reviewAuthor,
                          reviewMessage: reviews[index].reviewMessage,
                          avevrageRating: reviews[index].rating,
                          date: reviews[index].reviewDate,
                        );
                      }
                    )
                  )
                ],
              )
            ));
          }
        );
      }
    );
  }
}