/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of lastfm_objects;

/// This object represents a tag.
@JsonSerializable(includeIfNull: false)
class Tag {
  /// The tag name.
  @JsonKey(name: 'name')
  String name;

  // LastFM url of the tag.
  @JsonKey(name: 'url')
  String url;

  /// The usage number of the tag.
  @JsonKey(name: 'count')
  int count;

  // TODO: what's this?
  /// The total number of usage of this tag.
  @JsonKey(name: 'total', fromJson: LastFMValueNormalizer.NumberToInt)
  int total;

  // TODO: what's this?
  @JsonKey(name: 'reach', fromJson: LastFMValueNormalizer.NumberToInt)
  int reach;

  // TODO: what's this?
  /// The number of usage applied from a user.
  @JsonKey(name: 'taggings', fromJson: LastFMValueNormalizer.NumberToInt)
  int taggings;

  // TODO: another incoherency? is bool? 1 / 0
  @JsonKey(name: 'streamable')
  String streamable;

  /// The wiki of the tag.
  @JsonKey(name: 'wiki')
  Wiki wiki;

  Tag({
    this.name,
    this.url,
    this.count,
    this.total,
    this.reach,
    this.taggings,
    this.streamable,
    this.wiki,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
