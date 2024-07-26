import 'package:dio/dio.dart';
import 'package:oprs/http/cookie_interceptor.dart';

class DioSingleton {
  static final DioSingleton _instance = DioSingleton._internal();
  late Dio _dio;

  factory DioSingleton() {
    return _instance;
  }

  bool validateStatus(bool status){
    return false;
  }

  DioSingleton._internal() {
    _dio = Dio(BaseOptions(validateStatus: (status) => true));
    _dio.interceptors.add(CookieInterceptor());
    _dio.interceptors.add(ErrorInterceptor());
  }
  
  Dio get dioInstance => _dio;
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print(err);
    super.onError(err, handler);
  }
}

