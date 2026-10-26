import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:scrobblenaut/src/helpers/lastfm_value_normalizer.dart';
import 'package:scrobblenaut/src/helpers/now_played_track.dart';
import 'package:scrobblenaut/src/helpers/scrobble_response.dart';
import 'package:scrobblenaut/src/helpers/scrobbled_track.dart';
import 'package:scrobblenaut/src/helpers/utils.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

/// What Last.fm documents for `ignoredMessage code`.
const _ignoredMessages = <int, String>{
  0: '',
  1: 'Artist was ignored',
  2: 'Track was ignored',
  3: 'Timestamp was too old',
  4: 'Timestamp was too new',
  5: 'Daily scrobble limit exceeded',
};

String _nowPlayingXml({String? ignoredCode, String message = ''}) =>
    '''<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
  <nowplaying>
    <track corrected="1">Believe</track>
    <artist corrected="0">Cher</artist>
    <album corrected="0">Believe</album>
    <albumArtist corrected="0">Cher</albumArtist>
    ${ignoredCode == null ? '' : '<ignoredMessage code="$ignoredCode">$message</ignoredMessage>'}
  </nowplaying>
</lfm>''';

XmlElement _scrobbleElement({String? ignoredCode, String message = ''}) =>
    XmlDocument.parse('''
<scrobble>
  <track corrected="0">Believe</track>
  <artist corrected="1">Cher</artist>
  <album corrected="0">Believe</album>
  <albumArtist corrected="0">Cher</albumArtist>
  <timestamp>1600000000</timestamp>
  ${ignoredCode == null ? '' : '<ignoredMessage code="$ignoredCode">$message</ignoredMessage>'}
</scrobble>''').rootElement;

