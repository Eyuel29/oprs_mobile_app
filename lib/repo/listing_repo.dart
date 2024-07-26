import 'package:dio/dio.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/http/dio_intance.dart';
import 'package:oprs/model/filter.dart';
import 'package:oprs/model/listing.dart';

class ListingRepo{
  final _client = DioSingleton().dioInstance;

  Future<Map<String, dynamic>> getPageListing(int page, Filter filterModel) async{
    Map<String, dynamic> result = {};
    List<Listing> allModels = [];
    try{
      var response = await _client.get(
        "${Routes.base}/listing/page/$page",
        queryParameters: filterModel.toJson()
      );
      switch(response.statusCode){
        case 200 :
        for (var element in List.from(response.data["body"])) {
          allModels.add(Listing.fromJson(Map.from(element)));
        }

        result = {
          "status" : response.statusCode,
          "message": " Loaded listings at page $page",
          "listingCount" : response.data["totalListings"],
          "listings":  allModels
        };
        break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"],
            "listingCount" : 0,
            "listings" : []
          };
          break;
      }
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
        "listingCount" : 0,
        "listings" : []
      };
    }
    return result;
  }


  Future<Map<String, dynamic>> getPageMatchingResults(int page, String searchQuery) async{
    Map<String, dynamic> result = {};
    List<Listing> allModels = [];
    try{
      var response = await _client.get("${Routes.base}/listing/search/$page/$searchQuery");
      switch(response.statusCode){
        case 200 :
          for (var element in List.from(response.data["body"])) {
            allModels.add(
              Listing.fromJson(
                  Map.from(element)
              )
            );
          }
          result = {
            "status" : response.statusCode,
            "message": " Loaded $searchQuery related listings at page $page",
            "listingCount" : response.data["totalListings"],
            "listings":  allModels
          };
          break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"],
            "listingCount" : 0,
            "listings" : []
          };
          break;
      }
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
        "listingCount" : 0,
        "listings" : []
      };
    }
    return result;
  }


  Future<Map<String, dynamic>> getOwnerListing() async{
    Map<String, dynamic> result = {};
    List<Listing> allModels = [];
    try{
      var response = await _client.get("${Routes.base}/listing/owner");
      switch(response.statusCode){
        case 200 :
          for (var element in List.from(response.data["body"])) {
            allModels.add(Listing.fromJson(Map.from(element)));
          }
          result = {
            "status" : response.statusCode,
            "message": " Loading your listings!",
            "listings":  allModels
          };
          break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"],
            "listings" : []
          };
          break;
      }
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
        "listings" : []
      };
    }
    return result;
  }
  Future<Map<String, dynamic>> getListing(int listingId) async{
    Map<String, dynamic> result = {};
    late Listing listing;
    try{
      var response = await _client.get("${Routes.base}/listing/get/$listingId");
      switch(response.statusCode){
        case 200 :
          listing = Listing.fromJson(Map.from(response.data["body"]));
          result = {
            "status" : response.statusCode,
            "message": " Loading the listing!",
            "listing":  listing
          };
          break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"],
            "listings" : null
          };
          break;
      }
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
        "listings" : null
      };
    }
    return result;
  }
  Future<Map<String, dynamic>> createListing(FormData listing) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.post("${Routes.base}/listing/create",
          options: Options(
            sendTimeout: const Duration(minutes: 5),
            contentType: Headers.formUrlEncodedContentType,
          ),
        data: listing
      );
      result = {
        "status": response.statusCode,
        "message": response.data["message"],
      };
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
      };
    }
    return result;
  }
  Future<Map<String, dynamic>> modifyListing(FormData listing, int listingId) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.put("${Routes.base}/listing/modify/$listingId",
          options: Options(
            sendTimeout: const Duration(minutes: 5),
            contentType: Headers.formUrlEncodedContentType,
          ),
          data: listing
      );
      result = {
        "status": response.statusCode,
        "message": response.data["message"],
      };
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
      };
    }
    return result;
  }


  Future<Map<String, dynamic>> setAvailable(int listingId) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.put("${Routes.base}/listing/setAvailable/$listingId",
          options: Options(
            sendTimeout: const Duration(minutes: 5),
            contentType: Headers.formUrlEncodedContentType,
          ),
      );
      result = {
        "status": response.statusCode,
        "message": response.data["message"],
      };
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
      };
    }
    return result;
  }


  Future<Map<String, dynamic>> setUnAvailable(int listingId) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.put("${Routes.base}/listing/setUnAvailable/$listingId",
        options: Options(
          sendTimeout: const Duration(minutes: 5),
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      result = {
        "status": response.statusCode,
        "message": response.data["message"],
      };
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
      };
    }
    return result;
  }


  Future<Map<String, dynamic>> deleteListing(int listingId) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.delete("${Routes.base}/listing/remove/$listingId",
          options: Options(
            sendTimeout: const Duration(minutes: 1),
            contentType: Headers.formUrlEncodedContentType,
          ),
      );
      result = {
        "status": response.statusCode,
        "message": response.data["message"],
      };
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
      };
    }
    return result;
  }
}