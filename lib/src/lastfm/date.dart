//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// This object represents a date.
/// TODO: need to check if it's useful.
@JsonSerializable(includeIfNull: false)
class Date {
  // TODO: needs to be transformed? or just delete and make Date a DateTime?
  /// Unix date in string.
  @JsonKey(name: 'uts')
  String? unixDate;

  // TODO: What's this? it's necessary?
  @JsonKey(name: '#text')
  String? text;

  Date({
    this.unixDate,
    this.text,
  });

  factory Date.fromJson(Map<String, dynamic> json) => _$DateFromJson(json);

  Map<String, dynamic> toJson() => _$DateToJson(this);
}
