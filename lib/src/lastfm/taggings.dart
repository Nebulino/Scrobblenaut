//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// This object represents different type of applied tags in taggable objects.
@JsonSerializable(includeIfNull: false)
class Taggings {
  /// A list of tagged albums.
  @JsonKey(name: 'albums', fromJson: LastFMValueNormalizer.albumsExtractor)
  List<Album>? albums;

  /// A list of tagged artists.
  @JsonKey(name: 'artists', fromJson: LastFMValueNormalizer.artistsExtractor)
  List<Artist>? artists;

  /// A list of tagged tracks.
  @JsonKey(name: 'tracks', fromJson: LastFMValueNormalizer.tracksExtractor)
  List<Track>? tracks;

  Taggings({
    this.albums,
    this.artists,
    this.tracks,
  });

  factory Taggings.fromJson(Map<String, dynamic> json) =>
      _$TaggingsFromJson(json);

  Map<String, dynamic> toJson() => _$TaggingsToJson(this);
}
