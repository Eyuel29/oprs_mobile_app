import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/input/custom_text_input.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/provider/account_provider.dart';
import 'package:oprs/repo/review_repo.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  final int listingId;
  final int userId;
  const ReviewPage({
    super.key,
    required this.userId,
    this.listingId = 0
  });
  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  String message = "";
  bool waiting = false;
  double rating = 0.0;
  Map<String, String> inputErrors = {
    "review" : "",
    "rating" : ""
  };
  @override
  Widget build(BuildContext context) {
    var accountProvider = Provider.of<AccountProvider>(context);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: const Text(
                "Write a Review",
                style: TextStyle(
                  fontSize: 20,
                  color: MyColors.headerFontColor,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Rating',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.center,
                    child: RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      glowColor: Colors.yellow,
                      itemSize: 25,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (r) {
                        setState(() {
                          rating = r;
                        });
                      },
                    ),
                  )
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              inputErrors["rating"]!,
              style: const TextStyle(fontSize: 14, color: Colors.red),
            ),
            CustomTextInput(
              hintText: 'Message',
              inputType: TextInputType.multiline,
              maxLines: 15,
              minLines: 5,
              maxValue: 500,
              obscureText: false,
              initialValue: message,
              onChanged: (text) {
                setState(() {
                  if (text.isNotEmpty && text.length < 50) {
                    inputErrors["review"] = "Review too short!";
                  } else {
                    inputErrors["review"] = "";
                  }
                  message = text;
                });
              },
              errorText: inputErrors["review"]!.isNotEmpty ? inputErrors["review"] : null,
            ),

            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    onPressed: (){
                      if(message.isNotEmpty && rating != 0){
                        setState(() {waiting = true;});
                        ReviewRepo().createReview({
                          "author_id" : accountProvider.user.userId,
                          "author_name" : accountProvider.user.fullName,
                          "receiver_id" : widget.userId,
                          "reviewed_listing_id" : widget.listingId,
                          "review_message" : message,
                          "rating" : rating
                        }).then((value) => {
                          setState(() {waiting = false;}),
                          SnackBarMessage.make(context, value["message"]),
                          Navigator.pop(context)
                        }).catchError((error) => {
                          SnackBarMessage.make(context, "Something went wrong!"),
                          setState(() {waiting = false;})
                        });
                      }else{
                        SnackBarMessage.make(context, "Please provide full information!");
                      }
                    },
                    isLoading: waiting,
                    loadingText: "Waiting",
                    loadingTextColor: MyColors.mainThemeDarkColor,
                    buttonText: "Submit",
                     buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                    buttonTextColor:MyColors.mainThemeLightColor,
                    insetV: 25,
                    radius: 10,
                  ),
                )
              ],
            )
          ],
        ),
      );
  }
}