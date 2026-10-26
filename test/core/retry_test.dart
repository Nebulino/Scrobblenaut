import 'package:dio/dio.dart';
import 'package:scrobblenaut/src/tools/spaceship.dart';
import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';

/// A [SpaceShip] whose retry waits are recorded instead of awaited.
({SpaceShip ship, List<Duration> waits}) shipOn(
  FakeHttpClientAdapter adapter,
) {
  final waits = <Duration>[];
  final ship = SpaceShip(
    baseUrl: 'https://ws.audioscrobbler.test/2.0/',
    dio: Dio()..httpClientAdapter = adapter,
    sleep: (duration) async => waits.add(duration),
  );
  return (ship: ship, waits: waits);
}

Map<String, Object> ok() => {'ok': true};

Map<String, Object> lastfmError(int code, String message) => {
  'error': code,
  'message': message,
};

DioException connectionError() => DioException(
  requestOptions: RequestOptions(path: ''),
  type: DioExceptionType.connectionError,
  error: 'Connection refused',
);

void main() {
  group('retry', () {
    test('retries a 429 and returns the body of the next attempt', () async {
      final adapter = FakeHttpClientAdapter()
        ..enqueue(
          FakeResponse.json(
            lastfmError(29, 'Rate limit exceeded'),
            statusCode: 429,
          ),
        )
        ..enqueue(FakeResponse.json(ok()));
      final setup = shipOn(adapter);

      final body = await setup.ship.get(parameters: {});

      expect(adapter.requests, hasLength(2));
      expect(setup.waits, hasLength(1));
      expect(body['ok'], isTrue);
    });

    test('retries a 5xx', () async {
      final adapter = FakeHttpClientAdapter()
        ..enqueue(
          FakeResponse.json(
            lastfmError(8, 'Operation failed'),
            statusCode: 503,
          ),
        )
        ..enqueue(FakeResponse.json(ok()));
      final setup = shipOn(adapter);

      await setup.ship.get(parameters: {});

      expect(adapter.requests, hasLength(2));
      expect(setup.waits, hasLength(1));
    });

    test('retries a Last.fm error 29 delivered with HTTP 200', () async {
      final adapter = FakeHttpClientAdapter()
        ..enqueue(
          FakeResponse.json(lastfmError(29, 'Rate limit exceeded')),
        )
        ..enqueue(FakeResponse.json(ok()));
      final setup = shipOn(adapter);

      await setup.ship.get(parameters: {});

      expect(adapter.requests, hasLength(2));
    });

    test('retries a connection error', () async {
      final adapter = FakeHttpClientAdapter()
        ..enqueue(FakeResponse.failure(connectionError()))
        ..enqueue(FakeResponse.json(ok()));
      final setup = shipOn(adapter);

      await setup.ship.post(parameters: {});

      expect(adapter.requests, hasLength(2));
    });

    test('gives up after retryLimit attempts and rethrows the original '
        'error', () async {
      final adapter = FakeHttpClientAdapter();
      for (var i = 0; i < 3; i++) {
        adapter.enqueue(
          FakeResponse.json(
            lastfmError(8, 'Operation failed'),
            statusCode: 500,
          ),
        );
      }
      final setup = shipOn(adapter);

      await expectLater(
        setup.ship.get(parameters: {}, retryLimit: 3),
        throwsA(
          isA<LastFMException>().having((e) => e.errorCode, 'errorCode', 8),
        ),
      );

      expect(adapter.requests, hasLength(3));
      expect(setup.waits, hasLength(2));
    });

    test('retryLimit 1 means no retry at all', () async {
      final adapter = FakeHttpClientAdapter()
        ..enqueue(
          FakeResponse.json(
            lastfmError(8, 'Operation failed'),
            statusCode: 500,
          ),
        );
      final setup = shipOn(adapter);

      await expectLater(
        setup.ship.get(parameters: {}, retryLimit: 1),
        throwsA(isA<LastFMException>()),
      );

      expect(adapter.requests, hasLength(1));
      expect(setup.waits, isEmpty);
    });

    test('does not retry a 4xx that is not a rate limit', () async {
      final adapter = FakeHttpClientAdapter()
        ..enqueue(
          FakeResponse.json(
            lastfmError(6, 'Invalid parameters'),
            statusCode: 400,
          ),
        );
      final setup = shipOn(adapter);

      await expectLater(
        setup.ship.get(parameters: {}),
        throwsA(
          isA<LastFMException>().having((e) => e.errorCode, 'errorCode', 6),
        ),
      );

      expect(adapter.requests, hasLength(1));
      expect(setup.waits, isEmpty);
    });

    test('honours Retry-After in its seconds form', () async {
      final adapter = FakeHttpClientAdapter()
        ..enqueue(
          FakeResponse.json(
            lastfmError(29, 'Rate limit exceeded'),
            statusCode: 429,
            headers: {'retry-after': '2'},
          ),
        )
        ..enqueue(FakeResponse.json(ok()));
      final setup = shipOn(adapter);

      await setup.ship.get(parameters: {});

      expect(setup.waits, [const Duration(seconds: 2)]);
    });

    test('backs off exponentially, and never above eight seconds', () async {
      final adapter = FakeHttpClientAdapter();
      for (var i = 0; i < 6; i++) {
        adapter.enqueue(
          FakeResponse.json(
            lastfmError(8, 'Operation failed'),
            statusCode: 500,
          ),
        );
      }
      final setup = shipOn(adapter);

      await expectLater(
        setup.ship.get(parameters: {}, retryLimit: 6),
        throwsA(isA<LastFMException>()),
      );

      expect(setup.waits, hasLength(5));
      // 500 ms * 2^n with up to 10 % jitter.
      expect(setup.waits[0].inMilliseconds, inInclusiveRange(450, 550));
      expect(setup.waits[1].inMilliseconds, inInclusiveRange(900, 1100));
      expect(setup.waits[2].inMilliseconds, inInclusiveRange(1800, 2200));
      for (final wait in setup.waits) {
        expect(wait, lessThanOrEqualTo(const Duration(seconds: 8)));
      }
    });
  });
}
