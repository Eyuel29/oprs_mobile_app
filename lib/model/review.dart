class Review{
  final String reviewDate, reviewAuthor;
  final String reviewMessage;
  final int rating;
  int reviewedListingId, authorId, receiverId;

  Review({
    required this.reviewAuthor,
    required this.reviewDate,
    required this.reviewMessage,
    required this.rating,
    required this.authorId,
    required this.receiverId,
    required this.reviewedListingId
  });

  static int getAverageRating(List<Review> reviews){
    if(reviews.isEmpty){
      return 0;
    }
    double totalReview = 0;
    for (var element in reviews) {
      totalReview += element.rating;
    }
    totalReview = totalReview/reviews.length;
    return totalReview.toInt();
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewAuthor: json["author_name"],
      authorId: json["author_id"],
      reviewedListingId: json["reviewed_listing_id"],
      receiverId: json["receiver_id"],
      reviewMessage: json["review_message"],
      rating: json["rating"],
      reviewDate: json["review_date"],
    );
  }
}