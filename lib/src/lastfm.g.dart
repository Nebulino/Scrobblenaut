// GENERATED CODE - DO NOT MODIFY BY HAND

part of lastfm_objects;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NowPlaying _$NowPlayingFromJson(Map<String, dynamic> json) {
  return NowPlaying(
    track: json['track'] as String,
    album: json['album'] as String?,
    artist: json['artist'] as String,
    trackNumber: json['trackNumber'] as int?,
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
    context: json['context'] as String?,
    mbid: json['mbid'] as String?,
    albumArtist: json['albumArtist'] as String?,
  );
}

Map<String, dynamic> _$NowPlayingToJson(NowPlaying instance) {
  final val = <String, dynamic>{
    'artist': instance.artist,
    'track': instance.track,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('album', instance.album);
  writeNotNull('trackNumber', instance.trackNumber);
  writeNotNull('context', instance.context);
  writeNotNull('mbid', instance.mbid);
  writeNotNull('duration',
      LastFMValueNormalizer.DurationToMilliseconds(instance.duration));
  writeNotNull('albumArtist', instance.albumArtist);
  return val;
}

Scrobble _$ScrobbleFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['artist', 'track']);
  return Scrobble(
    track: json['track'] as String,
    album: json['album'] as String?,
    artist: json['artist'] as String,
    trackNumber: json['trackNumber'] as int?,
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
    timestamp: json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
    context: json['context'] as String?,
    streamId: json['streamId'] as String?,
    chosenByUser: json['chosenByUser'] as bool?,
    mbid: json['mbid'] as String?,
  );
}

