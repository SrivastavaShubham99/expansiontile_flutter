import 'package:dio/dio.dart';
import 'interceptors.dart';

class ApiService {
  static ApiService? _instance;
  factory ApiService() => _instance ??= ApiService._();
  ApiService._();

  Dio get dio => _dio();

  Dio _dio() {
    final options = BaseOptions(
      baseUrl: "http://www.r-ims.com/",
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    var dio = Dio(options);
    dio.interceptors.add(requestInterceptor(dio));
    return dio;
  }
}
