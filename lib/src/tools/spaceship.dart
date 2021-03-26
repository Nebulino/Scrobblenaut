//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:scrobblenaut/src/helpers/post_response_helper.dart';
import 'package:scrobblenaut/src/helpers/utils.dart';

/// It helps creating a Http Connection to [LastFM] APIs,
/// for sending and receiving requests.
///
/// [LastFM]: https://last.fm/api
class SpaceShip {
  Dio _dio;

  SpaceShip({@required String base_url}) {
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

        return response.data;
      }, onError: (error) {
        if (error.type == DioErrorType.RESPONSE) {
          return LastFMException.generate(error.response.data);
        } else {
          return error;
        }
      }));
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
