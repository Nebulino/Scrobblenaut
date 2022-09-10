//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// This object represents a link.
@JsonSerializable(includeIfNull: false)
class Link {
  // TODO: change the name?
  /// The link of the image.
  @JsonKey(name: '#text')
  String? text;

  // TODO: What's this? Original?
  @JsonKey(name: 'rel')
  String? rel;

  /// This is the web link of the LastFM url.
  @JsonKey(name: 'href')
  String? webLink;

  Link({
    this.text,
    this.rel,
    this.webLink,
  });

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);

  Map<String, dynamic> toJson() => _$LinkToJson(this);
}
