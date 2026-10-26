//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:scrobblenaut/src/helpers/post_response_helper.dart';
import 'package:scrobblenaut/src/helpers/utils.dart';
import 'package:scrobblenaut/src/tools/proxy_adapter.dart';

/// Waits for [duration] before completing.
///
/// The default is `Future.delayed`; tests inject their own so retries do not
/// make the suite slow.
typedef Sleeper = Future<void> Function(Duration duration);

/// It helps creating a Http Connection to [LastFM] APIs,
/// for sending and receiving requests.
///
/// Requests that fail for a transient reason (timeout, connection error,
/// HTTP 429, HTTP 5xx, or Last.fm error 29 "Rate limit exceeded") are retried
/// with an exponential backoff. See [get] and [post] for the attempt count.
///
/// [LastFM]: https://last.fm/api
class SpaceShip {
  /// Number of attempts used when a caller does not pass its own [retryLimit]:
  /// the first try plus four retries.
  static const int defaultRetryLimit = 5;

  /// Delay before the first retry. It doubles on every following attempt.
  static const Duration baseRetryDelay = Duration(milliseconds: 500);

  /// Upper bound for a single wait, backoff and `Retry-After` alike.
  static const Duration maxRetryDelay = Duration(seconds: 8);

  /// Last.fm error code for "Rate limit exceeded".
  static const int _rateLimitedErrorCode = 29;

  static final Random _random = Random();

  late Dio _dio;
  final Sleeper _sleep;
  final String? _proxy;

