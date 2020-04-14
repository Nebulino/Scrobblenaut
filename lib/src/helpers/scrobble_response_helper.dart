/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:xml/xml.dart' as xml;

/// It helps getting a object from a Response of [SpaceShip]
/// when a [Track.scrobbleOnce] or [Track.scrobble] is used.
/// It handles the different content.
class ScrobbleResponseHelper {
  /// The response status of the [Scrobble] Response.
  final bool _status;

  /// Number of accepted scrobble.
  final int _scrobbleAccepted;

  /// Number of ignored scrobble.
  final int _scrobbleIgnored;

  /// Number of corrected tracks.
  final int _tracksCorrected;

  /// Number of corrected artists.
  final int _artistsCorrected;

  /// Number of corrected albums.
  final int _albumsCorrected;

  /// Number of corrected album artists.
  final int _albumArtistsCorrected;

  /// The timestamp of the scrobble.
  final DateTime _timestamp;

  /// The received ignoreMessage code.
  final int _ignoreMessageCode;

  ScrobbleResponseHelper(
    this._status,
    this._scrobbleAccepted,
    this._scrobbleIgnored,
    this._tracksCorrected,
    this._artistsCorrected,
    this._albumsCorrected,
    this._albumArtistsCorrected,
    this._timestamp,
    this._ignoreMessageCode,
  );


  factory ScrobbleResponseHelper.parse(String response) {
    return null;
  }
}
