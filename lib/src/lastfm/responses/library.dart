part of lastfm_objects;

/// This object represents a response about an artist library from a search.
@JsonSerializable(includeIfNull: false)
class LibraryGetArtistsResponse {
  /// A list of artists.
  @JsonKey(name: 'artist')
  List<Artist>? artist;

  /// The attributes related to the response.
  @JsonKey(name: '@attr')
  Attr? attr;

  LibraryGetArtistsResponse({this.artist, this.attr});

  factory LibraryGetArtistsResponse.fromJson(Map<String, dynamic> json) =>
      _$LibraryGetArtistsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryGetArtistsResponseToJson(this);
}
