part of lastfm_objects;

@JsonSerializable(includeIfNull: false)
class LibraryGetArtistsResponse {
  @JsonKey(name: 'artist')
  List<Artist>? artist;

  @JsonKey(name: '@attr')
  Attr? attr;

  LibraryGetArtistsResponse({this.artist, this.attr});

  factory LibraryGetArtistsResponse.fromJson(Map<String, dynamic> json) =>
      _$LibraryGetArtistsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryGetArtistsResponseToJson(this);
}
