import 'package:oprs/constant_values.dart';
import 'package:oprs/http/dio_intance.dart';
import 'package:oprs/model/reservation.dart';

class ReservationRepo{
  final _client = DioSingleton().dioInstance;
  Future<Map<String, dynamic>> makeReservationRequest(Map<String, dynamic> reservation) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.post("${Routes.base}/reservation/request", data: reservation);
      switch(response.statusCode){
        case 200 :
          result = {"status": response.statusCode, "message": "Successfully made a reservation!"};
          break;
        default :
          result = {"status": response.statusCode, "message": response.data["message"]};
          break;
      }
    }catch(error){
      result = {"status": 0, "message": "No internet connection!"};
    }
    return result;
  }

  Future<Map<String, dynamic>> getAllReservations() async{
    Map<String, dynamic> result = {};
    List<Reservation> allReservations = [];
    try{
      var response = await _client.get("${Routes.base}/reservation/get");
      switch(response.statusCode){
        case 200 :
          for(var reservation in List.from(response.data["body"])){
            allReservations.add(Reservation.fromJson(Map.from(reservation)));
          }
          result = {
            "status": response.statusCode,
            "message": "Loaded all listing reservation requests!",
            "reservations": allReservations
          };
          break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"],
            "reservations": []
          };
          break;
      }
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
        "reservations": []
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> getMyRequests() async{
    Map<String, dynamic> result = {};
    List<Reservation> allReservations = [];
    try{
      var response = await _client.get("${Routes.base}/reservation/myrequests");
      switch(response.statusCode){
        case 200 :
          for(var request in List.from(response.data["body"])){
            allReservations.add(Reservation.fromJson(Map.from(request)));
          }
          result = {
            "status": response.statusCode,
            "message": "Loaded all your reservation requests!",
            "reservations": allReservations
          };
          break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"],
            "reservations": []
          };
          break;
      }
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
        "reservations": []
      };
    }
    return result;
  }


  Future<Map<String, dynamic>> approveRequest(int reservationId) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.put("${Routes.base}/reservation/approve/$reservationId");
      switch(response.statusCode){
        case 200 :
          result = {
            "status": response.statusCode,
            "message": "Request has been approved!",
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
  Future<Map<String, dynamic>> declineRequest(int reservationId) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.put("${Routes.base}/reservation/decline/$reservationId");
      switch(response.statusCode){
        case 200 :
          result = {
            "status": response.statusCode,
            "message": "Request has been declined!",
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
  Future<Map<String, dynamic>> cancelRequest(int reservationId) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.delete("${Routes.base}/reservation/cancel/$reservationId");
      switch(response.statusCode){
        case 200 :
          result = {
            "status": response.statusCode,
            "message": "Request has been cencelled!",
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