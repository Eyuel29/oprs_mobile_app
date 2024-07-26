import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CookieInterceptor extends Interceptor {
  final storage = FlutterSecureStorage();
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async{
    List<String>? setCookieHeaders = response.headers.map['set-cookie'];
    if (setCookieHeaders != null) {
      for (String setCookieHeader in setCookieHeaders) {
        List<String> parts = setCookieHeader.split(';');
        String cookie = parts[0];
        List<String> cookieParts = cookie.split('=');
        String name = cookieParts[0].trim();
        String value = cookieParts[1].trim();
        if(value.isEmpty){
          await storage.delete(key: name);
          await storage.delete(key: "authenticated_user");
        }else{
          await storage.write(key: name, value: value);
        }
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    Map<String, dynamic> headers = options.headers;
    bool sessionFound = await storage.containsKey(key: "session_id");
    if (!sessionFound) {
      options.headers = headers;
    }else{
      String? foundCookie = await storage.read(key: "session_id");
      String cookieName = "session_id";
      String cookie = "$cookieName=$foundCookie";
      headers['Cookie'] = cookie;
    }
    super.onRequest(options, handler);
  }
}