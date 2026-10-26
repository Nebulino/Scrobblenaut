import 'dart:convert';

import 'package:scrobblenaut/lastfm.dart';
import 'package:test/test.dart';

// Fixtures: the shape Last.fm sends, trimmed to a handful of fields.

const _trackJson = '''
{"name":"Believe","mbid":"6d6a5a7e","url":"https://www.last.fm/music/Cher/_/Believe",
 "duration":"239000","listeners":"1234567","playcount":"8901234","loved":"1",
 "streamable":{"#text":"0","fulltrack":"0"},
 "artist":{"name":"Cher","url":"https://www.last.fm/music/Cher"},
 "album":{"artist":"Cher","title":"Believe","image":[{"#text":"https://lastfm.example/s.png","size":"small"}]},
 "toptags":{"tag":[{"name":"pop","url":"https://www.last.fm/tag/pop"}]}}''';

const _albumJson = '''
{"name":"Believe","artist":"Cher","url":"https://www.last.fm/music/Cher/Believe",
 "listeners":"250000","playcount":"3000000","mbid":"a1b2",
 "image":[{"#text":"https://lastfm.example/m.png","size":"mega"}],
 "tags":{"tag":[{"name":"pop"}]},
 "tracks":{"track":[{"name":"Believe","duration":"239","artist":{"name":"Cher"}}]}}''';

const _artistJson = '''
{"name":"Cher","mbid":"bfcc6d75","url":"https://www.last.fm/music/Cher",
 "streamable":"0","ontour":"1","stats":{"listeners":"900000","playcount":"45000000"},
 "image":[{"#text":"https://lastfm.example/l.png","size":"large"}],
 "similar":{"artist":[{"name":"Madonna"}]},"tags":{"tag":[{"name":"pop"}]},
 "bio":{"summary":"Short","content":"Long"}}''';

const _tagJson = '''
{"name":"pop","url":"https://www.last.fm/tag/pop","count":"3","total":"1500000",
 "reach":"400000","taggings":"1500000","streamable":"0","wiki":{"summary":"Pop music","content":"Pop music is..."}}''';

const _opensearch = '''
"opensearch:TotalResults":"1234","opensearch:StartIndex":"0","opensearch:ItemsPerPage":"2"''';

const _trackSearchJson =
    '''
{$_opensearch,"trackmatches":{"track":[
 {"name":"Believe","artist":"Cher","url":"https://www.last.fm/music/Cher/_/Believe","listeners":"7","image":[],"mbid":""},
 {"name":"Believe","artist":"Justin Bieber","url":"https://www.last.fm/music/Justin+Bieber/_/Believe","listeners":"5","image":[],"mbid":""}]}}''';

const _albumSearchJson =
    '''
{$_opensearch,"albummatches":{"album":[
 {"name":"Believe","artist":"Cher","url":"https://www.last.fm/music/Cher/Believe","image":[],"mbid":"a1b2"},
 {"name":"Believe","artist":"Disturbed","url":"https://www.last.fm/music/Disturbed/Believe","image":[],"mbid":""}]}}''';

const _artistSearchJson =
    '''
{$_opensearch,"artistmatches":{"artist":[
 {"name":"Cher","listeners":"900000","mbid":"bfcc6d75","url":"https://www.last.fm/music/Cher","streamable":"0","image":[]},
 {"name":"Cherry","listeners":"100","mbid":"","url":"https://www.last.fm/music/Cherry","streamable":"0","image":[]}]}}''';

Map<String, dynamic> _json(String source) =>
    jsonDecode(source) as Map<String, dynamic>;

/// What a caller sends over the wire / stores: the JSON text of [toJson].
Map<String, dynamic> _wire(Map<String, dynamic> toJson) =>
    _json(jsonEncode(toJson));

