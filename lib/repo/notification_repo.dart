import 'package:oprs/constant_values.dart';
import 'package:oprs/http/dio_intance.dart';
import 'package:oprs/model/notification.dart';

class NotificationRepo{
  final _client = DioSingleton().dioInstance;
  Future<Map<String, dynamic>> getNotifications() async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.get("${Routes.base}/notification/get");
      switch(response.statusCode){
        case 200 :
          List<NotificationModel> allNotifications = List.from(response.data["body"])
              .map((e) => NotificationModel.fromJson(e)).toList();
          result = {
            "status": response.statusCode,
            "message": "Loaded all user reviews!",
            "notifications": allNotifications
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

  Future<Map<String, dynamic>> getNotificationCount() async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.get("${Routes.base}/notification/count");
      switch(response.statusCode){
        case 200 :
          result = {
            "status": response.statusCode,
            "message": "Loaded number of notifications!",
            "count": response.data["body"]["unseen_count"]
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