import 'package:oprs/constant_values.dart';
import 'package:oprs/http/dio_intance.dart';
import 'package:oprs/model/agreement.dart';

class AgreementRepo{
  final _client = DioSingleton().dioInstance;

  Future<Map<String, dynamic>> getUserAgreements(int userId) async{
    Map<String, dynamic> result = {};
    List<Agreement> allAgreements = [];
    try{
      var response = await _client.get("${Routes.base}/account/agreement/$userId");
      switch(response.statusCode){
        case 200 :
          for(var agreement in List.from(response.data["body"])){
            allAgreements.add(Agreement.fromJson(Map.from(agreement)));
          }
          result = {
            "status": response.statusCode,
            "message": "Loaded all user's agreements!",
            "agreements": allAgreements
          };
          break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"],
            "agreements": []
          };
          break;
      }
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
        "agreements": []
      };
    }
    return result;
  }



  Future<Map<String, dynamic>> getMyAgreements() async{
    Map<String, dynamic> result = {};
    List<Agreement> allAgreements = [];
    try{
      var response = await _client.get("${Routes.base}/account/myAgreement");
      switch(response.statusCode){
        case 200 :
          for(var agreement in List.from(response.data["body"])){
            allAgreements.add(Agreement.fromJson(Map.from(agreement)));
          }

          result = {
            "status": response.statusCode,
            "message": "Loaded all user's agreements!",
            "agreements": allAgreements
          };
          break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"],
            "agreements": []
          };
          break;
      }
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!",
        "agreements": []
      };
    }
    return result;
  }
}