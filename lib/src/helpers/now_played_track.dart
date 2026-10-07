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
  final int? _ignoredMessageCode;

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
    int? ignoredMessageCode;

    // Status node.
    final statusNode = responseXML.findElements('lfm').first;

    if (statusNode.getAttribute('status') == 'ok') {
      status = true;
    } else if (statusNode.getAttribute('status') == 'failed') {
      status = false;
    } else {
      throw ScrobblenautException(description: 'Response unrecognized.');
    }

    bool? s2b(supposedBool) => LastFMValueNormalizer.NumberToBool(supposedBool);

    track = responseXML.findAllElements('track').first.innerText;

    album = responseXML.findAllElements('album').first.innerText;

    artist = responseXML.findAllElements('artist').first.innerText;

    albumArtist = responseXML.findAllElements('albumArtist').first.innerText;

    tracksCorrected = s2b(
      responseXML.findAllElements('track').first.getAttribute('corrected'),
    );

    artistsCorrected = s2b(
      responseXML.findAllElements('artist').first.getAttribute('corrected'),
    );

    albumsCorrected = s2b(
      responseXML.findAllElements('album').first.getAttribute('corrected'),
    );

    albumArtistsCorrected = s2b(
      responseXML
          .findAllElements('albumArtist')
          .first
          .getAttribute('corrected'),
    );

    final ignoredMsgElements = responseXML.findAllElements('ignoredMessage');
    final codeAttr = ignoredMsgElements.isNotEmpty
        ? ignoredMsgElements.first.getAttribute('code')
        : null;
    ignoredMessageCode = codeAttr != null ? int.tryParse(codeAttr) : null;

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

  /// The received ignoreMessage code (0 = ok, 1 = Artist ignored, 2 = Track ignored, 3 = Timestamp too old, 4 = Timestamp too new, 5 = Daily limit exceeded).
  int? get ignoredMessageCode => _ignoredMessageCode;

  /// True if now playing was ignored (code != 0).
  bool get isIgnored => _ignoredMessageCode != null && _ignoredMessageCode != 0;
}
