//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// This is a Session for Last FM.
@JsonSerializable(includeIfNull: false)
class Session {
  /// Name of the session. It contains the user name most of the time.
  @JsonKey(name: 'name')
  String? name;

  /// This is the key of a LastFM session.
  @JsonKey(name: 'key')
  String? sessionKey;

  /// This gives the subscriber number.
  @JsonKey(name: 'subscriber')
  int? subscriber;

  Session({
    this.name,
    this.sessionKey,
    this.subscriber,
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
