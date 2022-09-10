//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:dio/dio.dart';
import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:scrobblenaut/src/helpers/post_response_helper.dart';
import 'package:scrobblenaut/src/helpers/utils.dart';

/// It helps creating a Http Connection to [LastFM] APIs,
/// for sending and receiving requests.
///
/// [LastFM]: https://last.fm/api
class SpaceShip {
  late Dio _dio;

  SpaceShip({required String base_url, String? proxy}) {
    _dio = Dio(
      BaseOptions(
          baseUrl: '$base_url',
          headers: {'Accept-Charset': 'utf-8', 'User-Agent': 'DartyFM'},
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.json),
    )..interceptors.add(InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) {
        options.queryParameters.removeWhere((key, value) => value == null);

        if (options.data == null) {
          handler.next(options);
          return;
        }

        if (options.data is Map) {
          (options.data as Map).removeWhere((key, value) => value == null);
        }

        handler.next(options);
      }, onResponse: (response, handler) {
        // Sometimes it responds without giving a error...
        if (isXml(response.data)) {
          final postResponse = PostResponseHelper.parse(response.data);

          if (!postResponse.status) {
            throw LastFMException.generate(response.data);
          }
        } else {
          if (response.data['error'] != null) {
            throw LastFMException(
                errorCode: response.data['error'].toString(),
                description: response.data['message']);
          }
        }

        handler.next(response);
      }, onError: (error, ErrorInterceptorHandler handler) {
        if (error.type == DioErrorType.response) {
          handler.next(LastFMException.generate(error.response?.data));
        } else {
          handler.next(error);
        }
      }));
  }

  Future<dynamic> get(
      {required Map<String, dynamic> parameters, retryLimit = 5}) async {
    parameters['format'] = 'json';
    // TODO: Catch errors from API and retry
    // for (var i = 0; i < retryLimit; i++) {
    return (await _dio.get('', queryParameters: parameters)).data;
    // }
  }

  // Post request with JSON response exists?
  Future<dynamic> post({
    required Map<String, dynamic> parameters,
  }) async {
    return (await _dio.post('', data: parameters)).data;
  }
}
