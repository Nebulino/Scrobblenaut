//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// This is a object that helps scrobbling multiple tracks.
@JsonSerializable(includeIfNull: false)
class NowPlaying {
  /// The [Artist] name to scrobble.
  @JsonKey(name: 'artist')
  String artist;

  /// The [Track] title to scrobble.
  @JsonKey(name: 'track')
  String track;

  /// The [Album] name to scrobble.
  @JsonKey(name: 'album')
  String? album;

  /// The track number of the [Track] to scrobble.
  @JsonKey(name: 'trackNumber')
  int? trackNumber;

  /// Sub-client version (not public, only enabled for certain API keys).
  @JsonKey(name: 'context')
  String? context;

  /// MusicBrainz ID.
  @JsonKey(name: 'mbid')
  String? mbid;

  /// The duration of the [Track] to scrobble.
  @JsonKey(
      name: 'duration', toJson: LastFMValueNormalizer.DurationToMilliseconds)
  Duration? duration;

  /// The album artist - if this differs from the track artist.
  @JsonKey(name: 'albumArtist')
  String? albumArtist;

  NowPlaying({
    required this.track,
    this.album,
    required this.artist,
    this.trackNumber,
    this.duration,
    this.context,
    this.mbid,
    this.albumArtist,
  });

  factory NowPlaying.fromJson(Map<String, dynamic> json) =>
      _$NowPlayingFromJson(json);

  Map<String, dynamic> toJson() => _$NowPlayingToJson(this);
}
