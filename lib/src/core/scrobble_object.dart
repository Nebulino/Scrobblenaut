/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:meta/meta.dart';

/// This is a object that helps scrobbling multiple tracks.
class Scrobble {
  /// The [Track] title to scrobble.
  String track;

  /// The [Album] name to scrobble.
  String album;

  /// The [Artist] name to scrobble.
  String artist;

  /// The track number of the [Track] to scrobble.
  int trackNumber;

  /// The duration of the [Track] to scrobble.
  Duration duration;

  /// The TimeStamp of the scrobble.
  /// If You're not doing strange stuff, you can use DateTime.now().
  DateTime timeStamp;

  /// Sub-client version (not public, only enabled for certain API keys).
  String context;

  /// The stream id for this track received from the radio.getPlaylist service,
  /// if scrobbling Last.fm radio.
  String streamId;

  /// If the user chose this song, set on True,
  /// else (if the song was chosen by someone else, such as a radio station
  /// or recommendation service) set it to False.
  bool chosenByUser;

  /// MusicBrainz ID.
  String mbid;

  Scrobble({
    @required this.track,
    this.album,
    @required this.artist,
    this.trackNumber,
    this.duration,
    @required this.timeStamp,
    this.context,
    this.streamId,
    this.chosenByUser,
    this.mbid,
  });
}

// THE RESPONSE
// <?xml version="1.0" encoding="UTF-8"?>
// <lfm status="ok">
// <scrobbles ignored="0" accepted="1">
// <scrobble>
// <track corrected="0">Sunlight</track>
// <artist corrected="0">PLEEG</artist>
// <album corrected="0" />
// <albumArtist corrected="0"></albumArtist>
// <timestamp>1586879501</timestamp>
// <ignoredMessage code="0"></ignoredMessage>
// </scrobble>
// </scrobbles>
// </lfm>
