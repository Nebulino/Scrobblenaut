import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/lastfm_methods.dart';
import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';

String _scrobbleXml(int count, {int ignored = 0}) {
  final scrobbles = [
    for (var i = 0; i < count; i++)
      '''
<scrobble>
  <track corrected="0">Track $i</track>
  <artist corrected="0">Cher</artist>
  <album corrected="0">Believe</album>
  <albumArtist corrected="0">Cher</albumArtist>
  <timestamp>${1600000000 + i}</timestamp>
  <ignoredMessage code="0"></ignoredMessage>
</scrobble>''',
  ];
  return '<?xml version="1.0" encoding="utf-8"?>\n'
      '<lfm status="ok"><scrobbles accepted="${count - ignored}" '
      'ignored="$ignored">${scrobbles.join()}</scrobbles></lfm>';
}

List<Scrobble> _scrobbles(int count) => [
  for (var i = 0; i < count; i++)
    Scrobble(
      track: 'Track $i',
      artist: 'Cher',
      album: 'Believe',
      timestamp: DateTime.fromMillisecondsSinceEpoch((1600000000 + i) * 1000),
    ),
];

int _scrobblesIn(RecordedRequest request) =>
    request.form.keys.where((key) => key.startsWith('track[')).length;

void main() {
  late FakeHttpClientAdapter adapter;

  setUp(() => adapter = FakeHttpClientAdapter());

  group('multiScrobble chunking', () {
    test('splits 120 scrobbles into 50 + 50 + 20 sequential requests', () async {
      adapter
        ..enqueue(FakeResponse.xml(_scrobbleXml(50)))
        ..enqueue(FakeResponse.xml(_scrobbleXml(50)))
        ..enqueue(FakeResponse.xml(_scrobbleXml(20)));

      final response = await TrackMethods(
        fakeAuthLastFM(adapter),
      ).multiScrobble(scrobbleList: _scrobbles(120));

      expect(adapter.requests, hasLength(3));
      expect(adapter.requests.map(_scrobblesIn), [50, 50, 20]);
      expect(response.status, isTrue);
      expect(response.scrobbleAccepted, 120);
      expect(response.scrobbleResponses, hasLength(120));
    });

    test('keeps the 0-based keys Last.fm expects inside every block', () async {
      adapter
        ..enqueue(FakeResponse.xml(_scrobbleXml(50)))
        ..enqueue(FakeResponse.xml(_scrobbleXml(20)));

      await TrackMethods(
        fakeAuthLastFM(adapter),
      ).multiScrobble(scrobbleList: _scrobbles(70));

      final first = adapter.requests.first.form;
      expect(first['track[0]'], 'Track 0');
      expect(first['track[49]'], 'Track 49');
      expect(first.containsKey('track[50]'), isFalse);

      final second = adapter.requests[1].form;
      expect(second['track[0]'], 'Track 50');
      expect(second['track[19]'], 'Track 69');
    });

    test('keeps the order of the blocks and their scrobbles', () async {
      adapter
        ..enqueue(FakeResponse.xml(_scrobbleXml(50)))
        ..enqueue(FakeResponse.xml(_scrobbleXml(10)));

      final response = await TrackMethods(
        fakeAuthLastFM(adapter),
      ).multiScrobble(scrobbleList: _scrobbles(60));

      expect(
        response.scrobbleResponses.first.track,
        adapter.requests.first.form['track[0]'],
      );
      expect(response.scrobbleResponses, hasLength(60));
    });

    test('a list of 50 is exactly one request', () async {
      adapter.enqueue(FakeResponse.xml(_scrobbleXml(50)));

      await TrackMethods(
        fakeAuthLastFM(adapter),
      ).multiScrobble(scrobbleList: _scrobbles(50));

      expect(adapter.requests, hasLength(1));
    });

    test('a list of 51 becomes 50 + 1', () async {
      adapter
        ..enqueue(FakeResponse.xml(_scrobbleXml(50)))
        ..enqueue(FakeResponse.xml(_scrobbleXml(1)));

      await TrackMethods(
        fakeAuthLastFM(adapter),
      ).multiScrobble(scrobbleList: _scrobbles(51));

      expect(adapter.requests.map(_scrobblesIn), [50, 1]);
    });

    test('sums the accepted and ignored counters of every block', () async {
      adapter
        ..enqueue(FakeResponse.xml(_scrobbleXml(50, ignored: 2)))
        ..enqueue(FakeResponse.xml(_scrobbleXml(50, ignored: 3)))
        ..enqueue(FakeResponse.xml(_scrobbleXml(20, ignored: 1)));

      final response = await TrackMethods(
        fakeAuthLastFM(adapter),
      ).multiScrobble(scrobbleList: _scrobbles(120));

      expect(response.scrobbleAccepted, 114);
      expect(response.scrobbleIgnored, 6);
    });

    test('an empty list fails without sending anything', () async {
      await expectLater(
        TrackMethods(
          fakeAuthLastFM(adapter),
        ).multiScrobble(scrobbleList: const []),
        throwsA(isA<ScrobblenautException>()),
      );

      expect(adapter.requests, isEmpty);
    });

    test('a failure in a later block surfaces, after the earlier ones', () async {
      adapter
        ..enqueue(FakeResponse.xml(_scrobbleXml(50)))
        ..enqueue(
          FakeResponse.xml(
            '<?xml version="1.0" encoding="utf-8"?>'
            '<lfm status="failed"><error code="8">Operation failed</error></lfm>',
            // 400: not retried, so the failure surfaces immediately.
            statusCode: 400,
          ),
        );

      await expectLater(
        TrackMethods(
          fakeAuthLastFM(adapter),
        ).multiScrobble(scrobbleList: _scrobbles(60)),
        throwsA(isA<LastFMException>()),
      );
    });
  });
}
