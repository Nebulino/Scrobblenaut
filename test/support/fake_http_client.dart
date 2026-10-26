import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';
import 'package:scrobblenaut/src/tools/spaceship.dart';

/// Placeholder credentials. They are not real, and never leave the process.
const fakeApiKey = 'test-api-key';
const fakeApiSecret = 'test-api-secret';
const fakeSessionKey = 'test-session-key';

/// A canned HTTP response served by [FakeHttpClientAdapter].
class FakeResponse {
  final int statusCode;
  final String body;
  final String contentType;

  /// Extra response headers, e.g. `Retry-After`.
  final Map<String, String> headers;

  /// When set, the adapter throws it instead of answering, which is how a
  /// transport failure (timeout, connection error) looks to dio.
  final DioException? error;

  const FakeResponse._(
    this.statusCode,
    this.body,
    this.contentType, {
    this.headers = const {},
    this.error,
  });

  /// A JSON body, as Last.fm sends it when the request has `format=json`.
  /// [body] can be a `String` with JSON, or any JSON-encodable object.
  factory FakeResponse.json(
    Object body, {
    int statusCode = 200,
    Map<String, String> headers = const {},
  }) => FakeResponse._(
    statusCode,
    body is String ? body : jsonEncode(body),
    'application/json; charset=utf-8',
    headers: headers,
  );

  /// An XML body, as Last.fm sends it for POST requests.
  factory FakeResponse.xml(
    String body, {
    int statusCode = 200,
    Map<String, String> headers = const {},
  }) => FakeResponse._(
    statusCode,
    body,
    'text/xml; charset=UTF-8',
    headers: headers,
  );

  /// A transport failure: the adapter throws [error] instead of answering.
  factory FakeResponse.failure(DioException error) =>
      FakeResponse._(0, '', '', error: error);
}

/// A request received by [FakeHttpClientAdapter].
class RecordedRequest {
  final RequestOptions options;

  /// The raw request body ("" for requests without a body).
  final String body;

  const RecordedRequest(this.options, this.body);

  /// `GET` or `POST`.
  String get httpMethod => options.method;

  /// The query string parameters, as sent.
  Map<String, String> get query =>
      options.uri.queryParameters; // Already decoded and stringified.

  /// The form-urlencoded body parameters, decoded ("{}" if there is no body).
  Map<String, String> get form =>
      body.isEmpty ? <String, String>{} : Uri.splitQueryString(body);

  /// Every parameter sent upstream, whether in the query string or the body.
  Map<String, String> get parameters => {...query, ...form};

  /// The `Content-Type` request header.
  String? get contentType => options.contentType;

  /// The Last.fm API method (`track.getInfo`, ...).
  String? get lastfmMethod => parameters['method'];
}

/// A [HttpClientAdapter] that never touches the network.
///
/// It records every request, and answers with canned responses: first by
/// Last.fm method (see [stub]), then in order (see [enqueue]). A request with
/// no canned response fails loudly instead of going anywhere.
class FakeHttpClientAdapter implements HttpClientAdapter {
  final List<RecordedRequest> requests = [];
  final Map<String, FakeResponse> _stubs = {};
  final Queue<FakeResponse> _queue = Queue();

  /// Answers every request for the Last.fm [method] with [response].
  void stub(String method, FakeResponse response) => _stubs[method] = response;

  /// Answers the next otherwise-unmatched request with [response].
  void enqueue(FakeResponse response) => _queue.add(response);

  /// The only request received. Fails if there were none, or more than one.
  RecordedRequest get single {
    if (requests.length != 1) {
      throw StateError('Expected exactly 1 request, got ${requests.length}.');
    }
    return requests.single;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final bytes = <int>[];
    if (requestStream != null) {
      await for (final chunk in requestStream) {
        bytes.addAll(chunk);
      }
    }
    final request = RecordedRequest(options, utf8.decode(bytes));
    requests.add(request);

    final response =
        _stubs[request.lastfmMethod] ??
        (_queue.isEmpty ? null : _queue.removeFirst());
    if (response == null) {
      throw StateError(
        'No fake response for ${options.method} ${options.uri} '
        '(method: ${request.lastfmMethod}).',
      );
    }

    if (response.error != null) {
      throw response.error!;
    }

    return ResponseBody.fromString(
      response.body,
      response.statusCode,
      headers: {
        Headers.contentTypeHeader: [response.contentType],
        for (final header in response.headers.entries) header.key: [header.value],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// A [SpaceShip] that talks to [adapter] instead of the network.
SpaceShip fakeSpaceShip(FakeHttpClientAdapter adapter) => SpaceShip(
  baseUrl: 'https://ws.audioscrobbler.com/2.0/',
  dio: Dio()..httpClientAdapter = adapter,
);

/// A [LastFM] that talks to [adapter] instead of the network.
///
/// It is authenticated if, and only if, [sessionKey] is given.
LastFM fakeLastFM(
  FakeHttpClientAdapter adapter, {
  String? apiSecret,
  String? sessionKey,
}) => LastFM.withClient(
  client: fakeSpaceShip(adapter),
  apiKey: fakeApiKey,
  apiSecret: apiSecret,
  sessionKey: sessionKey,
);

/// An authenticated [LastFM] talking to [adapter], with a secret to sign with.
LastFM fakeAuthLastFM(FakeHttpClientAdapter adapter) =>
    fakeLastFM(adapter, apiSecret: fakeApiSecret, sessionKey: fakeSessionKey);
