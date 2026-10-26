import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/lastfm_methods.dart';
import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';
import '../support/signature.dart';

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

const _nowPlayingXml = '''<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
  <nowplaying>
    <track corrected="0">Believe</track>
    <artist corrected="0">Cher</artist>
    <album corrected="0">Believe</album>
    <albumArtist corrected="0">Cher</albumArtist>
    <ignoredMessage code="0"></ignoredMessage>
  </nowplaying>
</lfm>''';

const _okXml = '<?xml version="1.0" encoding="utf-8"?><lfm status="ok"></lfm>';

// A trimmed track.getInfo response, as Last.fm sends it.
const _trackInfoJson = '''
{"track":{"name":"Believe","mbid":"6d6a5a7e-0000-4000-8000-000000000001",
 "url":"https://www.last.fm/music/Cher/_/Believe","duration":"239000",
 "streamable":{"#text":"0","fulltrack":"0"},
 "listeners":"1234567","playcount":"8901234",
 "artist":{"name":"Cher","mbid":"bfcc6d75-a6a5-4bc6-8282-47aec8531818","url":"https://www.last.fm/music/Cher"},
 "album":{"artist":"Cher","title":"Believe","url":"https://www.last.fm/music/Cher/Believe",
          "image":[{"#text":"https://lastfm.example/s.png","size":"small"}]},
 "toptags":{"tag":[{"name":"pop","url":"https://www.last.fm/tag/pop"}]}}}''';

