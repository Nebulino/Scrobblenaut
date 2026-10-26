import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/lastfm_methods.dart';
import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';

// user.getRecentTracks, trimmed. The nowplaying entry has no `date`.
const _recentTracksList = '''
{"recenttracks":{"track":[
 {"@attr":{"nowplaying":"true"},"artist":{"mbid":"","#text":"Cher"},"streamable":"0",
  "image":[{"size":"small","#text":"https://lastfm.example/s.png"}],"mbid":"",
  "album":{"mbid":"","#text":"Believe"},"name":"Believe",
  "url":"https://www.last.fm/music/Cher/_/Believe"},
 {"artist":{"mbid":"","#text":"Sigur Rós"},"streamable":"0","image":[],"mbid":"abc",
  "album":{"mbid":"","#text":"Takk"},"name":"Hoppípolla",
  "url":"https://www.last.fm/music/Sigur+R%C3%B3s/_/Hopp%C3%ADpolla",
  "date":{"uts":"1600000000","#text":"13 Sep 2020, 12:26"}}],
 "@attr":{"user":"rj","totalPages":"1","page":"1","perPage":"50","total":"2"}}}''';

// Last.fm's XML-to-JSON engine sends a lone item as an object, not a list.
const _recentTracksSingle = '''
{"recenttracks":{"track":
 {"artist":{"mbid":"","#text":"Cher"},"streamable":"0","image":[],"mbid":"",
  "album":{"mbid":"","#text":"Believe"},"name":"Believe",
  "url":"https://www.last.fm/music/Cher/_/Believe",
  "date":{"uts":"1600000000","#text":"13 Sep 2020, 12:26"}},
 "@attr":{"user":"rj","totalPages":"1","page":"1","perPage":"50","total":"1"}}}''';

const _topArtistsList = '''
{"topartists":{"artist":[
 {"name":"Cher","playcount":"321","mbid":"bfcc6d75-a6a5-4bc6-8282-47aec8531818",
  "url":"https://www.last.fm/music/Cher","streamable":"0",
  "image":[{"size":"large","#text":"https://lastfm.example/l.png"}],"@attr":{"rank":"1"}},
 {"name":"Björk","playcount":"123","mbid":"","url":"https://www.last.fm/music/Bj%C3%B6rk",
  "streamable":"1","image":[],"@attr":{"rank":"2"}}],
 "@attr":{"user":"rj","totalPages":"1","page":"1","perPage":"50","total":"2"}}}''';

const _topArtistsSingle = '''
{"topartists":{"artist":
 {"name":"Cher","playcount":"321","mbid":"bfcc6d75-a6a5-4bc6-8282-47aec8531818",
  "url":"https://www.last.fm/music/Cher","streamable":"0",
  "image":[],"@attr":{"rank":"1"}},
 "@attr":{"user":"rj","totalPages":"1","page":"1","perPage":"50","total":"1"}}}''';

