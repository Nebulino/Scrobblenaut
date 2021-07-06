//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:scrobblenaut/src/helpers/lastfm_value_normalizer.dart';
import 'package:xml/xml.dart' as xml;

/// This represent a Scrobble Information from a
/// response of [Track.scrobbleOnce] or [Track.scrobble].
class NowPlayedTrack {
  /// The response status of the [NowPlaying] Response.
  final bool _status;

  /// Track name.
  final String _track;

  /// Album name.
  final String _album;

  /// Artist name.
  final String _artist;

  /// Album Artist name.
  final String _albumArtist;

  /// True if is a corrected track.
  final bool? _tracksCorrected;

  /// True if is a corrected artist.
  final bool? _artistsCorrected;

  /// True if is a corrected album.
  final bool? _albumsCorrected;

  /// True if is a corrected album artist.
  final bool? _albumArtistsCorrected;

  /// The received ignoreMessage code.
  final bool? _ignoredMessageCode;

  NowPlayedTrack._(
    this._status,
    this._track,
    this._album,
    this._artist,
    this._albumArtist,
    this._tracksCorrected,
    this._artistsCorrected,
    this._albumsCorrected,
    this._albumArtistsCorrected,
    this._ignoredMessageCode,
  );

  factory NowPlayedTrack.parse(String response) {
    // It creates the document.
    final responseXML = xml.XmlDocument.parse(response);

    bool status;
    String track;
    String album;
    String artist;
    String albumArtist;
    bool? tracksCorrected;
    bool? artistsCorrected;
    bool? albumsCorrected;
    bool? albumArtistsCorrected;
    bool? ignoredMessageCode;

    // Status node.
    final statusNode = responseXML.findElements('lfm').first;

    if (statusNode.getAttribute('status') == 'ok') {
      status = true;
    } else if (statusNode.getAttribute('status') == 'failed') {
      status = false;
    } else {
      throw ScrobblenautException(description: 'Response unrecognized.');
    }

    bool? _s2b(supposedBool) =>
        LastFMValueNormalizer.NumberToBool(supposedBool);

    track = responseXML.findAllElements('track').first.text;

    album = responseXML.findAllElements('album').first.text;

    artist = responseXML.findAllElements('artist').first.text;

    albumArtist = responseXML.findAllElements('albumArtist').first.text;

    tracksCorrected = _s2b(
        responseXML.findAllElements('track').first.getAttribute('corrected'));

    artistsCorrected = _s2b(
        responseXML.findAllElements('artist').first.getAttribute('corrected'));

    albumsCorrected = _s2b(
        responseXML.findAllElements('album').first.getAttribute('corrected'));

    albumArtistsCorrected = _s2b(responseXML
        .findAllElements('albumArtist')
        .first
        .getAttribute('corrected'));

    ignoredMessageCode = _s2b(responseXML
        .findAllElements('ignoredMessage')
        .first
        .getAttribute('code'));

    return NowPlayedTrack._(
      status,
      track,
      album,
      artist,
      albumArtist,
      tracksCorrected,
      artistsCorrected,
      albumsCorrected,
      albumArtistsCorrected,
      ignoredMessageCode,
    );
  }

  /// Returns the status.
  bool get status => _status;

  /// Track name.
  String get track => _track;

  /// Album name.
  String get album => _album;

  /// Artist name.
  String get artist => _artist;

  /// Album Artist name.
  String get albumArtist => _albumArtist;

  /// True if is a corrected track.
  bool? get tracksCorrected => _tracksCorrected;

  /// True if is a corrected artist.
  bool? get artistsCorrected => _artistsCorrected;

  /// True if is a corrected album.
  bool? get albumsCorrected => _albumsCorrected;

  /// True if is a corrected album artist.
  bool? get albumArtistsCorrected => _albumArtistsCorrected;

  /// The received ignoreMessage code.
  bool? get ignoredMessageCode => _ignoredMessageCode;
}
