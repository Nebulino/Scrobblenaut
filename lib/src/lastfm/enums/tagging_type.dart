/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of lastfm_objects;

/// Tagging type for [User.getPersonalTags].
enum TaggingType {
  artist,
  album,
  track,
  None,
}

extension TaggingTypeExtension on TaggingType {
  String get type {
    switch (this) {
      case TaggingType.artist:
        return 'artist';
      case TaggingType.album:
        return 'album';
      case TaggingType.track:
        return 'track';
      default:
        return null;
    }
  }
}
