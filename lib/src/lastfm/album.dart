/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of lastfm_objects;

/// This object represents an album.
@JsonSerializable(includeIfNull: false)
class Album {
  /// Title of the album.
  @JsonKey(name: 'title')
  String title;

  // TODO: what's this?
  /// Name of the album.
  @JsonKey(name: 'name')
  String name;

  /// Artist of the album.
  @JsonKey(name: 'artist', fromJson: LastFMValueNormalizer.ArtistParser)
  Artist artist;

  /// LastFM url of the album.
  @JsonKey(name: 'url')
  String url;

  /// A list of different size of the album cover.
  @JsonKey(name: 'image')
  List<Image> images;

  /// A list of tracks of the album.
  @JsonKey(name: 'tracks', fromJson: LastFMValueNormalizer.tracksExtractor)
  List<Track> tracks;

  /// A list of tags assigned to the album.
  @JsonKey(name: 'tags', fromJson: LastFMValueNormalizer.tagsExtractor)
  List<Tag> tags;

  /// The number of listeners of the album.
  @JsonKey(name: 'listeners', fromJson: LastFMValueNormalizer.NumberToInt)
  int listeners; // Last.FM treats this as String

  /// The number of plays of the album.
  @JsonKey(name: 'playcount', fromJson: LastFMValueNormalizer.NumberToInt)
  int playCount; // Last.FM treats this as String

  /// MusicBrainz ID.
  @JsonKey(name: 'mbid')
  String mbid;

  Album({
    this.title,
    this.name,
    this.artist,
    this.url,
    this.images,
    this.tracks,
    this.tags,
    this.listeners,
    this.playCount,
    this.mbid,
  });

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}
