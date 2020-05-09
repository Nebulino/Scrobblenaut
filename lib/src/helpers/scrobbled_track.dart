//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/src/helpers/lastfm_value_normalizer.dart';
import 'package:xml/xml.dart' as xml;

/// This represent a Scrobble Information from a
/// response of [Track.scrobbleOnce] or [Track.scrobble].
class ScrobbledTrack {
  /// Track name.
  final String _track;

  /// Album name.
  final String _album;

  /// Artist name.
  final String _artist;

  /// Album Artist name.
  final String _albumArtist;

  /// True if is a corrected track.
  final bool _tracksCorrected;

  /// True if is a corrected artist.
  final bool _artistsCorrected;

  /// True if is a corrected album.
  final bool _albumsCorrected;

  /// True if is a corrected album artist.
  final bool _albumArtistsCorrected;

  /// The timestamp of the scrobble.
  final DateTime _timestamp;

  /// The received ignoreMessage code.
  final bool _ignoredMessageCode;

  ScrobbledTrack._(
    this._track,
    this._album,
    this._artist,
    this._albumArtist,
    this._tracksCorrected,
    this._artistsCorrected,
    this._albumsCorrected,
    this._albumArtistsCorrected,
    this._timestamp,
    this._ignoredMessageCode,
  );

  factory ScrobbledTrack.parse(xml.XmlElement scrobbleElement) {
    String track;
    String album;
    String artist;
    String albumArtist;
    bool tracksCorrected;
    bool artistsCorrected;
    bool albumsCorrected;
    bool albumArtistsCorrected;
    DateTime timestamp;
    bool ignoredMessageCode;

    bool _s2b(supposedBool) => LastFMValueNormalizer.NumberToBool(supposedBool);

    track = scrobbleElement.findAllElements('track').first.text;

    album = scrobbleElement.findAllElements('album').first.text;

    artist = scrobbleElement.findAllElements('artist').first.text;

    albumArtist = scrobbleElement.findAllElements('albumArtist').first.text;

    tracksCorrected = _s2b(scrobbleElement
        .findAllElements('track')
        .first
        .getAttribute('corrected'));

    artistsCorrected = _s2b(scrobbleElement
        .findAllElements('artist')
        .first
        .getAttribute('corrected'));

    albumsCorrected = _s2b(scrobbleElement
        .findAllElements('album')
        .first
        .getAttribute('corrected'));

    albumArtistsCorrected = _s2b(scrobbleElement
        .findAllElements('albumArtist')
        .first
        .getAttribute('corrected'));

    timestamp = LastFMValueNormalizer.DateTimeFromUnixTime(
        scrobbleElement.findAllElements('timestamp').first.text);

    ignoredMessageCode = _s2b(scrobbleElement
        .findAllElements('ignoredMessage')
        .first
        .getAttribute('code'));

    return ScrobbledTrack._(
      track,
      album,
      artist,
      albumArtist,
      tracksCorrected,
      artistsCorrected,
      albumsCorrected,
      albumArtistsCorrected,
      timestamp,
      ignoredMessageCode,
    );
  }

  /// Track name.
  String get track => _track;

  /// Album name.
  String get album => _album;

  /// Artist name.
  String get artist => _artist;

  /// Album Artist name.
  String get albumArtist => _albumArtist;

  /// True if is a corrected track.
  bool get tracksCorrected => _tracksCorrected;

  /// True if is a corrected artist.
  bool get artistsCorrected => _artistsCorrected;

  /// True if is a corrected album.
  bool get albumsCorrected => _albumsCorrected;

  /// True if is a corrected album artist.
  bool get albumArtistsCorrected => _albumArtistsCorrected;

  /// The timestamp of the scrobble.
  DateTime get timestamp => _timestamp;

  /// The received ignoreMessage code.
  bool get ignoredMessageCode => _ignoredMessageCode;
}
