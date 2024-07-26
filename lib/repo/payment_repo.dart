import 'package:oprs/constant_values.dart';
import 'package:oprs/http/dio_intance.dart';
import 'package:oprs/model/payment_info.dart';

class PaymentRepo{
  final _client = DioSingleton().dioInstance;

  Future<Map<String, dynamic>> getMypaymentInfo() async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.get("${Routes.base}/payment/myInfo");

      switch(response.statusCode){
        case 200 : result = {
          "status": response.statusCode,
          "message": "Loaded payment information!",
          "accountInfo": PaymentInfo.fromJson(Map.from(response.data["body"]))
        };
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

  Future<Map<String, dynamic>> getSubAccount(int userId) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.get("${Routes.base}/payment/getSubAccount/$userId");
      switch(response.statusCode){
        case 200 : result = {
          "status": response.statusCode,
          "message": "Loaded owner's sub-account!",
          "subAccountId": response.data["body"]
        };
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

  Future<Map<String, dynamic>> createSubAccount(Map<String, String> accountInfo) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.post(
        "${Routes.base}/payment/createSubAccount",
        data: {
          'account_number' : accountInfo["account_number"],
          'account_owner_name' : accountInfo["account_owner_name"],
          'bank_name' : accountInfo["bank_name"],
          'bank_id' : accountInfo["bank_id"],
          'business_name' : accountInfo["business_name"],
        }
      );
      switch(response.statusCode){
        case 200 : result = {
          "status": response.statusCode,
          "message": response.data["message"]
        };
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

  Future<Map<String, dynamic>> deleteSubAccount() async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.delete("${Routes.base}/payment/deleteSubAccount");
      switch(response.statusCode){
        case 200 : result = {
          "status": response.statusCode,
          "message": response.data["message"]
        };
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

  Future<Map<String, dynamic>> initializePayment(Map<String, dynamic> paymentInfo) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.post(
          "${Routes.base}/payment/initialize",
          data: {
            "title" : paymentInfo["title"],
            "description" : paymentInfo["description"],
            "amount" : paymentInfo["amount"],
            "currency" : paymentInfo["currency"],
            "receiver_id" : paymentInfo["receiver_id"]
          }
      );
      switch(response.statusCode){
        case 200 : result = {
          "status": response.statusCode,
          "message": response.data["message"],
          "checkOutLink" : response.data["body"]["checkOutLink"]["checkout_url"],
          "txRef" : response.data["body"]["txRef"]
        };
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

  Future<Map<String, dynamic>> verifyPayment(String txRef) async{
    Map<String, dynamic> result = {};
    try{
      var response = await _client.get("${Routes.base}/payment/verify/$txRef");
      switch(response.statusCode){
        case 200 : result = {
          "status": response.statusCode,
          "message": response.data["message"]
        };
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
}