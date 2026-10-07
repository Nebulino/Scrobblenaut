//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of '../../lastfm.dart';

/// Tagging type for [User.getPersonalTags].
enum TaggingType { artist, album, track }

extension TaggingTypeExtension on TaggingType {
  String get type => name;
}