void main() {
  late FakeHttpClientAdapter adapter;
  late UserMethods user;

  setUp(() {
    adapter = FakeHttpClientAdapter();
    user = UserMethods(fakeLastFM(adapter));
  });

  group('getRecentTracks', () {
    test('GETs user.getRecentTracks with its defaults', () async {
      adapter.enqueue(FakeResponse.json(_recentTracksList));

      await user.getRecentTracks(user: 'rj');

      final sent = adapter.single;
      expect(sent.httpMethod, 'GET');
      expect(sent.query, {
        'method': 'user.getRecentTracks',
        'api_key': fakeApiKey,
        'format': 'json',
        'user': 'rj',
        'page': '1',
        'limit': '50',
        'extended': '0',
      });
    });

    test('sends from/to as epoch seconds, page, limit and extended', () async {
      adapter.enqueue(FakeResponse.json(_recentTracksList));

      await user.getRecentTracks(
        user: 'rj',
        page: 3,
        limit: 200,
        fromDate: DateTime.utc(2020, 9, 13, 12, 26, 40),
        toDate: DateTime.utc(2020, 9, 14, 12, 26, 40),
        extended: true,
      );

      final query = adapter.single.query;
      expect(query['from'], '1600000000');
      expect(query['to'], '1600086400');
      expect(query['page'], '3');
      expect(query['limit'], '200');
      expect(query['extended'], '1');
    });

    test('parses every track of the list', () async {
      adapter.enqueue(FakeResponse.json(_recentTracksList));

      final tracks = (await user.getRecentTracks(user: 'rj'))!;

      expect(tracks.map((t) => t.name), ['Believe', 'Hoppípolla']);
      expect(tracks.map((t) => t.artist!.name), ['Cher', 'Sigur Rós']);
      expect(tracks[0].date, isNull);
      expect(tracks[0].images!.single.size, Size.small);
      expect(tracks[1].mbid, 'abc');
      expect(tracks[1].date!.unixDate, '1600000000');
      expect(tracks[1].date!.text, '13 Sep 2020, 12:26');
    });

    test('parses a response with a single track as a Map '
        '(the 3.0.1 CastError regression)', () async {
      adapter.enqueue(FakeResponse.json(_recentTracksSingle));

      final tracks = (await user.getRecentTracks(user: 'rj'))!;

      expect(tracks, hasLength(1));
      expect(tracks.single.name, 'Believe');
      expect(tracks.single.artist!.name, 'Cher');
      expect(tracks.single.date!.unixDate, '1600000000');
    });

    test('resolves to null when the user has no tracks', () async {
      adapter.enqueue(
        FakeResponse.json(
          '{"recenttracks":{"@attr":{"user":"rj","total":"0"}}}',
        ),
      );

      expect(await user.getRecentTracks(user: 'rj'), isNull);
    });

    test('rejects a limit above 200 with no request', () async {
      await expectLater(
        user.getRecentTracks(user: 'rj', limit: 201),
        throwsA(isA<ScrobblenautException>()),
      );
      expect(adapter.requests, isEmpty);
    });
  });

  group('getTopArtists', () {
    test('GETs user.getTopArtists with its defaults, and no period', () async {
      adapter.enqueue(FakeResponse.json(_topArtistsList));

      await user.getTopArtists(user: 'rj');

      expect(adapter.single.query, {
        'method': 'user.getTopArtists',
        'api_key': fakeApiKey,
        'format': 'json',
        'user': 'rj',
        'page': '1',
        'limit': '50',
      });
    });

    test('sends the period in Last.fm notation', () async {
      adapter.enqueue(FakeResponse.json(_topArtistsList));

      await user.getTopArtists(user: 'rj', period: Period.MONTHS3, limit: 5);

      expect(adapter.single.query['period'], '3month');
      expect(adapter.single.query['limit'], '5');
    });

    test('parses every artist of the list', () async {
      adapter.enqueue(FakeResponse.json(_topArtistsList));

      final artists = (await user.getTopArtists(user: 'rj'))!;

      expect(artists.map((a) => a.name), ['Cher', 'Björk']);
      expect(artists.map((a) => a.playCount), [321, 123]);
      expect(artists[0].mbid, 'bfcc6d75-a6a5-4bc6-8282-47aec8531818');
      expect(artists.map((a) => a.isStreamable), [false, true]);
      expect(artists[0].images!.single.size, Size.large);
    });

    test('parses a response with a single artist as a Map '
        '(the 3.0.1 CastError regression)', () async {
      adapter.enqueue(FakeResponse.json(_topArtistsSingle));

      final artists = (await user.getTopArtists(user: 'rj'))!;

      expect(artists, hasLength(1));
      expect(artists.single.name, 'Cher');
      expect(artists.single.playCount, 321);
    });

    test('resolves to null when there are no artists', () async {
      adapter.enqueue(
        FakeResponse.json('{"topartists":{"@attr":{"user":"rj","total":"0"}}}'),
      );

      expect(await user.getTopArtists(user: 'rj'), isNull);
    });
  });
}
