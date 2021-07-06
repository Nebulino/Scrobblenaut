part of lastfm_objects;

/// This is a object that helps scrobbling multiple tracks.
@JsonSerializable(includeIfNull: false)
class Attr {
  @JsonKey(name: 'page', fromJson: LastFMValueNormalizer.NumberToInt)
  int? page;

  @JsonKey(name: 'perPage', fromJson: LastFMValueNormalizer.NumberToInt)
  int? perPage;

  String? user;

  @JsonKey(name: 'total', fromJson: LastFMValueNormalizer.NumberToInt)
  int? total;

  @JsonKey(name: 'totalPages', fromJson: LastFMValueNormalizer.NumberToInt)
  int? totalPages;

  Attr({this.page, this.perPage, this.user, this.total, this.totalPages});

  factory Attr.fromJson(Map<String, dynamic> json) => _$AttrFromJson(json);

  Map<String, dynamic> toJson() => _$AttrToJson(this);
}
