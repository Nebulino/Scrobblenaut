/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:scrobblenaut/scrobblenaut_exceptions.dart';

/// It helps creating a Http Connection to [LastFM] APIs,
/// for sending and receiving requests.
///
/// [LastFM]: https://last.fm/api
class SpaceShip {
  Dio _dio;

  SpaceShip({@required String base_url, String proxy}) {
    _dio = Dio(
      BaseOptions(
          baseUrl: '${base_url}',
          headers: {
            'Content-type': 'application/x-www-form-urlencoded',
            'Accept-Charset': 'utf-8',
            'User-Agent': 'DartyFM'
          },
          responseType: ResponseType.json),
    )..interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
        options.queryParameters?.removeWhere((key, value) => value == null);
        if (options.data == null) {
          return options;
        }

        if (options.data is Map) {
          (options.data as Map).removeWhere((key, value) => value == null);
        }

        return options;
      }, onResponse: (response) {
        return response.data;
      }, onError: (error) {
        if (error.type == DioErrorType.RESPONSE) {
          return LastFMException(
              errorCode: error.response.data['error'],
              description: error.response.data['message']);
        } else {
          return error;
        }
      }));

    if (proxy != null) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) => 'PROXY ${proxy}';
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }

  Future<dynamic> post({
    @required Map<String, dynamic> parameters,
  }) async {
    parameters['format'] = 'json';
    return (await _dio.post('', queryParameters: parameters)).data;
  }
}
