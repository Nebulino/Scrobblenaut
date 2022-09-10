//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //
part of lastfm_objects;

/// This object represents a wiki.
@JsonSerializable(includeIfNull: false)
class Wiki {
  // TODO: is this a date?
  /// The publication information of the wiki.
  @JsonKey(name: 'published')
  String? published;

  /// A brief summary of the wiki.
  @JsonKey(name: 'summary')
  String? summary;

  /// The real content of the wiki.
  @JsonKey(name: 'content')
  String? content;

  Wiki({
    this.published,
    this.summary,
    this.content,
  });

  factory Wiki.fromJson(Map<String, dynamic> json) => _$WikiFromJson(json);

  Map<String, dynamic> toJson() => _$WikiToJson(this);
}