  /// Creates the client.
  ///
  /// By default [SpaceShip] builds and owns its own [Dio]. A caller (typically
  /// a test) can pass its own [dio], e.g. one with a fake
  /// [HttpClientAdapter]. The same interceptors are registered on it, and the
  /// default [baseUrl], headers and content type are filled in only where the
  /// given [dio] leaves them unset.
  ///
  /// [proxy] routes every request through `host:port` (an optional `http://`
  /// prefix is accepted). It is applied on native platforms only: a browser
  /// owns its proxy, so the value is ignored on the web. An empty or malformed
  /// value throws an [ArgumentError] instead of being silently dropped.
  /// [proxy] and [dio] are mutually exclusive, because the proxy is applied by
  /// building the HTTP client that an injected [dio] already owns.
  ///
  /// [sleep] is the wait used between retries; tests inject one to keep the
  /// suite instant.
  SpaceShip({
    required String baseUrl,
    String? proxy,
    Dio? dio,
    @visibleForTesting Sleeper? sleep,
  }) : _sleep = sleep ?? Future<void>.delayed,
       _proxy = _normalizeProxy(proxy) {
    if (_proxy != null && dio != null) {
      throw ArgumentError(
        'Pass either proxy or dio, not both: the proxy configures the HTTP '
        'client, which an injected dio already owns.',
      );
    }

    var client =
        dio ??
        Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: {'Accept-Charset': 'utf-8', 'User-Agent': 'DartyFM'},
            contentType: Headers.formUrlEncodedContentType,
            responseType: ResponseType.json,
          ),
        );

    if (dio != null) {
      client = _withDefaults(client, baseUrl);
    }

    if (_proxy != null) {
      client = applyProxy(client, _proxy);
    }

    _dio = client
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
            options.queryParameters.removeWhere((key, value) => value == null);

            if (options.data == null) {
              handler.next(options);
              return;
            }

            if (options.data is Map) {
              (options.data as Map).removeWhere((key, value) => value == null);
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
                  response: error.response,
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

  /// Validates `host:port` and strips an optional `http://` prefix.
  static String? _normalizeProxy(String? proxy) {
    if (proxy == null) {
      return null;
    }

    var value = proxy.trim();
    if (value.isEmpty) {
      throw ArgumentError.value(
        proxy,
        'proxy',
        'Expected host:port, got an empty string.',
      );
    }

    if (value.startsWith('http://')) {
      value = value.substring('http://'.length);
    } else if (value.startsWith('https://')) {
      throw ArgumentError.value(
        proxy,
        'proxy',
        'Expected host:port; a proxy itself is reached over plain HTTP.',
      );
    }

    final match = RegExp(r'^([A-Za-z0-9._-]+):([0-9]{1,5})$').firstMatch(value);
    if (match == null) {
      throw ArgumentError.value(proxy, 'proxy', 'Expected host:port.');
    }

    final port = int.parse(match.group(2)!);
    if (port < 1 || port > 65535) {
      throw ArgumentError.value(proxy, 'proxy', 'Port out of range 1-65535.');
    }

    return value;
  }

  /// The proxy in use, if any (never on the web).
  @visibleForTesting
  String? get proxy => _proxy;

  /// The [Dio] instance actually sending the requests.
  @visibleForTesting
  Dio get dio => _dio;

  /// Sends a GET request, retrying transient failures up to [retryLimit]
  /// attempts in total (1 means "no retry").
  Future<dynamic> get({
    required Map<String, dynamic> parameters,
    int retryLimit = defaultRetryLimit,
  }) {
    parameters['format'] = 'json';
    return _send(isPost: false, parameters: parameters, retryLimit: retryLimit);
  }

  /// Sends a POST request, retrying transient failures up to [retryLimit]
  /// attempts in total (1 means "no retry").
  Future<dynamic> post({
    required Map<String, dynamic> parameters,
    int retryLimit = defaultRetryLimit,
  }) {
    return _send(isPost: true, parameters: parameters, retryLimit: retryLimit);
  }

  Future<dynamic> _send({
    required bool isPost,
    required Map<String, dynamic> parameters,
    required int retryLimit,
  }) async {
    final attempts = retryLimit < 1 ? 1 : retryLimit;

    for (var attempt = 1; ; attempt++) {
      try {
        final response = isPost
            ? await _dio.post('', data: parameters)
            : await _dio.get('', queryParameters: parameters);
        return response.data;
      } catch (error) {
        if (attempt >= attempts || !_isTransient(error)) {
          rethrow;
        }
        await _sleep(_backoffFor(error, attempt));
      }
    }
  }

  /// True when retrying the very same request can succeed.
  static bool _isTransient(Object error) {
    // LastFMException extends DioException, so it must be checked first.
    if (error is LastFMException) {
      return error.errorCode == _rateLimitedErrorCode ||
          _isTransientStatus(error.response?.statusCode);
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return true;
        case DioExceptionType.badResponse:
          return _isTransientStatus(error.response?.statusCode);
        default:
          return false;
      }
    }

    return false;
  }

  static bool _isTransientStatus(int? status) =>
      status == 429 || (status != null && status >= 500 && status <= 599);

  /// Exponential backoff from [baseRetryDelay], capped at [maxRetryDelay],
  /// with up to ±10 % jitter. A `Retry-After` header in its seconds form wins
  /// over the computed delay (the HTTP-date form falls back to the backoff).
  Duration _backoffFor(Object error, int attempt) {
    final retryAfter = _retryAfter(error);
    if (retryAfter != null) {
      return retryAfter > maxRetryDelay ? maxRetryDelay : retryAfter;
    }

    var delay = baseRetryDelay * (1 << (attempt - 1));
    if (delay > maxRetryDelay) {
      delay = maxRetryDelay;
    }

    final jitter =
        (delay.inMilliseconds * 0.1 * (_random.nextDouble() * 2 - 1)).round();
    final withJitter = Duration(milliseconds: delay.inMilliseconds + jitter);
    return withJitter > maxRetryDelay ? maxRetryDelay : withJitter;
  }

  static Duration? _retryAfter(Object error) {
    final response = error is DioException ? error.response : null;
    final raw = response?.headers.value('retry-after');
    if (raw == null) {
      return null;
    }

    final seconds = int.tryParse(raw.trim());
    if (seconds == null || seconds < 0) {
      return null;
    }

    return Duration(seconds: seconds);
  }
}
