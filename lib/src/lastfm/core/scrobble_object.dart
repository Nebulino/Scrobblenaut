//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// This is a object that helps scrobbling multiple tracks.
@JsonSerializable(includeIfNull: false)
class Scrobble {
  /// The [Artist] name to scrobble.
  @JsonKey(name: 'artist', required: true)
  String artist;

  /// The [Track] title to scrobble.
  @JsonKey(name: 'track', required: true)
  String track;

  /// The TimeStamp of the scrobble.
  /// If You're not doing strange stuff, you can use DateTime.now().
  @JsonKey(name: 'timestamp', toJson: LastFMValueNormalizer.DateTimeToUnixTime)
  DateTime timestamp;

  /// The [Album] name to scrobble.
  @JsonKey(name: 'album')
  String? album;

  /// Sub-client version (not public, only enabled for certain API keys).
  @JsonKey(name: 'context')
  String? context;

  /// The stream id for this track received from the radio.getPlaylist service,
  /// if scrobbling Last.fm radio.
  @JsonKey(name: 'streamId')
  String? streamId;

  /// If the user chose this song, set on True,
  /// else (if the song was chosen by someone else, such as a radio station
  /// or recommendation service) set it to False.
  @JsonKey(name: 'chosenByUser', toJson: LastFMValueNormalizer.BoolToIntBool)
  bool? chosenByUser;

  /// The track number of the [Track] to scrobble.
  @JsonKey(name: 'trackNumber')
  int? trackNumber;

  /// MusicBrainz ID.
  @JsonKey(name: 'mbid')
  String? mbid;

  /// The duration of the [Track] to scrobble.
  @JsonKey(
      name: 'duration', toJson: LastFMValueNormalizer.DurationToMilliseconds)
  Duration? duration;

  Scrobble({
    required this.track,
    this.album,
    required this.artist,
    this.trackNumber,
    this.duration,
    DateTime? timestamp,
    this.context,
    this.streamId,
    this.chosenByUser,
    this.mbid,
  }) : timestamp = timestamp ?? DateTime.now();

  factory Scrobble.fromJson(Map<String, dynamic> json) =>
      _$ScrobbleFromJson(json);

  Map<String, dynamic> toJson() => _$ScrobbleToJson(this);
}
