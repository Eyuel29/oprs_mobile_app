import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:latlong2/latlong.dart';
import 'package:oprs/components/cards/review_card.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/listing.dart';
import 'package:oprs/model/review.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oprs/provider/owner_provider.dart';
import 'package:oprs/repo/listing_repo.dart';
import 'package:oprs/repo/review_repo.dart';
import 'package:oprs/provider/custom_image_provider.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/map/map_view.dart';
import 'package:oprs/view/home/property_category.dart';
import 'package:oprs/view/owner/edit_listing_page.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  final Listing listing;
  const DetailsPage({super.key, required this.listing});
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>{
  @override
  Widget build(BuildContext context) {
    CustomImageProvider customImageProvider = CustomImageProvider(photos: widget.listing.urlImages);
    var ownerProvider = Provider.of<OwnerProvider>(context);
    String leaseDuration = widget.listing.leaseDurationDays == 1
      ? "Day" : widget.listing.leaseDurationDays == 7
      ? "Week" : widget.listing.leaseDurationDays == 30
      ? "Month" : "${widget.listing.leaseDurationDays} Days";

    final int averageRating = widget.listing.averageRating ?? 0;

    List<Widget> cachedImages = List.generate(widget.listing.urlImages.length, (index){
      return CachedNetworkImage(
          imageUrl: widget.listing.urlImages[index],
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
              child: SizedBox(height: 200,width: 200,
                  child: Padding(padding: EdgeInsets.all(60),
                      child: CircularProgressIndicator(color:MyColors.mainThemeLightColor,strokeWidth: 2,)
                  )
              )
          ),
          errorWidget: (context, url, error){
            return const Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color:MyColors.mainThemeLightColor),
                      Text("  No internet!",style: TextStyle(fontSize: 16, color:MyColors.mainThemeLightColor))
                    ]
                )
            );
          }
      );
    }
  );

  return Scaffold(
      appBar: AppBar(
        title: const Text("Listing Information"),
         backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor:MyColors.mainThemeLightColor,
      ),
      body: SingleChildScrollView(
          child : ownerProvider.pageLoading ?
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 100),
            child: const SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                color: MyColors.mainThemeDarkColor,
                strokeWidth: 3,
              ),
            )
          ) : ownerProvider.allMyListings.isEmpty || ownerProvider.errorMessage.isNotEmpty ?
          Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  ownerProvider.errorMessage.isNotEmpty ? ownerProvider.errorMessage : "No results",
                  style: const TextStyle(fontSize: 14)
                ),
                const SizedBox(height: 30),
                OutlinedButton(
                  onPressed: () {
                    ownerProvider.loadListings().then((value) {
                      if (ownerProvider.errorMessage.isEmpty) {

                      } else {
                        SnackBarMessage.make(context, ownerProvider.errorMessage);
                      }
                    }).catchError((error) {
                      SnackBarMessage.make(context, ownerProvider.errorMessage);
                    });
                  },
                  child: const Text("Retry"),
                ),
              ],
            )
          ) :
          Column(
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
              Padding(
                padding: const EdgeInsets.all(20),
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
                          )
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
                              [...(List.generate(averageRating,(index){
                                return const Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Colors.yellow,
                                );
                              })),
                                ...(List.generate(5 - averageRating,(index){
                                  return Icon(
                                    Icons.star,
                                    size: 18,
                                    color: MyColors.bodyFontColor.withOpacity(0.2),
                                  );
                                }))
                              ]),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(bottom: 10,left: 10,top: 5),
                      child: Text("Price ${widget.listing.pricePerDuration} "
                          "${widget.listing.paymentCurrency} / "
                          "$leaseDuration"),
                    ),
                    const Divider(
                      height: 1,
                      indent: 5.0,
                      endIndent: 5.0,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Text(
                        widget.listing.description,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                            color: MyColors.bodyFontColor
                        ),
                      ),
                    ),
                    createDetail("Addis Ababa, ${widget.listing.subCity}","assets/icons/location.svg",2,10),
                    createDetail("Specific location Woreda ${widget.listing.woreda}, "
                        "${widget.listing.areaName}","assets/icons/location.svg",2,10),
                    createDetail("Type ${widget.listing.describingTerms.join(", ")}","assets/icons/home.svg",2,10),
                    createDetail("Distance from road: ${widget.listing.distanceFromRoadInMeters}"
                        " m","assets/icons/road.svg",2,10),
                    const Divider(
                      height: 1,
                      indent: 5.0,
                      endIndent: 5.0,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: const Text(
                        "About the property",
                          style: TextStyle(
                              fontSize: 18,
                              color: MyColors.headerFontColor,
                          )
                      ),
                    ),
                    ...getlistingModelDescription(widget.listing),
                    const Divider(
                      height: 1,
                      indent: 5.0,
                      endIndent: 5.0,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: const Text(
                          "Location on map",
                          style: TextStyle(
                            fontSize: 18,
                            color: MyColors.headerFontColor,
                          )
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: MapLocationView(
                          latLng: widget.listing.latLng != null ?
                          widget.listing.latLng! :
                          const LatLng(9.031189291103262, 38.752624277434705),
                        )
                    ),
                    const Divider(
                      height: 1,
                      indent: 5.0,
                      endIndent: 5.0,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                      child: const Text(
                        "Amenities",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: MyColors.headerFontColor,
                        ),
                      )
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.listing.amenities.isEmpty ?
                      [Container(
                        padding : const EdgeInsets.all(15),
                        child: const Text(
                            "No amenities specified by the owner!",
                            style: TextStyle(
                              fontSize: 14,
                              color: MyColors.headerFontColor,
                            )
                        ),
                      )] : List.generate(widget.listing.amenities.length, (index){
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
                  ],
                ),
              )
            ],
          )
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(22.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
             backgroundColor: MyColors.mainThemeDarkColor,
            foregroundColor:MyColors.mainThemeLightColor,
          ),
          onPressed: () {
            showOptionDialog(context).then((option){
              switch(option){
                case "EDIT" :
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditListingPage(
                        listingModel: widget.listing )
                    ),
                  );
                  break;
                case "DELETE" :
                  validateDelete(context).then((val) {
                    if(val ?? false){
                      ownerProvider.pageLoading = true;
                      ListingRepo().deleteListing(widget.listing.listingId).then((value){
                        ownerProvider.pageLoading = false;
                        SnackBarMessage.make(context, value["message"]);
                        ownerProvider.loadListings();
                        Navigator.pop(context);
                      });
                    }
                  });
                  break;
                case "UNAVAILABLE" :
                  ownerProvider.pageLoading = true;
                  ListingRepo().setUnAvailable(widget.listing.listingId).then((value){
                    ownerProvider.pageLoading = false;
                    SnackBarMessage.make(context, value["message"]);
                    ownerProvider.loadListings();
                    Navigator.pop(context);
                  });
                  break;
                case "AVAILABLE" :
                  ownerProvider.pageLoading = true;
                  ListingRepo().setAvailable(widget.listing.listingId).then((value){
                    ownerProvider.pageLoading = false;
                    SnackBarMessage.make(context, value["message"]);
                    ownerProvider.loadListings();
                    Navigator.pop(context);
                  });
                  break;
                default :
                  break;
              }
            });
          },
          child: const Text('Modify'),
        ),
      )
  );
  }

  void showOwnerBottomSheet(BuildContext context){
    late List<Review> reviews;
    ReviewRepo().getUserReview(widget.listing.ownerId).then((value){
      reviews = value["reviews"].where((l) =>
      l.reviewedListingId == widget.listing.listingId).toList();
    });
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
                        child: SvgPicture.asset('assets/icons/pen.svg', color: MyColors.mainThemeLightColor),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: const Text(
                            " Reviews",
                            style: TextStyle(
                              fontSize: 18,
                              color: MyColors.headerFontColor,
                            )
                        ),
                      ),
                      ...(reviews.isEmpty ?
                      [Container(
                        padding : const EdgeInsets.all(10),
                        child:
                        const Text(
                           "This owner has no reviews!",
                            style: TextStyle(
                              fontSize: 14,
                              color: MyColors.bodyFontColor,
                            )
                        ),
                      )] :
                      List.generate((reviews.length) , (index){
                        return ReviewCard(
                          author: reviews[index].reviewAuthor,
                          reviewMessage: reviews[index].reviewMessage,
                          avevrageRating: reviews[index].rating,
                          date: reviews[index].reviewDate,
                        );
                      })
                      )
                    ],
                  )
              )
          );
        }
    ).then((value) {

    });
  }

  Future<bool?> validateDelete(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          alignment: Alignment.center,
          title: const Text('Delete Listing?'),
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

  Future<String?> showOptionDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Options'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'EDIT');
              },
              child: Container(
                  margin : const EdgeInsets.symmetric(vertical: 10),
                  child: const Text('Edit Listing')),
            ),
            ...(
                [widget.listing.listingStatus != 3000 ?
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 'AVAILABLE');
                  },
                  child: Container(
                      margin : const EdgeInsets.symmetric(vertical: 10),
                      child: const Text('Set Available')),
                ) :
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 'UNAVAILABLE');
                  },
                  child: Container(
                      margin : const EdgeInsets.symmetric(vertical: 10),
                      child: const Text('Set Unvavailable')),
                )]
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'DELETE');
              },
              child: Container(
                  margin : const EdgeInsets.symmetric(vertical: 10),
                  child: const Text('Delete Listing')),
            ),
          ],
        );
      },
    );
  }
}