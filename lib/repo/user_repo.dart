import 'package:dio/dio.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/http/dio_intance.dart';
import 'package:oprs/model/user.dart';

class UserRepo{
  final _client = DioSingleton().dioInstance;
  Future<Map<String, dynamic>> getUserInfo(int userId) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.get("${Routes.base}/user/$userId");
      switch(response.statusCode){
        case 200 : result = { "status": response.statusCode,
          "message": "Loaded user data!","user": User.fromJson(response.data["body"]) };
        break;
        default :
          result = {"status": response.statusCode,"message": response.data["message"]};
          break;
      }
    }catch(error){
      result = {"status": 0,"message": "No internet connection!"};
    }
    return result;
  }
  Future<Map<String, dynamic>> getUserContact(int userId) async{
    Map<String, dynamic> result = {};
    List<Map<String, dynamic>> allContacts = [];
    try{
      var response = await _client.get("${Routes.base}/user/contact/$userId");
      switch(response.statusCode){
        case 200 :
          for(var review in List.from(response.data["body"])){
            allContacts.add(Map.from(review));
          }
          result = {
            "status": response.statusCode,
            "message": "Loaded all user contacts!",
            "allContacts": allContacts
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
  Future<Map<String, dynamic>> updateProfile(FormData userData) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.put(
        "${Routes.base}/account/modify",
        data: userData,
        options: Options(
          sendTimeout: const Duration(minutes: 5),
          contentType: Headers.formUrlEncodedContentType
        )
      );

      switch(response.statusCode){
        case 200 :
          result = {
            "status": response.statusCode,
            "message": "Profile Updated Successfully!"
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
  Future<Map<String, dynamic>> updatePassword(Map<String, String> data) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.put(
        "${Routes.base}/account/updatePassword",
        data: data
      );
      switch(response.statusCode){
        case 200 :
          result = {
            "status": response.statusCode,
            "message": "Password Updated Successfully!",
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
  Future<Map<String, dynamic>> updatePasswordRestore(Map<String, String> data) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.put(
          "${Routes.base}/account/restorePassword",
          data: data
      );
      switch(response.statusCode){
        case 200 :
          result = {
            "status": response.statusCode,
            "message": "Password Updated Successfully!",
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