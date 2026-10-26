import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:scrobblenaut/scrobblenaut.dart';
import 'package:scrobblenaut/src/tools/spaceship.dart';
import 'package:test/test.dart';

const _baseUrl = 'https://ws.audioscrobbler.com/2.0/';

void main() {
  group('proxy', () {
    test('normalises host:port and installs the native adapter', () {
      final ship = SpaceShip(baseUrl: _baseUrl, proxy: 'http://localhost:8080');

      expect(ship.proxy, 'localhost:8080');
      expect(ship.dio.httpClientAdapter, isA<IOHttpClientAdapter>());
    });

    test('accepts a bare host:port', () {
      expect(
        SpaceShip(baseUrl: _baseUrl, proxy: 'proxy.local:3128').proxy,
        'proxy.local:3128',
      );
    });

    test('rejects a malformed proxy instead of ignoring it', () {
      for (final bad in <String>[
        '',
        '   ',
        'localhost',
        'localhost:0',
        'localhost:70000',
        'https://localhost:3128',
        'http://',
        'local host:3128',
      ]) {
        expect(
          () => SpaceShip(baseUrl: _baseUrl, proxy: bad),
          throwsArgumentError,
          reason: 'proxy: "$bad"',
        );
      }
    });

    test('refuses a proxy together with an injected Dio', () {
      expect(
        () => SpaceShip(baseUrl: _baseUrl, proxy: 'localhost:8080', dio: Dio()),
        throwsArgumentError,
      );
    });

    test('no proxy leaves the default adapter alone', () {
      final ship = SpaceShip(baseUrl: _baseUrl);

      expect(ship.proxy, isNull);
    });

    test('every LastFM constructor passes the proxy to its client', () {
      expect(
        LastFM.noAuth(apiKey: 'key', proxy: 'proxy.local:3128').client.proxy,
        'proxy.local:3128',
      );
      expect(
        LastFM.withSessionKey(
          apiKey: 'key',
          apiSecret: 'secret',
          sessionKey: 'session',
          proxy: 'proxy.local:3129',
        ).client.proxy,
        'proxy.local:3129',
      );
    });

    test('an invalid proxy fails at construction, not at request time', () {
      expect(
        () => LastFM.noAuth(apiKey: 'key', proxy: 'nonsense'),
        throwsArgumentError,
      );
    });
  });
}