Map<String, dynamic> _$ScrobbleToJson(Scrobble instance) {
  final val = <String, dynamic>{
    'artist': instance.artist,
    'track': instance.track,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('timestamp',
      LastFMValueNormalizer.DateTimeToUnixTime(instance.timestamp));
  writeNotNull('album', instance.album);
  writeNotNull('context', instance.context);
  writeNotNull('streamId', instance.streamId);
  writeNotNull('chosenByUser',
      LastFMValueNormalizer.BoolToIntBool(instance.chosenByUser));
  writeNotNull('trackNumber', instance.trackNumber);
  writeNotNull('mbid', instance.mbid);
  writeNotNull('duration',
      LastFMValueNormalizer.DurationToMilliseconds(instance.duration));
  return val;
}

Session _$SessionFromJson(Map<String, dynamic> json) {
  return Session(
    name: json['name'] as String?,
    sessionKey: json['key'] as String?,
    subscriber: json['subscriber'] as int?,
  );
}

Map<String, dynamic> _$SessionToJson(Session instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('key', instance.sessionKey);
  writeNotNull('subscriber', instance.subscriber);
  return val;
}

Attr _$AttrFromJson(Map<String, dynamic> json) {
  return Attr(
    page: LastFMValueNormalizer.NumberToInt(json['page']),
    perPage: LastFMValueNormalizer.NumberToInt(json['perPage']),
    user: json['user'] as String?,
    total: LastFMValueNormalizer.NumberToInt(json['total']),
    totalPages: LastFMValueNormalizer.NumberToInt(json['totalPages']),
  );
}

Map<String, dynamic> _$AttrToJson(Attr instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('page', instance.page);
  writeNotNull('perPage', instance.perPage);
  writeNotNull('user', instance.user);
  writeNotNull('total', instance.total);
  writeNotNull('totalPages', instance.totalPages);
  return val;
}

Album _$AlbumFromJson(Map<String, dynamic> json) {
  return Album(
    title: json['title'] as String?,
    name: json['name'] as String?,
    artist: LastFMValueNormalizer.ArtistParser(json['artist']),
    url: json['url'] as String?,
    images: (json['image'] as List<dynamic>?)
        ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
        .toList(),
    tracks: LastFMValueNormalizer.tracksExtractor(
        json['tracks'] as Map<String, dynamic>?),
    tags: LastFMValueNormalizer.tagsExtractor(
        json['tags'] as Map<String, dynamic>?),
    listeners: LastFMValueNormalizer.NumberToInt(json['listeners']),
    playCount: LastFMValueNormalizer.NumberToInt(json['playcount']),
    mbid: json['mbid'] as String?,
  );
}

Map<String, dynamic> _$AlbumToJson(Album instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('name', instance.name);
  writeNotNull('artist', instance.artist);
  writeNotNull('url', instance.url);
  writeNotNull('image', instance.images);
  writeNotNull('tracks', instance.tracks);
  writeNotNull('tags', instance.tags);
  writeNotNull('listeners', instance.listeners);
  writeNotNull('playcount', instance.playCount);
  writeNotNull('mbid', instance.mbid);
  return val;
}

AlbumSearchResults _$AlbumSearchResultsFromJson(Map<String, dynamic> json) {
  return AlbumSearchResults(
    albums: LastFMValueNormalizer.albumsExtractor(
        json['albummatches'] as Map<String, dynamic>?),
    totalResults:
        LastFMValueNormalizer.NumberToInt(json['opensearch:TotalResults']),
    statingIndex:
        LastFMValueNormalizer.NumberToInt(json['opensearch:StartIndex']),
    itemsPerPage:
        LastFMValueNormalizer.NumberToInt(json['opensearch:ItemsPerPage']),
  );
}

Map<String, dynamic> _$AlbumSearchResultsToJson(AlbumSearchResults instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('albummatches', instance.albums);
  writeNotNull('opensearch:TotalResults', instance.totalResults);
  writeNotNull('opensearch:StartIndex', instance.statingIndex);
  writeNotNull('opensearch:ItemsPerPage', instance.itemsPerPage);
  return val;
}

Artist _$ArtistFromJson(Map<String, dynamic> json) {
  return Artist(
    name: json['name'] as String?,
    url: json['url'] as String?,
    images: (json['image'] as List<dynamic>?)
        ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
        .toList(),
    tags: LastFMValueNormalizer.tagsExtractor(
        json['tags'] as Map<String, dynamic>?),
    tagCount: LastFMValueNormalizer.NumberToInt(json['tagcount']),
    stats: json['stats'] == null
        ? null
        : Stats.fromJson(json['stats'] as Map<String, dynamic>),
    bio: json['bio'] == null
        ? null
        : Bio.fromJson(json['bio'] as Map<String, dynamic>),
    similarArtists: LastFMValueNormalizer.similarArtistsExtractor(
        json['similar'] as Map<String, dynamic>?),
    match: json['match'] as String?,
    isStreamable: LastFMValueNormalizer.isArtistStreamable(json['streamable']),
    listeners: LastFMValueNormalizer.NumberToInt(json['listeners']),
    playCount: LastFMValueNormalizer.NumberToInt(json['playcount']),
    onTour: LastFMValueNormalizer.NumberToBool(json['ontour']),
    mbid: json['mbid'] as String?,
  );
}

Map<String, dynamic> _$ArtistToJson(Artist instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('url', instance.url);
  writeNotNull('image', instance.images);
  writeNotNull('tags', instance.tags);
  writeNotNull('tagcount', instance.tagCount);
  writeNotNull('stats', instance.stats);
  writeNotNull('bio', instance.bio);
  writeNotNull('similar', instance.similarArtists);
  writeNotNull('match', instance.match);
  writeNotNull('streamable', instance.isStreamable);
  writeNotNull('listeners', instance.listeners);
  writeNotNull('playcount', instance.playCount);
  writeNotNull('ontour', instance.onTour);
  writeNotNull('mbid', instance.mbid);
  return val;
}

ArtistSearchResults _$ArtistSearchResultsFromJson(Map<String, dynamic> json) {
  return ArtistSearchResults(
    artists: LastFMValueNormalizer.artistsExtractor(
        json['artistmatches'] as Map<String, dynamic>?),
    totalResults:
        LastFMValueNormalizer.NumberToInt(json['opensearch:TotalResults']),
    statingIndex:
        LastFMValueNormalizer.NumberToInt(json['opensearch:StartIndex']),
    itemsPerPage:
        LastFMValueNormalizer.NumberToInt(json['opensearch:ItemsPerPage']),
  );
}

Map<String, dynamic> _$ArtistSearchResultsToJson(ArtistSearchResults instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('artistmatches', instance.artists);
  writeNotNull('opensearch:TotalResults', instance.totalResults);
  writeNotNull('opensearch:StartIndex', instance.statingIndex);
  writeNotNull('opensearch:ItemsPerPage', instance.itemsPerPage);
  return val;
}

Bio _$BioFromJson(Map<String, dynamic> json) {
  return Bio(
    links: LastFMValueNormalizer.linksExtractor(
        json['links'] as Map<String, dynamic>?),
    published: json['published'] as String?,
    summary: json['summary'] as String?,
    content: json['content'] as String?,
  );
}

Map<String, dynamic> _$BioToJson(Bio instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('links', instance.links);
  writeNotNull('published', instance.published);
  writeNotNull('summary', instance.summary);
  writeNotNull('content', instance.content);
  return val;
}

Chart _$ChartFromJson(Map<String, dynamic> json) {
  return Chart(
    text: json['#text'] as String?,
    fromDate: LastFMValueNormalizer.DateTimeFromUnixTime(json['from']),
    toDate: LastFMValueNormalizer.DateTimeFromUnixTime(json['to']),
  );
}

Map<String, dynamic> _$ChartToJson(Chart instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('#text', instance.text);
  writeNotNull(
      'from', LastFMValueNormalizer.DateTimeToUnixTime(instance.fromDate));
  writeNotNull('to', LastFMValueNormalizer.DateTimeToUnixTime(instance.toDate));
  return val;
}

Date _$DateFromJson(Map<String, dynamic> json) {
  return Date(
    unixDate: json['uts'] as String?,
    text: json['#text'] as String?,
  );
}

Map<String, dynamic> _$DateToJson(Date instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('uts', instance.unixDate);
  writeNotNull('#text', instance.text);
  return val;
}

Image _$ImageFromJson(Map<String, dynamic> json) {
  return Image(
    size: _$enumDecodeNullable(_$SizeEnumMap, json['size'],
        unknownValue: Size.None),
    text: json['#text'] as String?,
  );
}

Map<String, dynamic> _$ImageToJson(Image instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('size', _$SizeEnumMap[instance.size]);
  writeNotNull('#text', instance.text);
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$SizeEnumMap = {
  Size.small: 'small',
  Size.medium: 'medium',
  Size.large: 'large',
  Size.extralarge: 'extralarge',
  Size.mega: 'mega',
  Size.empty: 'empty',
  Size.None: 'None',
};

Link _$LinkFromJson(Map<String, dynamic> json) {
  return Link(
    text: json['#text'] as String?,
    rel: json['rel'] as String?,
    webLink: json['href'] as String?,
  );
}

Map<String, dynamic> _$LinkToJson(Link instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('#text', instance.text);
  writeNotNull('rel', instance.rel);
  writeNotNull('href', instance.webLink);
  return val;
}

Registered _$RegisteredFromJson(Map<String, dynamic> json) {
  return Registered(
    unixTime: LastFMValueNormalizer.DateTimeFromUnixTime(json['unixtime']),
    text: LastFMValueNormalizer.MeaninglessNumber(json['#text']),
  );
}

Map<String, dynamic> _$RegisteredToJson(Registered instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'unixtime', LastFMValueNormalizer.DateTimeToUnixTime(instance.unixTime));
  writeNotNull('#text', instance.text);
  return val;
}

Stats _$StatsFromJson(Map<String, dynamic> json) {
  return Stats(
    listeners: LastFMValueNormalizer.NumberToInt(json['listeners']),
    playCount: LastFMValueNormalizer.NumberToInt(json['playcount']),
    userPlayCount: LastFMValueNormalizer.NumberToInt(json['userplaycount']),
  );
}

Map<String, dynamic> _$StatsToJson(Stats instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('listeners', instance.listeners);
  writeNotNull('playcount', instance.playCount);
  writeNotNull('userplaycount', instance.userPlayCount);
  return val;
}

Streamable _$StreamableFromJson(Map<String, dynamic> json) {
  return Streamable(
    text: json['#text'] as String?,
    fullTrack: json['fulltrack'] as String?,
  );
}

Map<String, dynamic> _$StreamableToJson(Streamable instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('#text', instance.text);
  writeNotNull('fulltrack', instance.fullTrack);
  return val;
}

Tag _$TagFromJson(Map<String, dynamic> json) {
  return Tag(
    name: json['name'] as String,
    url: json['url'] as String?,
    count: LastFMValueNormalizer.NumberToInt(json['count']),
    total: LastFMValueNormalizer.NumberToInt(json['total']),
    reach: LastFMValueNormalizer.NumberToInt(json['reach']),
    taggings: LastFMValueNormalizer.NumberToInt(json['taggings']),
    streamable: LastFMValueNormalizer.NumberToBool(json['streamable']),
    wiki: json['wiki'] == null
        ? null
        : Wiki.fromJson(json['wiki'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TagToJson(Tag instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('url', instance.url);
  writeNotNull('count', instance.count);
  writeNotNull('total', instance.total);
  writeNotNull('reach', instance.reach);
  writeNotNull('taggings', instance.taggings);
  writeNotNull('streamable', instance.streamable);
  writeNotNull('wiki', instance.wiki);
  return val;
}

Taggings _$TaggingsFromJson(Map<String, dynamic> json) {
  return Taggings(
    albums: LastFMValueNormalizer.albumsExtractor(
        json['albums'] as Map<String, dynamic>?),
    artists: LastFMValueNormalizer.artistsExtractor(
        json['artists'] as Map<String, dynamic>?),
    tracks: LastFMValueNormalizer.tracksExtractor(
        json['tracks'] as Map<String, dynamic>?),
  );
}

Map<String, dynamic> _$TaggingsToJson(Taggings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('albums', instance.albums);
  writeNotNull('artists', instance.artists);
  writeNotNull('tracks', instance.tracks);
  return val;
}

Track _$TrackFromJson(Map<String, dynamic> json) {
  return Track(
    name: json['name'] as String,
    album: json['album'] == null
        ? null
        : Album.fromJson(json['album'] as Map<String, dynamic>),
    artist: LastFMValueNormalizer.ArtistParser(json['artist']),
    url: json['url'] as String?,
    duration:
        LastFMValueNormalizer.MillisecondsDurationParser(json['duration']),
    images: (json['image'] as List<dynamic>?)
        ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
        .toList(),
    topTags: LastFMValueNormalizer.tagsExtractor(
        json['toptags'] as Map<String, dynamic>?),
    date: json['date'] == null
        ? null
        : Date.fromJson(json['date'] as Map<String, dynamic>),
    streamable: LastFMValueNormalizer.StreamableParser(json['streamable']),
    listeners: LastFMValueNormalizer.NumberToInt(json['listeners']),
    playCount: LastFMValueNormalizer.NumberToInt(json['playcount']),
    wiki: json['wiki'] == null
        ? null
        : Wiki.fromJson(json['wiki'] as Map<String, dynamic>),
    mbid: json['mbid'] as String?,
    loved: LastFMValueNormalizer.NumberToBool(json['loved']),
  );
}

Map<String, dynamic> _$TrackToJson(Track instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('album', instance.album);
  writeNotNull('artist', instance.artist);
  writeNotNull('url', instance.url);
  writeNotNull('duration', instance.duration?.inMicroseconds);
  writeNotNull('image', instance.images);
  writeNotNull('toptags', instance.topTags);
  writeNotNull('date', instance.date);
  writeNotNull('streamable', instance.streamable);
  writeNotNull('listeners', instance.listeners);
  writeNotNull('playcount', instance.playCount);
  writeNotNull('wiki', instance.wiki);
  writeNotNull('mbid', instance.mbid);
  writeNotNull('loved', instance.loved);
  return val;
}

TrackSearchResults _$TrackSearchResultsFromJson(Map<String, dynamic> json) {
  return TrackSearchResults(
    tracks: LastFMValueNormalizer.tracksExtractor(
        json['trackmatches'] as Map<String, dynamic>?),
    totalResults:
        LastFMValueNormalizer.NumberToInt(json['opensearch:TotalResults']),
    statingIndex:
        LastFMValueNormalizer.NumberToInt(json['opensearch:StartIndex']),
    itemsPerPage:
        LastFMValueNormalizer.NumberToInt(json['opensearch:ItemsPerPage']),
  );
}

Map<String, dynamic> _$TrackSearchResultsToJson(TrackSearchResults instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('trackmatches', instance.tracks);
  writeNotNull('opensearch:TotalResults', instance.totalResults);
  writeNotNull('opensearch:StartIndex', instance.statingIndex);
  writeNotNull('opensearch:ItemsPerPage', instance.itemsPerPage);
  return val;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    name: json['name'] as String,
    realName: json['realname'] as String?,
    gender: json['gender'] as String?,
    age: json['age'] as String?,
    country: json['country'] as String?,
    url: json['url'] as String?,
    image: (json['image'] as List<dynamic>?)
        ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
        .toList(),
    subscriber: LastFMValueNormalizer.NumberToBool(json['subscriber']),
    playlists: LastFMValueNormalizer.NumberToInt(json['playlists']),
    playCount: LastFMValueNormalizer.NumberToInt(json['playcount']),
    registered: json['registered'] == null
        ? null
        : Registered.fromJson(json['registered'] as Map<String, dynamic>),
    bootstrap: json['bootstrap'] as String?,
    type: json['type'] as String?,
  );
}

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('realname', instance.realName);
  writeNotNull('gender', instance.gender);
  writeNotNull('age', instance.age);
  writeNotNull('country', instance.country);
  writeNotNull('url', instance.url);
  writeNotNull('image', instance.image);
  writeNotNull('subscriber', instance.subscriber);
  writeNotNull('playlists', instance.playlists);
  writeNotNull('playcount', instance.playCount);
  writeNotNull('registered', instance.registered);
  writeNotNull('bootstrap', instance.bootstrap);
  writeNotNull('type', instance.type);
  return val;
}

Wiki _$WikiFromJson(Map<String, dynamic> json) {
  return Wiki(
    published: json['published'] as String?,
    summary: json['summary'] as String?,
    content: json['content'] as String?,
  );
}

Map<String, dynamic> _$WikiToJson(Wiki instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('published', instance.published);
  writeNotNull('summary', instance.summary);
  writeNotNull('content', instance.content);
  return val;
}

LibraryGetArtistsResponse _$LibraryGetArtistsResponseFromJson(
    Map<String, dynamic> json) {
  return LibraryGetArtistsResponse(
    artist: (json['artist'] as List<dynamic>?)
        ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
        .toList(),
    attr: json['@attr'] == null
        ? null
        : Attr.fromJson(json['@attr'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LibraryGetArtistsResponseToJson(
    LibraryGetArtistsResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('artist', instance.artist);
  writeNotNull('@attr', instance.attr);
  return val;
}
