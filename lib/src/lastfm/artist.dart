//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// This object represents an artist.
@JsonSerializable(includeIfNull: false)
class Artist {
  /// Name of the artist.
  @JsonKey(name: 'name')
  String name;

  /// LastFM url of the artist.
  @JsonKey(name: 'url')
  String url;

  /// A list of different size of the artist cover.
  @JsonKey(name: 'image')
  List<Image> images;

  /// A list of tags assigned to the artist..
  @JsonKey(name: 'tags', fromJson: LastFMValueNormalizer.tagsExtractor)
  List<Tag> tags;

  /// Number of tags onto the artist.
  @JsonKey(name: 'tagcount', fromJson: LastFMValueNormalizer.NumberToInt)
  int tagCount;

  /// The artist stats if a user is given.
  @JsonKey(name: 'stats')
  Stats stats;

  /// The artist bio.
  @JsonKey(name: 'bio')
  Bio bio;

  /// A list of similar artists.
  @JsonKey(
      name: 'similar', fromJson: LastFMValueNormalizer.similarArtistsExtractor)
  List<Artist> similarArtists;

  // TODO: Match meaning.
  @JsonKey(name: 'match')
  String match;

  /// True if the Artist is streamable.
  @JsonKey(
      name: 'streamable', fromJson: LastFMValueNormalizer.isArtistStreamable)
  bool isStreamable;

  /// The number of listeners.
  @JsonKey(name: 'listeners', fromJson: LastFMValueNormalizer.NumberToInt)
  int listeners;

  /// The number of plays of the artist.
  @JsonKey(name: 'playcount', fromJson: LastFMValueNormalizer.NumberToInt)
  int playCount;

  /// Information about ongoing Tours.
  @JsonKey(name: 'ontour', fromJson: LastFMValueNormalizer.NumberToBool)
  bool onTour;

  /// MusicBrainz ID.
  @JsonKey(name: 'mbid')
  String mbid;

  Artist({
    this.name,
    this.url,
    this.images,
    this.tags,
    this.tagCount,
    this.stats,
    this.bio,
    this.similarArtists,
    this.match,
    this.isStreamable,
    this.listeners,
    this.playCount,
    this.onTour,
    this.mbid,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistToJson(this);
}
