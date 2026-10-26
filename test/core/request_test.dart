import 'dart:convert';
import 'dart:typed_data';

import 'package:scrobblenaut/src/core/request.dart';
import 'package:scrobblenaut/src/core/request_mode.dart';
import 'package:scrobblenaut/src/helpers/utils.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';

const _okXml = '<lfm status="ok"></lfm>';

void main() {
  late FakeHttpClientAdapter adapter;

  setUp(() {
    adapter = FakeHttpClientAdapter()
      ..enqueue(FakeResponse.json({'ok': 1}))
      ..enqueue(FakeResponse.xml(_okXml));
  });

  group('parameter assembly', () {
    test('GET sends api_key, method, format=json and the given parameters '
        'in the query string, unsigned without a session', () async {
      final request = Request(
        api: fakeLastFM(adapter),
        method: 'user.getInfo',
        parameters: {'user': 'rj'},
      );

      await request.send(mode: RequestMode.GET);

      final sent = adapter.single;
      expect(sent.httpMethod, 'GET');
      expect(sent.query, {
        'user': 'rj',
        'api_key': fakeApiKey,
        'method': 'user.getInfo',
        'format': 'json',
      });
      expect(sent.query, isNot(contains('sk')));
      expect(sent.query, isNot(contains('api_sig')));
    });

    test('POST sends the parameters form-encoded in the body, '
        'with no format and an empty query string', () async {
      adapter = FakeHttpClientAdapter()..enqueue(FakeResponse.xml(_okXml));
      final request = Request(
        api: fakeAuthLastFM(adapter),
        method: 'track.love',
        parameters: {'track': 'Believe', 'artist': 'Cher'},
      );

      await request.send(mode: RequestMode.POST);

      final sent = adapter.single;
      expect(sent.httpMethod, 'POST');
      expect(sent.contentType, startsWith('application/x-www-form-urlencoded'));
      expect(sent.query, isEmpty);
      expect(sent.form, {
        'track': 'Believe',
        'artist': 'Cher',
        'api_key': fakeApiKey,
        'method': 'track.love',
        'sk': fakeSessionKey,
        'api_sig': 'fc1e3228888f915810b746225030ca24',
      });
    });

    test('null parameters are dropped, other values are stringified', () async {
      final request = Request(
        api: fakeLastFM(adapter),
        method: 'user.getRecentTracks',
        parameters: {'user': 'rj', 'page': 2, 'extended': 0, 'from': null},
      );

      await request.send(mode: RequestMode.GET);

      final query = adapter.single.query;
      expect(query['page'], '2');
      expect(query['extended'], '0');
      expect(query, isNot(contains('from')));
    });

    test('api_key and method always win over caller supplied values', () async {
      final request = Request(
        api: fakeLastFM(adapter),
        method: 'user.getInfo',
        parameters: {'api_key': 'someone-else', 'method': 'user.other'},
      );

      await request.send(mode: RequestMode.GET);

      expect(adapter.single.query['api_key'], fakeApiKey);
      expect(adapter.single.query['method'], 'user.getInfo');
    });

    test('sk is injected only when the client has a session key', () async {
      await Request(
        api: fakeAuthLastFM(adapter),
        method: 'user.getInfo',
      ).send(mode: RequestMode.GET);

      expect(adapter.single.query['sk'], fakeSessionKey);
    });
  });

  group('formatUnicode', () {
    test('round-trips text unchanged', () {
      for (final text in ['Björk', '宇多田ヒカル', 'Sigur Rós – Hoppípolla', '']) {
        expect(formatUnicode(text: text), text);
      }
    });

    test('decodes UTF-8 bytes into text', () {
      final bytes = Uint8List.fromList(utf8.encode('Björk'));
      expect(formatUnicode(text: bytes), 'Björk');
    });

    test('stringifies non-text values', () {
      expect(formatUnicode(text: 42), '42');
      expect(formatUnicode(text: true), 'true');
    });

    test('non-ASCII values reach the wire intact', () async {
      adapter = FakeHttpClientAdapter()..enqueue(FakeResponse.xml(_okXml));
      final request = Request(
        api: fakeAuthLastFM(adapter),
        method: 'track.love',
        parameters: {'artist': '宇多田ヒカル', 'track': 'Automatic'},
      );

      await request.send(mode: RequestMode.POST);

      expect(adapter.single.form['artist'], '宇多田ヒカル');
      expect(
        adapter.single.form['api_sig'],
        'bb24c22398fd21d50e6df4793bedd069',
      );
    });
  });

  group('api_sig signing', () {
    test('is md5 of key+value pairs sorted by key, plus the secret', () async {
      adapter = FakeHttpClientAdapter()..enqueue(FakeResponse.xml(_okXml));
      final request = Request(
        api: fakeAuthLastFM(adapter),
        method: 'track.love',
        parameters: {'track': 'Believe', 'artist': 'Cher'},
      );

      await request.send(mode: RequestMode.POST);

      // md5('api_key' 'test-api-key' 'artist' 'Cher' 'method' 'track.love'
      //     'sk' 'test-session-key' 'track' 'Believe' 'test-api-secret')
      expect(
        adapter.single.form['api_sig'],
        'fc1e3228888f915810b746225030ca24',
      );
      expect(
        adapter.single.form['api_sig'],
        generateMD5(
          'api_keytest-api-key'
          'artistCher'
          'methodtrack.love'
          'sktest-session-key'
          'trackBelieve'
          'test-api-secret',
        ),
      );
    });

    test(
      'sorts keys by ASCII order, so artist[10] comes before artist[1]',
      () async {
        adapter = FakeHttpClientAdapter()..enqueue(FakeResponse.xml(_okXml));
        final request = Request(
          api: fakeAuthLastFM(adapter),
          method: 'track.scrobble',
          parameters: {'artist[1]': 'B', 'artist[2]': 'C', 'artist[10]': 'A'},
        );

        await request.send(mode: RequestMode.POST);

        expect(
          adapter.single.form['api_sig'],
          '0c59923ce32098ea5b6d19c4ccd220f5',
        );
      },
    );

    test('excludes format from a signed GET request', () async {
      final request = Request(
        api: fakeAuthLastFM(adapter),
        method: 'user.getInfo',
        parameters: {'user': 'rj'},
      );

      await request.send(mode: RequestMode.GET);

      final query = adapter.single.query;
      expect(query['format'], 'json');
      expect(
        query['api_sig'],
        generateMD5(
          'api_keytest-api-key'
          'methoduser.getInfo'
          'sktest-session-key'
          'userrj'
          'test-api-secret',
        ),
      );
    });

    test('without an api secret it signs the pairs alone', () async {
      // A client with no secret: noAuth, signed explicitly.
      final request = Request(
        api: fakeLastFM(adapter),
        method: 'user.getInfo',
        parameters: {'user': 'rj'},
      )..signRequest();

      await request.send(mode: RequestMode.GET);

      // md5('api_keytest-api-key' 'methoduser.getInfo' 'userrj')
      expect(
        adapter.single.query['api_sig'],
        '674afcce1130edfbabf6f75c9077fccc',
      );
    });

    test(
      'a session key without a secret is signed with an empty secret',
      () async {
        final request = Request(
          api: fakeLastFM(adapter, sessionKey: fakeSessionKey),
          method: 'user.getInfo',
          parameters: {'user': 'rj'},
        );

        await request.send(mode: RequestMode.GET);

        expect(
          adapter.single.query['api_sig'],
          'a71e8e2585a05398dd7db116db1ee6c7',
        );
      },
    );

    test(
      'signRequest is idempotent: signing twice keeps the first signature',
      () async {
        final request =
            Request(
                api: fakeAuthLastFM(adapter),
                method: 'track.love',
                parameters: {'track': 'Believe', 'artist': 'Cher'},
              )
              ..signRequest()
              ..signRequest();

        await request.send(mode: RequestMode.GET);

        expect(
          adapter.single.query['api_sig'],
          'fc1e3228888f915810b746225030ca24',
        );
      },
    );

    test('an unsigned request carries no api_sig', () async {
      await Request(
        api: fakeLastFM(adapter),
        method: 'user.getInfo',
      ).send(mode: RequestMode.GET);

      expect(adapter.single.query, isNot(contains('api_sig')));
    });
  });
}
