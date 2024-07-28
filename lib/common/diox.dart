import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:money_manager/common/secure_storage.dart';

class Api {
  final Dio api = Dio();
  String? accessToken;

  final _storage = SecureStorage();
  static bool refresh = false;

  Api() {
    api.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      accessToken = await _storage.getToken();
      options.headers['Authorization'] = 'Bearer $accessToken';

      if (!options.path.contains('http')) {
        debugPrint('DIOX:15:OPTIONS PATH ALTERED');
        options.path = 'http://127.0.0.1:8080${options.path}';
      }
      if (refresh) {
        options.headers.remove('Authorization');
        refresh = false;
      }
      // accessToken ??= '';
      return handler.next(options);
    }, onError: (DioError error, handler) async {
      debugPrint('DIOX:ON ERROR: $error');
      if ((error.response?.statusCode == 400 && error.response?.data['message'] == "JWT token has expired!")) {
        debugPrint('Checking for refresh token');
        if (await _storage.hasRefreshToken()) {
          debugPrint("DIOX: 28: has refresh token");
          if (await refreshToken()) {
            debugPrint('Retrying refresh token ');
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
    if (requestOptions.data is FormData) {
      String transactionType = requestOptions.data.files[0].key.toString();
      debugPrint(transactionType);
      FormData formData = FormData.fromMap(
        {
          transactionType: MultipartFile.fromString(
            jsonEncode(requestOptions.extra),
          )
        },
      );
      requestOptions.data = formData;
    }

    return api.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<bool> refreshToken() async {
    debugPrint('DIOX:71: Enters Refresh Token');
    refresh = true;
    try {
      final refreshToken = await _storage.getRefreshToken();
      final response = await api.post('/api/auth/refreshtoken', data: {'refreshToken': refreshToken});
      debugPrint('DIOX: refreshToken response:${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint('DIOX: 72 REFRESH TOKEN UPDATED');
        accessToken = response.data['accessToken'];
        await _storage.setToken(accessToken!);
        return true;
      } else {
        accessToken = null;
        await _storage.deleteAll();
        return false;
      }
    } catch (error) {
      accessToken = null;
      await _storage.deleteAll();
      return false;
    }
  }
}
