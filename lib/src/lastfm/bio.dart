//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// This object represents a bio.
@JsonSerializable(includeIfNull: false)
class Bio {
  /// A list of links.
  @JsonKey(name: 'links', fromJson: LastFMValueNormalizer.linksExtractor)
  List<Link>? links;

  /// A string that indicates the date of publishing.
  /// **NOTE:** it's a string and it can't be transformed into a Dart DateTime.
  /// Because it's different between different bio.
  @JsonKey(name: 'published')
  String? published;

  /// A brief summary of the bio.
  @JsonKey(name: 'summary')
  String? summary;

  /// The real content of the bio.
  @JsonKey(name: 'content')
  String? content;

  Bio({
    this.links,
    this.published,
    this.summary,
    this.content,
  });

  factory Bio.fromJson(Map<String, dynamic> json) => _$BioFromJson(json);

  Map<String, dynamic> toJson() => _$BioToJson(this);
}
