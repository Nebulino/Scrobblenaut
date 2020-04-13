/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of lastfm_objects;

/// This object represents a streamable object.
@JsonSerializable(includeIfNull: false)
class Streamable {
  // TODO: what's this?
  @JsonKey(name: '#text')
  String text;

  // TODO: what's this?
  @JsonKey(name: 'fulltrack')
  String fullTrack;

  Streamable({
    this.text,
    this.fullTrack,
  });

  @JsonSerializable(includeIfNull: false)
  factory Streamable.fromJson(Map<String, dynamic> json) =>
      _$StreamableFromJson(json);

  Map<String, dynamic> toJson() => _$StreamableToJson(this);
}
