import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/http/dio_intance.dart';
import 'package:oprs/model/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepo {
  final client = DioSingleton().dioInstance;
  var storage = FlutterSecureStorage();
  Future<Map<String, dynamic>> register(FormData user) async {
    Map<String, dynamic> result = {};
    try {
      var response = await client.post(
        "${Routes.base}/auth/register",
        data: user,
        options: Options(
          sendTimeout: const Duration(minutes: 5),
          contentType: Headers.formUrlEncodedContentType
        )
      );
      switch (response.statusCode) {
        case 200 :
          result = {
            "status": response.statusCode,
            "message": "Information saved successfully!",
          };
          break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"]
          };
          break;
      }
    }catch(error){
      print(error);
      result = {
        "status": 0,
        "message": "No internet connection!"
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> signIn(Map<String, dynamic> user) async{
    Map<String, dynamic> result = {};
    try {
    var response = await client.post(
      "${Routes.base}/auth/signin",
      data: user
    );
      switch (response.statusCode) {
        case 200 :
        User authenticatedUser = User.fromJson(Map.from(response.data["body"]));
        await storage.write( key : "authenticated_user", value : jsonEncode(response.data["body"]));
          result = {
            "status": response.statusCode,
            "message": "Signed in successfully!",
            "user": authenticatedUser
          };
          break;
        case 409 :
          result = {
            "status": response.statusCode,
            "message": "Something wrong with your data!"
          };
          break;
        case 403 :
          result = {
            "status": response.statusCode,
            "message": "Account not verified!"
          };
          break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"]
          };
          break;
      }
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!"
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> signOut() async{
    Map<String, dynamic> result = {};
    try{
      var response = await client.get("${Routes.base}/account/signout");
      switch(response.statusCode){
        case 200 :
          result = {
            "status": response.statusCode,
            "message": "Signed out successfully!"
          };
          break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"]
          };
          break;
      }
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!"
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> verify(int key) async{
    Map<String, dynamic> result = {};
    try{
    var response = await client.post("${Routes.base}/account/verify/$key",data: {});
      switch(response.statusCode){
        case 200 :
          result = {
            "status": response.statusCode,
            "message": "Verified successfully!"
          };
          break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"]
          };
          break;
      }
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!"
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> verifyGet() async{
    Map<String, dynamic> result = {};
    try{
      var response = await client.get("${Routes.base}/account/verify");
      switch(response.statusCode){
        case 200 :
          result = {
            "status": response.statusCode,
            "message": "Verification code was sent to your email address!"
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

  Future<Map<String, dynamic>> restoreAccount(String email) async{
    Map<String, dynamic> result = {};
    try{
      var response = await client.post("${Routes.base}/account/restore",data: {
        "email" : email
      });
      switch(response.statusCode){
        case 200 :
          result = {
            "status": response.statusCode,
            "message": "Verification sent successfully!"
          };
          break;
        default :
          result = {
            "status": response.statusCode,
            "message": response.data["message"]
          };
          break;
      }
    }catch(error){
      result = {
        "status": 0,
        "message": "No internet connection!"
      };
    }
    return result;
  }
}