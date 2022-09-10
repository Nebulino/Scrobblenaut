//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// This is a object that contains information about the response.
@JsonSerializable(includeIfNull: false)
class Attr {
  /// The page of the response.
  @JsonKey(name: 'page', fromJson: LastFMValueNormalizer.NumberToInt)
  int? page;

  /// The number of items per page.
  @JsonKey(name: 'perPage', fromJson: LastFMValueNormalizer.NumberToInt)
  int? perPage;

  /// The user that requested the response.
  String? user;

  /// The total number of items.
  @JsonKey(name: 'total', fromJson: LastFMValueNormalizer.NumberToInt)
  int? total;

  /// The number of pages.
  @JsonKey(name: 'totalPages', fromJson: LastFMValueNormalizer.NumberToInt)
  int? totalPages;

  Attr({this.page, this.perPage, this.user, this.total, this.totalPages});

  factory Attr.fromJson(Map<String, dynamic> json) => _$AttrFromJson(json);

  Map<String, dynamic> toJson() => _$AttrToJson(this);
}
