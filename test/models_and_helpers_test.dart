//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/scrobblenaut.dart';
import 'package:scrobblenaut/src/helpers/now_played_track.dart';
import 'package:scrobblenaut/src/helpers/scrobbled_track.dart';
import 'package:scrobblenaut/src/helpers/utils.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('LastFM authentication constructors', () {
    test('LastFM.noAuth initializes correctly', () {
      final lastFM = LastFM.noAuth(apiKey: 'test-api-key');
      expect(lastFM.isAuth, isFalse);
      expect(lastFM.apiKey, 'test-api-key');
      expect(lastFM.sessionKey, isNull);
    });

    test('LastFM.withSessionKey initializes authenticated instance', () {
      final lastFM = LastFM.withSessionKey(
        apiKey: 'test-api-key',
        apiSecret: 'test-api-secret',
        sessionKey: 'test-session-key',
        username: 'test-user',
      );
      expect(lastFM.isAuth, isTrue);
      expect(lastFM.apiKey, 'test-api-key');
      expect(lastFM.apiSecret, 'test-api-secret');
      expect(lastFM.sessionKey, 'test-session-key');
      expect(lastFM.username, 'test-user');
    });
  });

  group('Scrobble model tests', () {
    test('serialization and deserialization with albumArtist', () {
      final scrobble = Scrobble(
        track: 'Song Title',
        artist: 'Featured Artist',
        album: 'Album Title',
        albumArtist: 'Main Artist',
        duration: Duration(seconds: 180),
        chosenByUser: true,
      );

      final json = scrobble.toJson();
      expect(json['track'], 'Song Title');
      expect(json['artist'], 'Featured Artist');
      expect(json['albumArtist'], 'Main Artist');
      expect(json['album'], 'Album Title');

      final deserialized = Scrobble.fromJson(json);
      expect(deserialized.track, 'Song Title');
      expect(deserialized.artist, 'Featured Artist');
      expect(deserialized.albumArtist, 'Main Artist');
      expect(deserialized.album, 'Album Title');
    });
  });

  group('NowPlayedTrack XML parser', () {
    test('parses successfully with ignored message code', () {
      const xmlString = '''<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
  <nowplaying>
    <track corrected="0">Track One</track>
    <artist corrected="0">Artist One</artist>
    <album corrected="0">Album One</album>
    <albumArtist corrected="0">Album Artist One</albumArtist>
    <ignoredMessage code="1">Artist was ignored</ignoredMessage>
  </nowplaying>
</lfm>''';

      final result = NowPlayedTrack.parse(xmlString);
      expect(result.track, 'Track One');
      expect(result.artist, 'Artist One');
      expect(result.album, 'Album One');
      expect(result.albumArtist, 'Album Artist One');
      expect(result.isIgnored, isTrue);
      expect(result.ignoredMessageCode, 1);
    });

    test('parses successfully when not ignored', () {
      const xmlString = '''<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
  <nowplaying>
    <track corrected="0">Track Two</track>
    <artist corrected="0">Artist Two</artist>
    <album corrected="0">Album Two</album>
    <albumArtist corrected="0">Album Artist Two</albumArtist>
    <ignoredMessage code="0"></ignoredMessage>
  </nowplaying>
</lfm>''';

      final result = NowPlayedTrack.parse(xmlString);
      expect(result.track, 'Track Two');
      expect(result.isIgnored, isFalse);
      expect(result.ignoredMessageCode, 0);
    });
  });

  group('ScrobbledTrack XML parser', () {
    test('parses scrobbles with ignoredMessage attributes', () {
      const xmlString = '''
      <scrobble>
        <track corrected="0">Track S</track>
        <artist corrected="0">Artist S</artist>
        <album corrected="0">Album S</album>
        <albumArtist corrected="0">Album Artist S</albumArtist>
        <timestamp>1600000000</timestamp>
        <ignoredMessage code="2">Timestamp too old</ignoredMessage>
      </scrobble>''';

      final document = XmlDocument.parse(xmlString);
      final track = ScrobbledTrack.parse(document.rootElement);

      expect(track.track, 'Track S');
      expect(track.artist, 'Artist S');
      expect(track.album, 'Album S');
      expect(track.albumArtist, 'Album Artist S');
      expect(track.isIgnored, isTrue);
      expect(track.ignoredMessageCode, 2);
    });
  });

  group('Utils tests', () {
    test('isValidParsableStringField evaluates correctly', () {
      expect(isValidParsableStringField(null), isFalse);
      expect(isValidParsableStringField(''), isFalse);
      expect(isValidParsableStringField('null'), isFalse);
      expect(isValidParsableStringField('valid'), isTrue);
    });

    test('generateMD5 produces correct hash', () {
      expect(generateMD5('hello'), '5d41402abc4b2a76b9719d911017c592');
    });
  });
}
