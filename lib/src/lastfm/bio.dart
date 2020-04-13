/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of lastfm_objects;

/// This object represents a bio.
@JsonSerializable(includeIfNull: false)
class Bio {
  // TODO: what's this?
  /// A list of links.
  @JsonKey(name: 'links')
  List<Link> links;

  // TODO: is int?
  // TODO: what's this?
  @JsonKey(name: 'published', fromJson: LastFMValueNormalizer.NumberToInt)
  int published;

  /// A brief summary of the bio.
  @JsonKey(name: 'summary')
  String summary;

  /// The real content of the bio.
  @JsonKey(name: 'content')
  String content;

  Bio({
    this.links,
    this.published,
    this.summary,
    this.content,
  });

  factory Bio.fromJson(Map<String, dynamic> json) => _$BioFromJson(json);

  Map<String, dynamic> toJson() => _$BioToJson(this);
}
