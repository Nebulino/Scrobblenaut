/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of lastfm_objects;

/// This object represents a user.
@JsonSerializable(includeIfNull: false)
class User {
  /// The name of the user.
  @JsonKey(name: 'name')
  String name;

  /// The real name of the user.
  @JsonKey(name: 'realname')
  String realName;

  /// THe user's gender.
  @JsonKey(name: 'gender')
  String gender;

  /// The age of the user.
  @JsonKey(name: 'age')
  String age;

  /// The user's country.
  @JsonKey(name: 'country')
  String country;

  // LastFM url of the user.
  @JsonKey(name: 'url')
  String url;

  /// A list of different size of the user profile picture.
  @JsonKey(name: 'image')
  List<Image> image;

  // The number of subscriber of the user.
  @JsonKey(name: 'subscriber', fromJson: LastFMValueNormalizer.NumberToInt)
  int subscriber;

  // The number of playlist of the user.
  @JsonKey(name: 'playlists', fromJson: LastFMValueNormalizer.NumberToInt)
  int playlists;

  /// The play count of the user.
  @JsonKey(name: 'playcount', fromJson: LastFMValueNormalizer.NumberToInt)
  int playCount;

  /// The registration information of the user.
  @JsonKey(name: 'registered')
  Registered registered;

  // TODO: what's this?
  @JsonKey(name: 'bootstrap')
  String bootstrap;

  /// The type of the user.
  @JsonKey(name: 'type')
  String type;

  User({
    this.name,
    this.realName,
    this.gender,
    this.age,
    this.country,
    this.url,
    this.image,
    this.subscriber,
    this.playlists,
    this.playCount,
    this.registered,
    this.bootstrap,
    this.type,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
