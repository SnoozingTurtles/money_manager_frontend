import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:money_manager/common/secure_storage.dart';

class Api {
final Dio api = Dio();
String? accessToken;

final _storage =  SecureStorage();

Api() {
  api.interceptors
      .add(InterceptorsWrapper(onRequest: (options, handler) async {
    if (!options.path.contains('http')) {
      debugPrint('DIOX:15:OPTIONS PATH ALTERED');
      options.path = 'http://192.168.0.100:8080' + options.path;
    }
    accessToken = await _storage.getToken();
    // accessToken ??= '';
    options.headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(options);
  }, onError: (DioError error, handler) async {
    if ((error.response?.statusCode == 401 &&
        error.response?.data['message'] == "Invalid JWT")) {
      if (await _storage.hasRefreshToken()) {
        if (await refreshToken()) {
          return handler.resolve(await _retry(error.requestOptions));
        }
      }
    }
    return handler.next(error);
  }));
}

Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
  final options = Options(
    method: requestOptions.method,
    headers: requestOptions.headers,
  );
  return api.request<dynamic>(requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options);
}

Future<bool> refreshToken() async {
  final refreshToken = await _storage.getRefreshToken();
  final response = await api
      .post('/auth/refresh', data: {'refreshToken': refreshToken});

  if (response.statusCode == 201) {
    accessToken = response.data;
    return true;
  } else {
    // refresh token is wrong
    accessToken = null;
    _storage.deleteAll();
    return false;
  }
}
}