void main() {
  late FakeHttpClientAdapter adapter;

  setUp(() => adapter = FakeHttpClientAdapter());

  group('getInfo', () {
    test('GETs track.getInfo with the track, the artist and autocorrect=0, '
        'and sends nothing it was not given', () async {
      adapter.enqueue(FakeResponse.json(_trackInfoJson));

      await TrackMethods(
        fakeLastFM(adapter),
      ).getInfo(track: 'Believe', artist: 'Cher');

      final sent = adapter.single;
      expect(sent.httpMethod, 'GET');
      expect(sent.query, {
        'method': 'track.getInfo',
        'api_key': fakeApiKey,
        'format': 'json',
        'track': 'Believe',
        'artist': 'Cher',
        'autocorrect': '0',
      });
    });

    test('sends mbid, username and autocorrect=1 when asked to', () async {
      adapter.enqueue(FakeResponse.json(_trackInfoJson));

      await TrackMethods(fakeLastFM(adapter)).getInfo(
        mbid: '6d6a5a7e-0000-4000-8000-000000000001',
        username: 'rj',
        autoCorrect: true,
      );

      final query = adapter.single.query;
      expect(query['mbid'], '6d6a5a7e-0000-4000-8000-000000000001');
      expect(query['username'], 'rj');
      expect(query['autocorrect'], '1');
      expect(query, isNot(contains('track')));
      expect(query, isNot(contains('artist')));
    });

    test('returns the parsed Track', () async {
      adapter.enqueue(FakeResponse.json(_trackInfoJson));

      final track = await TrackMethods(
        fakeLastFM(adapter),
      ).getInfo(track: 'Believe', artist: 'Cher');

      expect(track.name, 'Believe');
      expect(track.artist!.name, 'Cher');
      expect(track.duration, const Duration(milliseconds: 239000));
      expect(track.listeners, 1234567);
      expect(track.playCount, 8901234);
      expect(track.album!.title, 'Believe');
      expect(track.album!.artist!.name, 'Cher');
      expect(track.album!.images!.single.size, Size.small);
      expect(track.topTags!.map((t) => t.name), ['pop']);
    });

    test(
      'without mbid or both track and artist, fails with no request',
      () async {
        final methods = TrackMethods(fakeLastFM(adapter));

        await expectLater(
          methods.getInfo(track: 'Believe'),
          throwsA(isA<ScrobblenautException>()),
        );
        expect(adapter.requests, isEmpty);
      },
    );

    test('a Last.fm error is surfaced as a LastFMException', () async {
      adapter.enqueue(
        FakeResponse.json({
          'error': 6,
          'message': 'Track not found',
        }, statusCode: 404),
      );

      await expectLater(
        TrackMethods(
          fakeLastFM(adapter),
        ).getInfo(track: 'Nope', artist: 'Nobody'),
        throwsA(
          isA<LastFMException>()
              .having((e) => e.errorCode, 'errorCode', 6)
              .having((e) => e.description, 'description', 'Track not found'),
        ),
      );
    });
  });

  group('scrobble', () {
    test('POSTs a signed track.scrobble with integer duration seconds, '
        '1/0 chosenByUser and epoch-seconds timestamp', () async {
      adapter.enqueue(FakeResponse.xml(_scrobbleXml(1)));

      await TrackMethods(fakeAuthLastFM(adapter)).scrobble(
        track: 'Believe',
        artist: 'Cher',
        album: 'Believe',
        albumArtist: 'Cher',
        trackNumber: 1,
        duration: const Duration(minutes: 3, seconds: 35, milliseconds: 900),
        timestamp: DateTime.utc(2020, 9, 13, 12, 26, 40),
        chosenByUser: true,
      );

      final sent = adapter.single;
      expect(sent.httpMethod, 'POST');
      expect(sent.query, isEmpty);
      expect(sent.form, {
        'method': 'track.scrobble',
        'api_key': fakeApiKey,
        'sk': fakeSessionKey,
        'track': 'Believe',
        'artist': 'Cher',
        'album': 'Believe',
        'albumArtist': 'Cher',
        'trackNumber': '1',
        'duration': '215',
        'timestamp': '1600000000',
        'chosenByUser': '1',
        'api_sig': expectedSignature(sent.form, fakeApiSecret),
      });
    });

    test('chosenByUser defaults to 0', () async {
      adapter.enqueue(FakeResponse.xml(_scrobbleXml(1)));

      await TrackMethods(
        fakeAuthLastFM(adapter),
      ).scrobble(track: 'Believe', artist: 'Cher');

      expect(adapter.single.form['chosenByUser'], '0');
    });

    test('timestamp defaults to now, in epoch seconds', () async {
      adapter.enqueue(FakeResponse.xml(_scrobbleXml(1)));
      final before = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await TrackMethods(
        fakeAuthLastFM(adapter),
      ).scrobble(track: 'Believe', artist: 'Cher');

      final after = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final sent = int.parse(adapter.single.form['timestamp']!);
      expect(sent, inInclusiveRange(before, after + 1));
    });

    test('omits the optional fields it was not given', () async {
      adapter.enqueue(FakeResponse.xml(_scrobbleXml(1)));

      await TrackMethods(
        fakeAuthLastFM(adapter),
      ).scrobble(track: 'Believe', artist: 'Cher');

      expect(
        adapter.single.form.keys,
        unorderedEquals([
          'method',
          'api_key',
          'sk',
          'api_sig',
          'track',
          'artist',
          'timestamp',
          'chosenByUser',
        ]),
      );
    });

    test('returns the parsed ScrobbleResponse', () async {
      adapter.enqueue(FakeResponse.xml(_scrobbleXml(1)));

      final response = await TrackMethods(
        fakeAuthLastFM(adapter),
      ).scrobble(track: 'Believe', artist: 'Cher');

      expect(response.status, isTrue);
      expect(response.scrobbleAccepted, 1);
      expect(response.scrobbleIgnored, 0);
      expect(response.scrobbleResponses.single.track, 'Track 0');
    });
  });

  group('scrobbleFromObject', () {
    test('POSTs the Scrobble fields the same way scrobble does', () async {
      adapter.enqueue(FakeResponse.xml(_scrobbleXml(1)));

      await TrackMethods(fakeAuthLastFM(adapter)).scrobbleFromObject(
        scrobble: Scrobble(
          track: 'Believe',
          artist: 'Cher',
          duration: const Duration(seconds: 239),
          timestamp: DateTime.utc(2020, 9, 13, 12, 26, 40),
          chosenByUser: false,
        ),
      );

      final form = adapter.single.form;
      expect(form['method'], 'track.scrobble');
      expect(form['duration'], '239');
      expect(form['timestamp'], '1600000000');
      expect(form['chosenByUser'], '0');
      expect(form['api_sig'], expectedSignature(form, fakeApiSecret));
    });
  });

  group('multiScrobble', () {
    test('uses 0-based indexed keys, with 1/0 chosenByUser, integer duration '
        'seconds and epoch-seconds timestamps', () async {
      adapter.enqueue(FakeResponse.xml(_scrobbleXml(2)));

      await TrackMethods(fakeAuthLastFM(adapter)).multiScrobble(
        scrobbleList: [
          Scrobble(
            track: 'One',
            artist: 'Cher',
            album: 'Believe',
            duration: const Duration(seconds: 200, milliseconds: 999),
            timestamp: DateTime.utc(2020, 9, 13, 12, 26, 40),
            chosenByUser: true,
          ),
          Scrobble(
            track: 'Two',
            artist: 'Cher',
            timestamp: DateTime.utc(2020, 9, 13, 12, 30, 0),
            chosenByUser: false,
          ),
        ],
      );

      final sent = adapter.single;
      expect(sent.httpMethod, 'POST');
      expect(sent.form, {
        'method': 'track.scrobble',
        'api_key': fakeApiKey,
        'sk': fakeSessionKey,
        'track[0]': 'One',
        'artist[0]': 'Cher',
        'album[0]': 'Believe',
        'duration[0]': '200',
        'timestamp[0]': '1600000000',
        'chosenByUser[0]': '1',
        'track[1]': 'Two',
        'artist[1]': 'Cher',
        'timestamp[1]': '1600000200',
        'chosenByUser[1]': '0',
        'api_sig': expectedSignature(sent.form, fakeApiSecret),
      });
    });

    test(
      'a chosenByUser left unset is omitted rather than sent as 0',
      () async {
        adapter.enqueue(FakeResponse.xml(_scrobbleXml(1)));

        await TrackMethods(fakeAuthLastFM(adapter)).multiScrobble(
          scrobbleList: [Scrobble(track: 'One', artist: 'Cher')],
        );

        expect(adapter.single.form, isNot(contains('chosenByUser[0]')));
      },
    );

    test('accepts a full batch of 50, keyed track[0]..track[49]', () async {
      adapter.enqueue(FakeResponse.xml(_scrobbleXml(50)));
      final batch = [
        for (var i = 0; i < 50; i++)
          Scrobble(
            track: 'Track $i',
            artist: 'Cher',
            timestamp: DateTime.utc(2020, 9, 13).add(Duration(minutes: i)),
          ),
      ];

      final response = await TrackMethods(
        fakeAuthLastFM(adapter),
      ).multiScrobble(scrobbleList: batch);

      final form = adapter.single.form;
      final trackKeys = form.keys.where((k) => k.startsWith('track[')).toSet();
      expect(trackKeys, {for (var i = 0; i < 50; i++) 'track[$i]'});
      expect(form, isNot(contains('track[50]')));
      expect(form['track[49]'], 'Track 49');
      expect(form['api_sig'], expectedSignature(form, fakeApiSecret));
      expect(response.scrobbleResponses, hasLength(50));
    });

    test('chunks more than 50 scrobbles instead of refusing them', () async {
      final batch = [
        for (var i = 0; i < 51; i++) Scrobble(track: 'T$i', artist: 'Cher'),
      ];
      adapter
        ..enqueue(FakeResponse.xml(_scrobbleXml(50)))
        ..enqueue(FakeResponse.xml(_scrobbleXml(1)));

      final response = await TrackMethods(
        fakeAuthLastFM(adapter),
      ).multiScrobble(scrobbleList: batch);

      expect(adapter.requests, hasLength(2));
      expect(response.scrobbleAccepted, 51);
      expect(response.scrobbleResponses, hasLength(51));
    });
  });

  group('updateNowPlaying', () {
    test('POSTs a signed track.updateNowPlaying', () async {
      adapter.enqueue(FakeResponse.xml(_nowPlayingXml));

      await TrackMethods(fakeAuthLastFM(adapter)).updateNowPlaying(
        track: 'Believe',
        artist: 'Cher',
        album: 'Believe',
        duration: const Duration(seconds: 239, milliseconds: 400),
        chosenByUser: true,
      );

      final sent = adapter.single;
      expect(sent.httpMethod, 'POST');
      expect(sent.form, {
        'method': 'track.updateNowPlaying',
        'api_key': fakeApiKey,
        'sk': fakeSessionKey,
        'track': 'Believe',
        'artist': 'Cher',
        'album': 'Believe',
        'duration': '239',
        'chosenByUser': '1',
        'api_sig': expectedSignature(sent.form, fakeApiSecret),
      });
    });

    test('returns the parsed NowPlayedTrack', () async {
      adapter.enqueue(FakeResponse.xml(_nowPlayingXml));

      final result = await TrackMethods(
        fakeAuthLastFM(adapter),
      ).updateNowPlaying(track: 'Believe', artist: 'Cher');

      expect(result.status, isTrue);
      expect(result.track, 'Believe');
      expect(result.artist, 'Cher');
      expect(result.isIgnored, isFalse);
    });

    test('updateNowPlayingFromObject posts the same method', () async {
      adapter.enqueue(FakeResponse.xml(_nowPlayingXml));

      await TrackMethods(fakeAuthLastFM(adapter)).updateNowPlayingFromObject(
        track: NowPlaying(
          track: 'Believe',
          artist: 'Cher',
          duration: const Duration(seconds: 239),
        ),
      );

      final form = adapter.single.form;
      expect(form['method'], 'track.updateNowPlaying');
      expect(form['duration'], '239');
      expect(form['api_sig'], expectedSignature(form, fakeApiSecret));
    });
  });

  group('love / unLove / addTags / removeTag', () {
    test('love POSTs track.love and resolves to true', () async {
      adapter.enqueue(FakeResponse.xml(_okXml));

      final loved = await TrackMethods(
        fakeAuthLastFM(adapter),
      ).love(track: 'Believe', artist: 'Cher');

      expect(loved, isTrue);
      expect(adapter.single.form['method'], 'track.love');
      expect(adapter.single.form['track'], 'Believe');
    });

    test('unLove POSTs track.unlove', () async {
      adapter.enqueue(FakeResponse.xml(_okXml));

      await TrackMethods(
        fakeAuthLastFM(adapter),
      ).unLove(track: 'Believe', artist: 'Cher');

      expect(adapter.single.form['method'], 'track.unlove');
    });

    test('addTags joins the tags with commas', () async {
      adapter.enqueue(FakeResponse.xml(_okXml));

      await TrackMethods(
        fakeAuthLastFM(adapter),
      ).addTags(track: 'Believe', artist: 'Cher', tags: ['pop', 'dance']);

      expect(adapter.single.form['method'], 'track.addTags');
      expect(adapter.single.form['tags'], 'pop,dance');
    });

    test('addTags rejects more than 10 tags with no request', () async {
      await expectLater(
        TrackMethods(fakeAuthLastFM(adapter)).addTags(
          track: 'Believe',
          artist: 'Cher',
          tags: [for (var i = 0; i < 11; i++) 'tag$i'],
        ),
        throwsA(isA<ScrobblenautException>()),
      );
      expect(adapter.requests, isEmpty);
    });

    test('removeTag POSTs track.removeTag with the tag', () async {
      adapter.enqueue(FakeResponse.xml(_okXml));

      await TrackMethods(
        fakeAuthLastFM(adapter),
      ).removeTag(track: 'Believe', artist: 'Cher', tag: 'pop');

      expect(adapter.single.form['method'], 'track.removeTag');
      expect(adapter.single.form['tag'], 'pop');
    });
  });

  group('methods that need authentication, on a noAuth client', () {
    final calls = <String, Future<Object?> Function(TrackMethods)>{
      'scrobble': (m) => m.scrobble(track: 'Believe', artist: 'Cher'),
      'scrobbleFromObject': (m) => m.scrobbleFromObject(
        scrobble: Scrobble(track: 'Believe', artist: 'Cher'),
      ),
      'updateNowPlaying': (m) =>
          m.updateNowPlaying(track: 'Believe', artist: 'Cher'),
      'updateNowPlayingFromObject': (m) => m.updateNowPlayingFromObject(
        track: NowPlaying(track: 'Believe', artist: 'Cher'),
      ),
      'love': (m) => m.love(track: 'Believe', artist: 'Cher'),
      'unLove': (m) => m.unLove(track: 'Believe', artist: 'Cher'),
      'addTags': (m) =>
          m.addTags(track: 'Believe', artist: 'Cher', tags: ['pop']),
      'removeTag': (m) =>
          m.removeTag(track: 'Believe', artist: 'Cher', tag: 'pop'),
    };

    for (final entry in calls.entries) {
      test('${entry.key} fails with a ScrobblenautException and makes no '
          'HTTP request', () async {
        // Any request would be answered, so only the guard can keep it silent.
        adapter.enqueue(FakeResponse.xml(_okXml));
        final methods = TrackMethods(fakeLastFM(adapter));

        await expectLater(
          entry.value(methods),
          throwsA(isA<ScrobblenautException>()),
        );
        expect(adapter.requests, isEmpty);
      });
    }

    // multiScrobble must fail locally like every other authenticated POST.
    test('multiScrobble fails with a ScrobblenautException and makes no '
        'HTTP request', () async {
      adapter.enqueue(FakeResponse.xml(_scrobbleXml(1)));
      final methods = TrackMethods(fakeLastFM(adapter));

      await expectLater(
        methods.multiScrobble(
          scrobbleList: [Scrobble(track: 'Believe', artist: 'Cher')],
        ),
        throwsA(isA<ScrobblenautException>()),
      );
      expect(adapter.requests, isEmpty);
    });

    test('the same guard does not block a public method', () async {
      adapter.enqueue(FakeResponse.json(_trackInfoJson));

      await TrackMethods(
        fakeLastFM(adapter),
      ).getInfo(track: 'Believe', artist: 'Cher');

      expect(adapter.requests, hasLength(1));
    });
  });
}
