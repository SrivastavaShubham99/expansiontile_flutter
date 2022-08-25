
import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

InterceptorsWrapper requestInterceptor(Dio dio) =>
    InterceptorsWrapper(onRequest:
        (RequestOptions options, RequestInterceptorHandler requestHandler) {
      final uri = options.uri.toString();
      log("Api - URL: ${uri.toString()}");
      log("Api - Request Body: ${options.data}");
      log("Api - Request header: ${options.headers}");
      log("Api - Response Type: ${options.responseType}");
      log("Api - Path: ${options.path}");
      log("Api - Query Parameters: ${options.queryParameters}");

      return requestHandler.next(options);
    }, onResponse: (Response<dynamic> response,
        ResponseInterceptorHandler requestHandler) {
      log("Api - Response: ${response.data}");
      log("Api - Response statusCode: ${response.statusCode}");
      log("Api - Response status message: ${response.statusMessage}");
      return requestHandler.next(response);
    });

dynamic responseInterceptor(Response options) async {
  return options;
}

dynamic errorInterceptor(DioError dioError) {
  return dioError;
}

class AppInterceptors extends Interceptor {
  @override
  FutureOr<dynamic> onRequest(RequestOptions options, _) async {
    return options;
  }

  @override
  FutureOr<dynamic> onError(DioError dioError, _) {
    return dioError;
  }

  @override
  FutureOr<dynamic> onResponse(Response options, _) async {
    return options;
  }
}
