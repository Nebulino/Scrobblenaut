//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// This object represents an image.
@JsonSerializable(includeIfNull: false)
class Image {
  /// This is the size of the image.
  /// Check [Size] for more info.
  @JsonKey(
      name: 'size',
      defaultValue: null,
      disallowNullValue: false,
      unknownEnumValue: Size.None)
  Size? size;

  // TODO: change the name?
  /// The link of the image.
  @JsonKey(name: '#text')
  String? text;

  Image({
    this.size,
    this.text,
  });

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
