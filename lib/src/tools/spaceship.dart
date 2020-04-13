/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:scrobblenaut/src/helpers/utils.dart';
import 'package:xml/xml.dart' as xml;

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
          contentType: Headers.formUrlEncodedContentType,
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
        // Sometimes it responds without giving a error...
        if (isXml(response.data)) {
          final xmlError = xml.parse(response.data);

          final statusNode = xmlError.findElements('lfm').first;

          if (statusNode.getAttribute('status') == 'failed') {
            throw LastFMException.generate(response.data);
          }
        } else {
          if (response.data['error'] != null) {
            throw LastFMException(
                errorCode: response.data['error'],
                description: response.data['message']);
          }
        }

        return response.data;
      }, onError: (error) {
        if (error.type == DioErrorType.RESPONSE) {
          return LastFMException.generate(error.response.data);
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

  Future<dynamic> get({
    @required Map<String, dynamic> parameters,
  }) async {
    parameters['format'] = 'json';
    return (await _dio.get('', queryParameters: parameters)).data;
  }

  // Post request with JSON response exists?
  Future<dynamic> post({
    @required Map<String, dynamic> parameters,
  }) async {
    return (await _dio.post('', data: parameters)).data;
  }
}
