/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of lastfm_objects;

/// This object represents a track.
@JsonSerializable(includeIfNull: false)
class Track {
  /// Name of the track.
  @JsonKey(name: 'name')
  String name;

  /// The album that contains the track.
  @JsonKey(name: 'album')
  Album album;

  /// The artist that has created the track.
  @JsonKey(name: 'artist', fromJson: LastFMValueNormalizer.ArtistParser)
  Artist artist;

  // LastFM url of the track.
  @JsonKey(name: 'url')
  String url;

  /// The duration of the track.
  @JsonKey(
      name: 'duration',
      fromJson: LastFMValueNormalizer.MillisecondsDurationParser)
  Duration duration;

  /// A list of different size of the track cover.
  @JsonKey(name: 'image')
  List<Image> images;

  /// A list of Top Tags of the track.
  @JsonKey(name: 'toptags')
  List<Tag> topTags;

  // TODO: make it directly a Dart object?
  /// The date of publishing of the track.
  @JsonKey(name: 'date')
  Date date;

  // TODO: what's this for real?
  /// Streamable object of the track.
  @JsonKey(name: 'streamable', fromJson: LastFMValueNormalizer.StreamableParser)
  Streamable streamable;

  /// The number of listeners of the track.
  @JsonKey(
    name: 'listeners',
    fromJson: LastFMValueNormalizer.NumberToInt,
  )
  int listeners;

  /// The number of plays of the track.
  @JsonKey(name: 'playcount', fromJson: LastFMValueNormalizer.NumberToInt)
  int playCount;

  /// The wiki of the track.
  @JsonKey(name: 'wiki')
  Wiki wiki;

  /// MusicBrainz ID.
  @JsonKey(name: 'mbid')
  String mbid;

  Track({
    this.name,
    this.album,
    this.artist,
    this.url,
    this.duration,
    this.images,
    this.topTags,
    this.date,
    this.streamable,
    this.listeners,
    this.playCount,
    this.wiki,
    this.mbid,
  });

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  Map<String, dynamic> toJson() => _$TrackToJson(this);
}