void main() {
  group('Track', () {
    test('fromJson reads the Last.fm shape, normalizing its odd types', () {
      final track = Track.fromJson(_json(_trackJson));

      expect(track.name, 'Believe');
      expect(track.mbid, '6d6a5a7e');
      expect(track.duration, const Duration(milliseconds: 239000));
      expect(track.listeners, 1234567);
      expect(track.playCount, 8901234);
      expect(track.loved, isTrue);
      expect(track.streamable!.text, '0');
      expect(track.artist!.name, 'Cher');
      expect(track.album!.title, 'Believe');
      expect(track.album!.artist!.name, 'Cher');
      expect(track.album!.images!.single.size, Size.small);
      expect(track.topTags!.single.name, 'pop');
    });

    test('toJson omits the fields that are null', () {
      expect(Track(name: 'Believe').toJson(), {'name': 'Believe'});
    });

    test('flat fields survive a toJson -> fromJson round-trip', () {
      final track = Track(
        name: 'Believe',
        url: 'https://www.last.fm/music/Cher/_/Believe',
        mbid: '6d6a5a7e',
        listeners: 1234567,
        playCount: 8901234,
      );

      final copy = Track.fromJson(_wire(track.toJson()));

      expect(copy.name, track.name);
      expect(copy.url, track.url);
      expect(copy.mbid, track.mbid);
      expect(copy.listeners, track.listeners);
      expect(copy.playCount, track.playCount);
    });
  });

  group('Album', () {
    test('fromJson reads the Last.fm shape', () {
      final album = Album.fromJson(_json(_albumJson));

      expect(album.name, 'Believe');
      expect(album.artist!.name, 'Cher');
      expect(album.listeners, 250000);
      expect(album.playCount, 3000000);
      expect(album.mbid, 'a1b2');
      expect(album.images!.single.size, Size.mega);
      expect(album.tags!.single.name, 'pop');
      expect(album.tracks!.single.name, 'Believe');
      expect(album.tracks!.single.artist!.name, 'Cher');
    });

    test('toJson omits the fields that are null', () {
      expect(Album(name: 'Believe').toJson(), {'name': 'Believe'});
    });

    test('flat fields survive a toJson -> fromJson round-trip', () {
      final album = Album(
        name: 'Believe',
        title: 'Believe',
        url: 'https://www.last.fm/music/Cher/Believe',
        listeners: 250000,
        playCount: 3000000,
        mbid: 'a1b2',
      );

      final copy = Album.fromJson(_wire(album.toJson()));

      expect(copy.name, album.name);
      expect(copy.title, album.title);
      expect(copy.url, album.url);
      expect(copy.listeners, album.listeners);
      expect(copy.playCount, album.playCount);
      expect(copy.mbid, album.mbid);
    });
  });

  group('Artist', () {
    test('fromJson reads the Last.fm shape', () {
      final artist = Artist.fromJson(_json(_artistJson));

      expect(artist.name, 'Cher');
      expect(artist.mbid, 'bfcc6d75');
      expect(artist.isStreamable, isFalse);
      expect(artist.onTour, isTrue);
      expect(artist.stats!.listeners, 900000);
      expect(artist.stats!.playCount, 45000000);
      expect(artist.images!.single.size, Size.large);
      expect(artist.similarArtists!.single.name, 'Madonna');
      expect(artist.tags!.single.name, 'pop');
      expect(artist.bio!.summary, 'Short');
    });

    test('toJson omits the fields that are null', () {
      expect(Artist(name: 'Cher').toJson(), {'name': 'Cher'});
    });

    test('flat fields survive a toJson -> fromJson round-trip', () {
      final artist = Artist(
        name: 'Cher',
        url: 'https://www.last.fm/music/Cher',
        mbid: 'bfcc6d75',
        listeners: 900000,
        playCount: 45000000,
        stats: Stats(listeners: 900000, playCount: 45000000),
      );

      final copy = Artist.fromJson(_wire(artist.toJson()));

      expect(copy.name, artist.name);
      expect(copy.url, artist.url);
      expect(copy.mbid, artist.mbid);
      expect(copy.listeners, artist.listeners);
      expect(copy.playCount, artist.playCount);
      expect(copy.stats!.listeners, 900000);
      expect(copy.stats!.playCount, 45000000);
    });
  });

  group('Tag', () {
    test('fromJson reads the Last.fm shape', () {
      final tag = Tag.fromJson(_json(_tagJson));

      expect(tag.name, 'pop');
      expect(tag.count, 3);
      expect(tag.total, 1500000);
      expect(tag.reach, 400000);
      expect(tag.taggings, 1500000);
      expect(tag.streamable, isFalse);
      expect(tag.wiki!.summary, 'Pop music');
    });

    test('toJson omits the fields that are null', () {
      expect(Tag(name: 'pop').toJson(), {'name': 'pop'});
    });

    test('flat fields survive a toJson -> fromJson round-trip', () {
      final tag = Tag(
        name: 'pop',
        url: 'https://www.last.fm/tag/pop',
        count: 3,
        total: 1500000,
        reach: 400000,
        taggings: 1500000,
      );

      final copy = Tag.fromJson(_wire(tag.toJson()));

      expect(copy.name, tag.name);
      expect(copy.url, tag.url);
      expect(copy.count, 3);
      expect(copy.total, 1500000);
      expect(copy.reach, 400000);
      expect(copy.taggings, 1500000);
    });
  });

  group('search results wrappers', () {
    test(
      'TrackSearchResults reads the matches and the opensearch counters',
      () {
        final results = TrackSearchResults.fromJson(_json(_trackSearchJson));

        expect(results.totalResults, 1234);
        expect(results.statingIndex, 0);
        expect(results.itemsPerPage, 2);
        expect(results.tracks!.map((t) => t.artist!.name), [
          'Cher',
          'Justin Bieber',
        ]);
        expect(results.tracks!.first.listeners, 7);
      },
    );

    test(
      'AlbumSearchResults reads the matches and the opensearch counters',
      () {
        final results = AlbumSearchResults.fromJson(_json(_albumSearchJson));

        expect(results.totalResults, 1234);
        expect(results.itemsPerPage, 2);
        expect(results.albums!.map((a) => a.artist!.name), [
          'Cher',
          'Disturbed',
        ]);
        expect(results.albums!.first.mbid, 'a1b2');
      },
    );

    test(
      'ArtistSearchResults reads the matches and the opensearch counters',
      () {
        final results = ArtistSearchResults.fromJson(_json(_artistSearchJson));

        expect(results.totalResults, 1234);
        expect(results.itemsPerPage, 2);
        expect(results.artists!.map((a) => a.name), ['Cher', 'Cherry']);
        expect(results.artists!.first.listeners, 900000);
      },
    );

    test('the counters survive a toJson -> fromJson round-trip', () {
      final track = TrackSearchResults(
        totalResults: 1234,
        statingIndex: 0,
        itemsPerPage: 2,
      );
      final album = AlbumSearchResults(
        totalResults: 1234,
        statingIndex: 0,
        itemsPerPage: 2,
      );
      final artist = ArtistSearchResults(
        totalResults: 1234,
        statingIndex: 0,
        itemsPerPage: 2,
      );

      final trackCopy = TrackSearchResults.fromJson(_wire(track.toJson()));
      final albumCopy = AlbumSearchResults.fromJson(_wire(album.toJson()));
      final artistCopy = ArtistSearchResults.fromJson(_wire(artist.toJson()));

      expect(trackCopy.totalResults, 1234);
      expect(albumCopy.itemsPerPage, 2);
      expect(artistCopy.statingIndex, 0);
    });
  });

  // The complete round-trip is broken in the library today. These tests state
  // the contract and are skipped until the serialization is fixed, which is
  // a behaviour change outside this run (additive only). Each reason is a real
  // measurement, not a guess.
  group('complete toJson -> fromJson round-trip (known bugs)', () {
    const nestedLists =
        'toJson writes nested lists (toptags/tags/similar/tracks/...matches) '
        'as bare Lists, but fromJson expects the Last.fm {"tag": [...]} '
        'wrapper object, so fromJson throws a cast error.';

    test(
      'Track keeps its duration',
      () {
        final track = Track.fromJson(_json(_trackJson));

        final copy = Track.fromJson(
          _wire(Track(name: 'x', duration: track.duration).toJson()),
        );

        expect(copy.duration, track.duration);
      },
      skip:
          'toJson writes duration in microseconds (239000000) while fromJson '
          'reads milliseconds, so a round-trip multiplies it by 1000.',
    );

    test('Track', () {
      final track = Track.fromJson(_json(_trackJson));
      final copy = Track.fromJson(_wire(track.toJson()));
      expect(_wire(copy.toJson()), _wire(track.toJson()));
    }, skip: nestedLists);

    test('Album', () {
      final album = Album.fromJson(_json(_albumJson));
      final copy = Album.fromJson(_wire(album.toJson()));
      expect(_wire(copy.toJson()), _wire(album.toJson()));
    }, skip: nestedLists);

    test('Artist', () {
      final artist = Artist.fromJson(_json(_artistJson));
      final copy = Artist.fromJson(_wire(artist.toJson()));
      expect(_wire(copy.toJson()), _wire(artist.toJson()));
    }, skip: nestedLists);

    test(
      'Tag',
      () {
        final tag = Tag.fromJson(_json(_tagJson));
        final copy = Tag.fromJson(_wire(tag.toJson()));
        expect(_wire(copy.toJson()), _wire(tag.toJson()));
      },
      skip:
          'toJson writes streamable as a bool, but fromJson '
          '(NumberToBool) only accepts 0/1 and throws a ScrobblenautException '
          'on a bool. Same for Track.loved and Artist.onTour.',
    );

    test('TrackSearchResults, AlbumSearchResults and ArtistSearchResults', () {
      final tracks = TrackSearchResults.fromJson(_json(_trackSearchJson));
      final copy = TrackSearchResults.fromJson(_wire(tracks.toJson()));
      expect(_wire(copy.toJson()), _wire(tracks.toJson()));
    }, skip: nestedLists);
  });
}