void main() {
  group('parseLastFMList', () {
    test('wraps a single Map (the 3.0.1 CastError regression) in a list', () {
      final result = parseLastFMList<String>({
        'name': 'Only One',
      }, (item) => item['name'] as String);

      expect(result, ['Only One']);
    });

    test('maps every element of a List, in order', () {
      final result = parseLastFMList<String>([
        {'name': 'A'},
        {'name': 'B'},
        {'name': 'C'},
      ], (item) => item['name'] as String);

      expect(result, ['A', 'B', 'C']);
    });

    test('returns an empty list for an empty List', () {
      expect(parseLastFMList<String>([], (item) => 'x'), isEmpty);
    });

    test('returns null for null', () {
      expect(parseLastFMList<String>(null, (item) => 'x'), isNull);
    });

    test('returns null for a node that is neither a List nor a Map', () {
      expect(parseLastFMList<String>('oops', (item) => 'x'), isNull);
    });

    test('hands fromJson a copy, so the response is not mutated', () {
      final raw = {'name': 'A'};

      parseLastFMList<String>(raw, (item) {
        item['name'] = 'changed';
        return 'x';
      });

      expect(raw['name'], 'A');
    });
  });

  group('NowPlayedTrack.parse', () {
    test('reads names, corrected flags and a clean ignoredMessage', () {
      final result = NowPlayedTrack.parse(_nowPlayingXml(ignoredCode: '0'));

      expect(result.status, isTrue);
      expect(result.track, 'Believe');
      expect(result.artist, 'Cher');
      expect(result.album, 'Believe');
      expect(result.albumArtist, 'Cher');
      expect(result.tracksCorrected, isTrue);
      expect(result.artistsCorrected, isFalse);
      expect(result.albumsCorrected, isFalse);
      expect(result.albumArtistsCorrected, isFalse);
      expect(result.isIgnored, isFalse);
    });

    for (final entry in _ignoredMessages.entries) {
      test('ignoredMessage code ${entry.key} sets isIgnored '
          'to ${entry.key != 0}', () {
        final result = NowPlayedTrack.parse(
          _nowPlayingXml(ignoredCode: '${entry.key}', message: entry.value),
        );

        expect(result.ignoredMessageCode, entry.key);
        expect(result.isIgnored, entry.key != 0);
      });
    }

    test(
      'a response without ignoredMessage has no code and is not ignored',
      () {
        final result = NowPlayedTrack.parse(_nowPlayingXml());

        expect(result.ignoredMessageCode, isNull);
        expect(result.isIgnored, isFalse);
      },
    );

    test('a non-numeric ignoredMessage code is read as no code', () {
      final result = NowPlayedTrack.parse(_nowPlayingXml(ignoredCode: 'x'));

      expect(result.ignoredMessageCode, isNull);
      expect(result.isIgnored, isFalse);
    });

    test('rejects an unknown envelope status', () {
      expect(
        () => NowPlayedTrack.parse('<lfm status="huh"></lfm>'),
        throwsA(isA<ScrobblenautException>()),
      );
    });
  });

  group('ScrobbledTrack.parse', () {
    test('reads names, corrected flags and the timestamp', () {
      final result = ScrobbledTrack.parse(_scrobbleElement(ignoredCode: '0'));

      expect(result.track, 'Believe');
      expect(result.artist, 'Cher');
      expect(result.album, 'Believe');
      expect(result.albumArtist, 'Cher');
      expect(result.tracksCorrected, isFalse);
      expect(result.artistsCorrected, isTrue);
      expect(result.timestamp!.millisecondsSinceEpoch, 1600000000 * 1000);
    });

    for (final entry in _ignoredMessages.entries) {
      test('ignoredMessage code ${entry.key} sets isIgnored '
          'to ${entry.key != 0}', () {
        final result = ScrobbledTrack.parse(
          _scrobbleElement(ignoredCode: '${entry.key}', message: entry.value),
        );

        expect(result.ignoredMessageCode, entry.key);
        expect(result.isIgnored, entry.key != 0);
      });
    }

    test('a scrobble without ignoredMessage is not ignored', () {
      final result = ScrobbledTrack.parse(_scrobbleElement());

      expect(result.ignoredMessageCode, isNull);
      expect(result.isIgnored, isFalse);
    });
  });

  group('ScrobbleResponse.parse', () {
    test('reads the counters and every scrobble of a batch', () {
      final response = ScrobbleResponse.parse('''
<lfm status="ok">
  <scrobbles accepted="2" ignored="1">
    <scrobble>
      <track corrected="0">A</track><artist corrected="0">X</artist>
      <album corrected="0">AA</album><albumArtist corrected="0">X</albumArtist>
      <timestamp>1600000000</timestamp>
      <ignoredMessage code="0"></ignoredMessage>
    </scrobble>
    <scrobble>
      <track corrected="0">B</track><artist corrected="0">X</artist>
      <album corrected="0">AA</album><albumArtist corrected="0">X</albumArtist>
      <timestamp>1600000100</timestamp>
      <ignoredMessage code="3">Timestamp was too old</ignoredMessage>
    </scrobble>
  </scrobbles>
</lfm>''');

      expect(response.status, isTrue);
      expect(response.scrobbleAccepted, 2);
      expect(response.scrobbleIgnored, 1);
      expect(response.scrobbleResponses.map((s) => s.track), ['A', 'B']);
      expect(response.scrobbleResponses.map((s) => s.isIgnored), [false, true]);
    });
  });

  group('LastFMValueNormalizer', () {
    test('NumberToInt accepts the int and the String Last.fm may send', () {
      expect(LastFMValueNormalizer.NumberToInt('42'), 42);
      expect(LastFMValueNormalizer.NumberToInt(42), 42);
      expect(LastFMValueNormalizer.NumberToInt(null), isNull);
    });

    test('NumberToInt refuses a value that is not a number', () {
      expect(
        () => LastFMValueNormalizer.NumberToInt(4.2),
        throwsA(isA<ScrobblenautException>()),
      );
    });

    test('NumberToBool reads 1/0 as int or String', () {
      expect(LastFMValueNormalizer.NumberToBool('1'), isTrue);
      expect(LastFMValueNormalizer.NumberToBool(1), isTrue);
      expect(LastFMValueNormalizer.NumberToBool('0'), isFalse);
      expect(LastFMValueNormalizer.NumberToBool(0), isFalse);
      expect(LastFMValueNormalizer.NumberToBool(null), isNull);
    });

    test('NumberToBool refuses a real bool', () {
      expect(
        () => LastFMValueNormalizer.NumberToBool(true),
        throwsA(isA<ScrobblenautException>()),
      );
    });

    test('BoolToIntBool writes bools as 1/0', () {
      expect(LastFMValueNormalizer.BoolToIntBool(true), 1);
      expect(LastFMValueNormalizer.BoolToIntBool(false), 0);
      expect(LastFMValueNormalizer.BoolToIntBool(null), isNull);
    });

    test('isArtistStreamable reads "0"/"1" and refuses anything else', () {
      expect(LastFMValueNormalizer.isArtistStreamable('1'), isTrue);
      expect(LastFMValueNormalizer.isArtistStreamable(0), isFalse);
      expect(LastFMValueNormalizer.isArtistStreamable(null), isNull);
      expect(
        () => LastFMValueNormalizer.isArtistStreamable('2'),
        throwsA(isA<ScrobblenautException>()),
      );
    });

    test('MillisecondsDurationParser reads milliseconds (track.getInfo)', () {
      expect(
        LastFMValueNormalizer.MillisecondsDurationParser('215000'),
        const Duration(seconds: 215),
      );
      expect(
        LastFMValueNormalizer.MillisecondsDurationParser(215000),
        const Duration(seconds: 215),
      );
      expect(LastFMValueNormalizer.MillisecondsDurationParser(null), isNull);
    });

    test('MillisecondsDurationParser reads Last.fm FIXME as no duration', () {
      expect(LastFMValueNormalizer.MillisecondsDurationParser('FIXME'), isNull);
    });

    test('SecondsDurationParser reads seconds (album.getInfo)', () {
      expect(
        LastFMValueNormalizer.SecondsDurationParser('215'),
        const Duration(seconds: 215),
      );
      expect(
        LastFMValueNormalizer.SecondsDurationParser(215),
        const Duration(seconds: 215),
      );
      expect(LastFMValueNormalizer.SecondsDurationParser(null), isNull);
    });

    test('DurationToSeconds and DurationToMilliseconds write durations', () {
      const duration = Duration(seconds: 215, milliseconds: 500);

      expect(LastFMValueNormalizer.DurationToSeconds(duration), 215);
      expect(LastFMValueNormalizer.DurationToMilliseconds(duration), 215500);
      expect(LastFMValueNormalizer.DurationToSeconds(null), isNull);
    });

    test('DateTimeFromUnixTime reads epoch seconds as String or int', () {
      final expected = DateTime.fromMillisecondsSinceEpoch(1600000000 * 1000);

      expect(
        LastFMValueNormalizer.DateTimeFromUnixTime('1600000000'),
        expected,
      );
      expect(LastFMValueNormalizer.DateTimeFromUnixTime(1600000000), expected);
    });

    test('DateTimeFromUnixTime reads nil and null as no date', () {
      expect(LastFMValueNormalizer.DateTimeFromUnixTime('nil'), isNull);
      expect(LastFMValueNormalizer.DateTimeFromUnixTime(null), isNull);
    });

    test('timestamps are written as epoch seconds, rounded to the nearest', () {
      DateTime at(int ms) => DateTime.fromMillisecondsSinceEpoch(ms);

      expect(
        LastFMValueNormalizer.timestampToSecondsSinceEpoch(at(1600000000000)),
        1600000000,
      );
      expect(LastFMValueNormalizer.timestampToSecondsSinceEpoch(at(1499)), 1);
      expect(LastFMValueNormalizer.timestampToSecondsSinceEpoch(at(1500)), 2);
      expect(LastFMValueNormalizer.timestampToSecondsSinceEpoch(null), isNull);
      expect(
        LastFMValueNormalizer.DateTimeToUnixTime(at(1600000000000)),
        1600000000,
      );
    });

    test('reading then writing a timestamp is lossless', () {
      final read = LastFMValueNormalizer.DateTimeFromUnixTime('1600000123');

      expect(
        LastFMValueNormalizer.timestampToSecondsSinceEpoch(read),
        1600000123,
      );
    });

    test('ArtistParser accepts a bare name or an artist object', () {
      expect(LastFMValueNormalizer.ArtistParser('Cher')!.name, 'Cher');
      expect(
        LastFMValueNormalizer.ArtistParser({
          'name': 'Cher',
          'mbid': 'abc',
        })!.mbid,
        'abc',
      );
      expect(LastFMValueNormalizer.ArtistParser(null), isNull);
    });

    test('tagsExtractor accepts a list of tags and a single tag Map', () {
      final list = LastFMValueNormalizer.tagsExtractor({
        'tag': [
          {'name': 'pop'},
          {'name': 'dance'},
        ],
      });
      final single = LastFMValueNormalizer.tagsExtractor({
        'tag': {'name': 'pop'},
      });

      expect(list!.map((t) => t.name), ['pop', 'dance']);
      expect(single!.map((t) => t.name), ['pop']);
      expect(LastFMValueNormalizer.tagsExtractor(null), isNull);
    });

    test('MeaninglessNumber stringifies, keeping null', () {
      expect(LastFMValueNormalizer.MeaninglessNumber(7), '7');
      expect(LastFMValueNormalizer.MeaninglessNumber(null), isNull);
    });
  });
}
