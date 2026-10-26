import 'package:dio/dio.dart';
import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:scrobblenaut/src/helpers/post_response_helper.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';

/// Last.fm error codes, with the descriptions documented at
/// https://www.last.fm/api/errorcodes, plus one it does not document.
const _errors = <int, String>{
  6: 'Invalid parameters - Your request is missing a required parameter',
  8: 'Operation failed - Something else went wrong',
  9: 'Invalid session key - Please re-authenticate',
  10: 'Invalid API key - You must be granted a valid key by last.fm',
  11: 'Service Offline - This service is temporarily offline. Try again later.',
  13: 'Invalid method signature supplied',
  16: 'There was a temporary error processing your request. Please try again',
  26: 'Suspended API key - Access for your account has been suspended',
  999: 'Some code nobody documented',
};

String _xmlError(int code, String message) =>
    '<?xml version="1.0" encoding="utf-8"?>\n'
    '<lfm status="failed">\n'
    '  <error code="$code">$message</error>\n'
    '</lfm>';

Matcher _lastFmError(int code, String description) => isA<LastFMException>()
    .having((e) => e.errorCode, 'errorCode', code)
    .having((e) => e.description, 'description', description);

void main() {
  group('PostResponseHelper.parse', () {
    test('reads the success envelope as status true', () {
      final response = PostResponseHelper.parse(
        '<?xml version="1.0" encoding="utf-8"?>\n<lfm status="ok"></lfm>',
      );

      expect(response.status, isTrue);
    });

    test('reads the failed envelope as status false', () {
      final response = PostResponseHelper.parse(_xmlError(6, 'Invalid'));

      expect(response.status, isFalse);
    });

    test('rejects an unknown status with a ScrobblenautException', () {
      expect(
        () => PostResponseHelper.parse('<lfm status="weird"></lfm>'),
        throwsA(isA<ScrobblenautException>()),
      );
    });

    test('rejects a body that is not XML', () {
      expect(() => PostResponseHelper.parse('{"error":6}'), throwsA(anything));
    });
  });

  group('LastFMException.generate', () {
    for (final entry in _errors.entries) {
      test('maps the XML error code ${entry.key}', () {
        final exception = LastFMException.generate(
          _xmlError(entry.key, entry.value),
        );

        expect(exception, _lastFmError(entry.key, entry.value));
      });

      test('maps the JSON error code ${entry.key}', () {
        final exception = LastFMException.generate({
          'error': entry.key,
          'message': entry.value,
        });

        expect(exception, _lastFmError(entry.key, entry.value));
      });
    }

    test('reads an XML error that has no XML declaration', () {
      final exception = LastFMException.generate(
        '<lfm status="failed"><error code="9">Invalid session key</error></lfm>',
      );

      expect(exception, _lastFmError(9, 'Invalid session key'));
    });

    test('a JSON error without a message has an empty description', () {
      final exception = LastFMException.generate({'error': 6});

      expect(exception, _lastFmError(6, ''));
    });

    test('keeps the request it was raised for', () {
      final options = RequestOptions(path: '/x');

      final exception = LastFMException.generate({
        'error': 6,
        'message': 'm',
      }, requestOptions: options);

      expect(exception.requestOptions, same(options));
    });

    test('toString names the code and the description', () {
      final exception = LastFMException.generate({
        'error': 10,
        'message': 'Invalid API key',
      });

      expect(
        exception.toString(),
        '[LastFMException] => [Code 10]: Invalid API key',
      );
    });
  });

  group('errors coming back through the HTTP client', () {
    late FakeHttpClientAdapter adapter;

    setUp(() => adapter = FakeHttpClientAdapter());

    for (final entry in _errors.entries) {
      test('JSON error ${entry.key} on HTTP 200 becomes a LastFMException', () {
        adapter.enqueue(
          FakeResponse.json({'error': entry.key, 'message': entry.value}),
        );

        expect(
          fakeSpaceShip(adapter).get(parameters: {'method': 'user.getInfo'}),
          throwsA(_lastFmError(entry.key, entry.value)),
        );
      });

      test('JSON error ${entry.key} on HTTP 403 becomes a LastFMException', () {
        adapter.enqueue(
          FakeResponse.json({
            'error': entry.key,
            'message': entry.value,
          }, statusCode: 403),
        );

        expect(
          fakeSpaceShip(adapter).get(parameters: {'method': 'user.getInfo'}),
          throwsA(_lastFmError(entry.key, entry.value)),
        );
      });

      test('XML error ${entry.key} on HTTP 200 becomes a LastFMException', () {
        adapter.enqueue(FakeResponse.xml(_xmlError(entry.key, entry.value)));

        expect(
          fakeSpaceShip(adapter).post(parameters: {'method': 'track.love'}),
          throwsA(_lastFmError(entry.key, entry.value)),
        );
      });

      test('XML error ${entry.key} on HTTP 400 becomes a LastFMException', () {
        adapter.enqueue(
          FakeResponse.xml(_xmlError(entry.key, entry.value), statusCode: 400),
        );

        expect(
          fakeSpaceShip(adapter).post(parameters: {'method': 'track.love'}),
          throwsA(_lastFmError(entry.key, entry.value)),
        );
      });
    }

    test(
      'a failed error carries the request that caused it (HTTP 4xx)',
      () async {
        adapter.enqueue(
          FakeResponse.json({'error': 6, 'message': 'm'}, statusCode: 400),
        );

        try {
          await fakeSpaceShip(
            adapter,
          ).get(parameters: {'method': 'user.getInfo'});
          fail('Expected a LastFMException.');
        } on LastFMException catch (e) {
          expect(
            e.requestOptions.uri.queryParameters['method'],
            'user.getInfo',
          );
        }
      },
    );

    test('a transport failure is not disguised as a LastFMException', () {
      // The adapter has no canned response, so it fails like a dead network.
      expect(
        fakeSpaceShip(adapter).get(parameters: {'method': 'user.getInfo'}),
        throwsA(
          isA<DioException>().having(
            (e) => e is LastFMException,
            'is LastFMException',
            isFalse,
          ),
        ),
      );
    });

    test('a successful XML body is returned untouched', () async {
      const body = '<lfm status="ok"><x/></lfm>';
      adapter.enqueue(FakeResponse.xml(body));

      final data = await fakeSpaceShip(
        adapter,
      ).post(parameters: {'method': 'track.love'});

      expect(data, body);
    });
  });
}
