import 'package:oprs/constant_values.dart';
import 'package:oprs/http/dio_intance.dart';
import 'package:oprs/model/review.dart';

class ReviewRepo{
  final _client = DioSingleton().dioInstance;

  Future<Map<String, dynamic>> getUserReview(int userId) async{
    Map<String, dynamic> result = {};
    List<Review> allReviews = [];
    try{
      var response = await _client.get("${Routes.base}/review/user/$userId");
      switch(response.statusCode){
        case 200 :
          for(var review in List.from(response.data["body"])){
            allReviews.add(Review.fromJson(Map.from(review)));
          }
          result = {
          "status": response.statusCode,
          "message": "Loaded all user reviews!",
          "reviews": allReviews
        };
        break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"],
          };
          break;
      }
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
      };
    }
    return result;
  }


  Future<Map<String, dynamic>> createReview(Map<String, dynamic> review) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.post("${Routes.base}/review/create", data: {
        "author_id" : review["author_id"],
        "author_name" : review["author_name"],
        "receiver_id" : review["receiver_id"],
        "reviewed_listing_id" : review["reviewed_listing_id"],
        "review_message" : review["review_message"],
        "rating" : review["rating"]
      });
      switch(response.statusCode){
        case 200 :
          result = {
            "status": response.statusCode,
            "message": response.data["message"],
          };
          break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"],
          };
          break;
      }
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
      };
    }
    return result;
  }


  Future<Map<String, dynamic>> getListingReview(int listingId) async{
    Map<String, dynamic> result = {};
    List<Review> allReviews = [];
    try{
      var response = await _client.get("${Routes.base}/review/listing/$listingId");
      switch(response.statusCode){
        case 200 :
          for(var review in List.from(response.data["body"])){
            allReviews.add(Review.fromJson(Map.from(review)));
          }
          result = {
            "status": response.statusCode,
            "message": "Loaded all listing reviews!",
            "reviews": allReviews
          };
          break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"],
          };
          break;
      }
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
      };
    }
    return result;
  }
}