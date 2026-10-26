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

  /// Creates the client.
  ///
  /// By default [SpaceShip] builds and owns its own [Dio]. A caller (typically
  /// a test) can pass its own [dio], e.g. one with a fake
  /// [HttpClientAdapter]. The same interceptors are registered on it, and the
  /// default [baseUrl], headers and content type are filled in only where the
  /// given [dio] leaves them unset.
  SpaceShip({required String baseUrl, String? proxy, Dio? dio}) {
    _dio =
        (dio == null
              ? Dio(
                  BaseOptions(
                    baseUrl: baseUrl,
                    headers: {
                      'Accept-Charset': 'utf-8',
                      'User-Agent': 'DartyFM',
                    },
                    contentType: Headers.formUrlEncodedContentType,
                    responseType: ResponseType.json,
                  ),
                )
              : _withDefaults(dio, baseUrl))
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest:
                  (RequestOptions options, RequestInterceptorHandler handler) {
                    options.queryParameters.removeWhere(
                      (key, value) => value == null,
                    );

                    if (options.data == null) {
                      handler.next(options);
                      return;
                    }

                    if (options.data is Map) {
                      (options.data as Map).removeWhere(
                        (key, value) => value == null,
                      );
                    }

                    handler.next(options);
                  },
              onResponse: (response, handler) {
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
                      description: response.data['message'],
                    );
                  }
                }

                handler.next(response);
              },
              onError: (DioException error, ErrorInterceptorHandler handler) {
                if (error.type == DioExceptionType.badResponse) {
                  handler.next(
                    LastFMException.generate(
                      error.response?.data,
                      requestOptions: error.requestOptions,
                    ),
                  );
                } else {
                  handler.next(error);
                }
              },
            ),
          );
  }

  /// Fills the options a caller-supplied [dio] left unset with the defaults
  /// used for the [Dio] built internally.
  static Dio _withDefaults(Dio dio, String baseUrl) {
    final options = dio.options;
    if (options.baseUrl.isEmpty) {
      options.baseUrl = baseUrl;
    }
    options.headers.putIfAbsent('Accept-Charset', () => 'utf-8');
    options.headers.putIfAbsent('User-Agent', () => 'DartyFM');
    options.contentType ??= Headers.formUrlEncodedContentType;
    return dio;
  }

  Future<dynamic> get({
    required Map<String, dynamic> parameters,
    retryLimit = 5,
  }) async {
    parameters['format'] = 'json';
    // TODO: Catch errors from API and retry
    // for (var i = 0; i < retryLimit; i++) {
    return (await _dio.get('', queryParameters: parameters)).data;
    // }
  }

  // Post request with JSON response exists?
  Future<dynamic> post({required Map<String, dynamic> parameters}) async {
    return (await _dio.post('', data: parameters)).data;
  }
}
