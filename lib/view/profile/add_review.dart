import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:oprs/constant_values.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Review"),
          backgroundColor: MyColors.mainThemeDarkColor,
          foregroundColor: MyColors.mainThemeLightColor,
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _ ) => const Icon(
                    Icons.star,
                    color: MyColors.mainThemeDarkColor,
                  ),
                  onRatingUpdate: (rating) {

                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  minLines: 1,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: MyColors.mainThemeDarkColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MyColors.mainThemeDarkColor)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(onPressed: () {

                }, child: const Text("Submit"))
              ],
            ),
          ),
        ));
  }
}
