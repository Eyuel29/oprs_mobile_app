import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/button/custom_outlined_button.dart';
import 'package:oprs/components/cards/review_card.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/review.dart';
import 'package:oprs/model/user.dart';
import 'package:oprs/provider/account_provider.dart';
import 'package:oprs/repo/review_repo.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/review/write_review.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
class UserProfile extends StatefulWidget {
  final User user;
  const UserProfile({
    super.key,
    required this.user
  });
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>{
  bool contactsWaiting = false;
  bool reviewsWaiting = false;
  List<Review> allReviews = [];
  List<Map<String, String>> allContacts = [];

  @override
  Widget build(BuildContext context) {
    var accountProvider = Provider.of<AccountProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor: MyColors.mainThemeLightColor,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10, right: 15, left: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: accountProvider.user.photoUrl.isEmpty ?
                      Icon  (
                          Icons.account_circle_rounded,
                          color: MyColors.bodyFontColor.withOpacity(0.2),
                          size: 120
                      ) :
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: CachedNetworkImage(
                          height: 100,
                          width: 100,
                          imageUrl: accountProvider.user.photoUrl,
                          placeholder: (context, url) => const Center(
                              child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: CircularProgressIndicator(
                                        color:
                                        MyColors.mainThemeDarkColor,
                                        strokeWidth: 1,
                                      )
                                  )
                              )
                          ),
                          errorWidget: (context, url, error) {
                            return const SizedBox(
                              height: 120,
                              width: 120,
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(Icons.error)
                              ),
                            );
                          }, // Widget to display on error
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              accountProvider.user.fullName,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: MyColors.headerFontColor
                              )
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              widget.user.userRole == 1000 ? "Tenant" : "Property Owner",
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: MyColors.bodyFontColor
                              )
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Divider(height: 1),
              const SizedBox(height: 5),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    children : [
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children : [
                              const Text(
                                "Phone Number",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: MyColors.headerFontColor,
                                )
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.user.phoneNumber,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: MyColors.bodyFontColor,
                                ),
                              ),
                            ]
                        )
                      ),
                      const Divider(height: 1),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children : [
                            const Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 16,
                                color: MyColors.headerFontColor,
                              )
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.user.email,
                              style: const TextStyle(
                                fontSize: 13,
                                color: MyColors.bodyFontColor,
                              ),
                            ),
                          ]
                        )
                      ),
                      const Divider(height: 1),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children : [
                            const Text(
                              "Date Joined",
                              style: TextStyle(
                                fontSize: 16,
                                color: MyColors.headerFontColor,
                              )
                            ),
                            const SizedBox(height: 5),
                            Text(
                              timeago.format(DateTime.parse(widget.user.dateJoined)),
                              style: const TextStyle(
                                fontSize: 13,
                                color: MyColors.bodyFontColor,
                              ),
                            ),
                          ]
                        )
                      ),
                      const Divider(height: 1),
                    ]
                 ),
              ),
              Visibility(
                visible: widget.user.userRole == 2000,
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children : [
                      const Text(
                        "Contact Information",
                        style: TextStyle(
                          fontSize: 16,
                          color: MyColors.headerFontColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      contactsWaiting ? Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(top: 300),
                          padding: const EdgeInsets.all(10),
                          child: const SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              color: MyColors.mainThemeDarkColor,
                              strokeWidth: 3,
                            ),
                          )
                      ) : allContacts.isEmpty ?
                      const Text(
                        "No Additional Address!",
                        style: TextStyle(
                            fontSize: 14,
                            color: MyColors.bodyFontColor,
                            fontWeight: FontWeight.normal
                        ),
                      ) : Column(
                        children: [
                          ...(
                              List.generate(allContacts.length, (index){
                                return Wrap(
                                  children: [
                                    Text("${allContacts[index]["full_name"]} : "),
                                    Text("${allContacts[index]["contact_address"]}"),
                                  ]
                                );
                              }
                            )
                          )
                        ],
                      ),
                    ]
                  )
                )
              ),
              Visibility(
                visible: widget.user.userRole == 1000,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children : [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children : [
                            const Text(
                              "Location",
                              style: TextStyle(
                                fontSize: 16,
                                color: MyColors.headerFontColor,
                              ),
                            ),
                            Text(
                              "From ${widget.user.region}, ${widget.user.subCity}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: MyColors.bodyFontColor,
                                fontWeight: FontWeight.normal
                              ),
                            ),
                          ]
                        )
                      ),
                      const Divider(height: 1),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children : [
                            const Text(
                              "Marital Status",
                              style: TextStyle(
                                fontSize: 16,
                                color: MyColors.headerFontColor,
                              )
                            ),
                            Text(
                              widget.user.married ? "married" : "Not married",
                              style: const TextStyle(
                                fontSize: 14,
                                color: MyColors.bodyFontColor,
                              )
                            ),
                          ]
                        )
                      ),
                      const Divider(height: 1),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children : [
                            const Text(
                              "Job Description",
                              style: TextStyle(
                                fontSize: 16,
                                color: MyColors.headerFontColor,
                              )
                            ),
                            Text(
                              "Working ${widget.user.jobType} in ${widget.user.subCity}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: MyColors.bodyFontColor,
                              )
                            ),
                          ]
                        )
                      ),
                    ]
                  ),
                )
              ),
              Visibility(
                visible: accountProvider.user.userId != widget.user.userId,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        child: CustomElevatedButton(
                          onPressed: (){
                            writeReviewBottomSheet(context);
                          },
                          isLoading: false,
                          loadingText: "Loading",
                          loadingTextColor: MyColors.mainThemeLightColor,
                          buttonText: "Write Review",
                          buttonTextColor: MyColors.mainThemeLightColor,
                          buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                          insetV: 25,
                          radius: 15,
                        ),
                      ),
                    )
                  ],
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children : [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 25, right: 15, left: 15),
                      child: CustomOutlinedButton(
                        onPressed: (){
                          showReviewBottomSheet(context);
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
                  ),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }

  void writeReviewBottomSheet (BuildContext context) {
    showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.90,
      builder: (context){
        return ReviewPage(userId : widget.user.userId);
    }).then((value) {

    });
  }

  void showReviewBottomSheet(BuildContext context){
    late List<Review> reviews;
    setState(() {reviewsWaiting = true;});
    ReviewRepo().getUserReview(widget.user.userId).then((value){
      setState(() {reviewsWaiting = false;});
      reviews = value["reviews"];
        if(mounted){
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
                              child: SvgPicture.asset(
                                'assets/icons/pen.svg',
                                color: MyColors.mainThemeDarkColor
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, bottom: 20),
                              child: const Text(
                                "Reviews",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.headerFontColor,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            ...(reviews.isEmpty ?
                            [Container(
                              padding : const EdgeInsets.all(10),
                              child: const
                              Text(
                                "User has no reviews!",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: MyColors.headerFontColor,
                                    fontWeight: FontWeight.bold
                                ),
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
          );
        }
     }).catchError((error){
       SnackBarMessage.make(context, "Something went wrong!");
    });
  }
}
