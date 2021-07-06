//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// This object represents a Registration, which contains a date ad a text.
/// TODO: is this useful or it can be just a DateTime?
@JsonSerializable(includeIfNull: false)
class Registered {
  /// The DateTime of the registration.
  @JsonKey(
      name: 'unixtime',
      fromJson: LastFMValueNormalizer.DateTimeFromUnixTime,
      toJson: LastFMValueNormalizer.DateTimeToUnixTime)
  DateTime? unixTime;

  // TODO: what's this? is this necessary?
  @JsonKey(name: '#text', fromJson: LastFMValueNormalizer.MeaninglessNumber)
  String? text;

  Registered({
    this.unixTime,
    this.text,
  });

  factory Registered.fromJson(Map<String, dynamic> json) =>
      _$RegisteredFromJson(json);

  Map<String, dynamic> toJson() => _$RegisteredToJson(this);
}
