// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lastfm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NowPlaying _$NowPlayingFromJson(Map<String, dynamic> json) => NowPlaying(
  track: json['track'] as String,
  album: json['album'] as String?,
  artist: json['artist'] as String,
  trackNumber: (json['trackNumber'] as num?)?.toInt(),
  duration: json['duration'] == null
      ? null
      : Duration(microseconds: (json['duration'] as num).toInt()),
  context: json['context'] as String?,
  mbid: json['mbid'] as String?,
  albumArtist: json['albumArtist'] as String?,
);

Map<String, dynamic> _$NowPlayingToJson(
  NowPlaying instance,
) => <String, dynamic>{
  'artist': instance.artist,
  'track': instance.track,
  'album': ?instance.album,
  'trackNumber': ?instance.trackNumber,
  'context': ?instance.context,
  'mbid': ?instance.mbid,
  'duration': ?LastFMValueNormalizer.DurationToMilliseconds(instance.duration),
  'albumArtist': ?instance.albumArtist,
};

Scrobble _$ScrobbleFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['artist', 'track']);
  return Scrobble(
    track: json['track'] as String,
    album: json['album'] as String?,
    artist: json['artist'] as String,
    trackNumber: (json['trackNumber'] as num?)?.toInt(),
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: (json['duration'] as num).toInt()),
    timestamp: json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
    context: json['context'] as String?,
    streamId: json['streamId'] as String?,
    chosenByUser: json['chosenByUser'] as bool?,
    mbid: json['mbid'] as String?,
  );
}

Map<String, dynamic> _$ScrobbleToJson(Scrobble instance) => <String, dynamic>{
  'artist': instance.artist,
  'track': instance.track,
  'timestamp': ?LastFMValueNormalizer.DateTimeToUnixTime(instance.timestamp),
  'album': ?instance.album,
  'context': ?instance.context,
  'streamId': ?instance.streamId,
  'chosenByUser': ?LastFMValueNormalizer.BoolToIntBool(instance.chosenByUser),
  'trackNumber': ?instance.trackNumber,
  'mbid': ?instance.mbid,
  'duration': ?LastFMValueNormalizer.DurationToMilliseconds(instance.duration),
};

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
  name: json['name'] as String?,
  sessionKey: json['key'] as String?,
  subscriber: (json['subscriber'] as num?)?.toInt(),
);

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
  'name': ?instance.name,
  'key': ?instance.sessionKey,
  'subscriber': ?instance.subscriber,
};

Attr _$AttrFromJson(Map<String, dynamic> json) => Attr(
  page: LastFMValueNormalizer.NumberToInt(json['page']),
  perPage: LastFMValueNormalizer.NumberToInt(json['perPage']),
  user: json['user'] as String?,
  total: LastFMValueNormalizer.NumberToInt(json['total']),
  totalPages: LastFMValueNormalizer.NumberToInt(json['totalPages']),
);

Map<String, dynamic> _$AttrToJson(Attr instance) => <String, dynamic>{
  'page': ?instance.page,
  'perPage': ?instance.perPage,
  'user': ?instance.user,
  'total': ?instance.total,
  'totalPages': ?instance.totalPages,
};

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
  title: json['title'] as String?,
  name: json['name'] as String?,
  artist: LastFMValueNormalizer.ArtistParser(json['artist']),
  url: json['url'] as String?,
  images: (json['image'] as List<dynamic>?)
      ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
      .toList(),
  tracks: LastFMValueNormalizer.tracksExtractor(
    json['tracks'] as Map<String, dynamic>?,
  ),
  tags: LastFMValueNormalizer.tagsExtractor(
    json['tags'] as Map<String, dynamic>?,
  ),
  listeners: LastFMValueNormalizer.NumberToInt(json['listeners']),
  playCount: LastFMValueNormalizer.NumberToInt(json['playcount']),
  mbid: json['mbid'] as String?,
);

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
  'title': ?instance.title,
  'name': ?instance.name,
  'artist': ?instance.artist,
  'url': ?instance.url,
  'image': ?instance.images,
  'tracks': ?instance.tracks,
  'tags': ?instance.tags,
  'listeners': ?instance.listeners,
  'playcount': ?instance.playCount,
  'mbid': ?instance.mbid,
};

AlbumSearchResults _$AlbumSearchResultsFromJson(Map<String, dynamic> json) =>
    AlbumSearchResults(
      albums: LastFMValueNormalizer.albumsExtractor(
        json['albummatches'] as Map<String, dynamic>?,
      ),
      totalResults: LastFMValueNormalizer.NumberToInt(
        json['opensearch:TotalResults'],
      ),
      statingIndex: LastFMValueNormalizer.NumberToInt(
        json['opensearch:StartIndex'],
      ),
      itemsPerPage: LastFMValueNormalizer.NumberToInt(
        json['opensearch:ItemsPerPage'],
      ),
    );

Map<String, dynamic> _$AlbumSearchResultsToJson(AlbumSearchResults instance) =>
    <String, dynamic>{
      'albummatches': ?instance.albums,
      'opensearch:TotalResults': ?instance.totalResults,
      'opensearch:StartIndex': ?instance.statingIndex,
      'opensearch:ItemsPerPage': ?instance.itemsPerPage,
    };

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
  name: json['name'] as String?,
  url: json['url'] as String?,
  images: (json['image'] as List<dynamic>?)
      ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
      .toList(),
  tags: LastFMValueNormalizer.tagsExtractor(
    json['tags'] as Map<String, dynamic>?,
  ),
  tagCount: LastFMValueNormalizer.NumberToInt(json['tagcount']),
  stats: json['stats'] == null
      ? null
      : Stats.fromJson(json['stats'] as Map<String, dynamic>),
  bio: json['bio'] == null
      ? null
      : Bio.fromJson(json['bio'] as Map<String, dynamic>),
  similarArtists: LastFMValueNormalizer.similarArtistsExtractor(
    json['similar'] as Map<String, dynamic>?,
  ),
  match: json['match'] as String?,
  isStreamable: LastFMValueNormalizer.isArtistStreamable(json['streamable']),
  listeners: LastFMValueNormalizer.NumberToInt(json['listeners']),
  playCount: LastFMValueNormalizer.NumberToInt(json['playcount']),
  onTour: LastFMValueNormalizer.NumberToBool(json['ontour']),
  mbid: json['mbid'] as String?,
);

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
  'name': ?instance.name,
  'url': ?instance.url,
  'image': ?instance.images,
  'tags': ?instance.tags,
  'tagcount': ?instance.tagCount,
  'stats': ?instance.stats,
  'bio': ?instance.bio,
  'similar': ?instance.similarArtists,
  'match': ?instance.match,
  'streamable': ?instance.isStreamable,
  'listeners': ?instance.listeners,
  'playcount': ?instance.playCount,
  'ontour': ?instance.onTour,
  'mbid': ?instance.mbid,
};

ArtistSearchResults _$ArtistSearchResultsFromJson(Map<String, dynamic> json) =>
    ArtistSearchResults(
      artists: LastFMValueNormalizer.artistsExtractor(
        json['artistmatches'] as Map<String, dynamic>?,
      ),
      totalResults: LastFMValueNormalizer.NumberToInt(
        json['opensearch:TotalResults'],
      ),
      statingIndex: LastFMValueNormalizer.NumberToInt(
        json['opensearch:StartIndex'],
      ),
      itemsPerPage: LastFMValueNormalizer.NumberToInt(
        json['opensearch:ItemsPerPage'],
      ),
    );

Map<String, dynamic> _$ArtistSearchResultsToJson(
  ArtistSearchResults instance,
) => <String, dynamic>{
  'artistmatches': ?instance.artists,
  'opensearch:TotalResults': ?instance.totalResults,
  'opensearch:StartIndex': ?instance.statingIndex,
  'opensearch:ItemsPerPage': ?instance.itemsPerPage,
};

Bio _$BioFromJson(Map<String, dynamic> json) => Bio(
  links: LastFMValueNormalizer.linksExtractor(
    json['links'] as Map<String, dynamic>?,
  ),
  published: json['published'] as String?,
  summary: json['summary'] as String?,
  content: json['content'] as String?,
);

Map<String, dynamic> _$BioToJson(Bio instance) => <String, dynamic>{
  'links': ?instance.links,
  'published': ?instance.published,
  'summary': ?instance.summary,
  'content': ?instance.content,
};

Chart _$ChartFromJson(Map<String, dynamic> json) => Chart(
  text: json['#text'] as String?,
  fromDate: LastFMValueNormalizer.DateTimeFromUnixTime(json['from']),
  toDate: LastFMValueNormalizer.DateTimeFromUnixTime(json['to']),
);

Map<String, dynamic> _$ChartToJson(Chart instance) => <String, dynamic>{
  '#text': ?instance.text,
  'from': ?LastFMValueNormalizer.DateTimeToUnixTime(instance.fromDate),
  'to': ?LastFMValueNormalizer.DateTimeToUnixTime(instance.toDate),
};

Date _$DateFromJson(Map<String, dynamic> json) =>
    Date(unixDate: json['uts'] as String?, text: json['#text'] as String?);

Map<String, dynamic> _$DateToJson(Date instance) => <String, dynamic>{
  'uts': ?instance.unixDate,
  '#text': ?instance.text,
};

Image _$ImageFromJson(Map<String, dynamic> json) => Image(
  size: $enumDecodeNullable(
    _$SizeEnumMap,
    json['size'],
    unknownValue: Size.None,
  ),
  text: json['#text'] as String?,
);

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
  'size': ?_$SizeEnumMap[instance.size],
  '#text': ?instance.text,
};

const _$SizeEnumMap = {
  Size.small: 'small',
  Size.medium: 'medium',
  Size.large: 'large',
  Size.extralarge: 'extralarge',
  Size.mega: 'mega',
  Size.empty: 'empty',
  Size.None: 'None',
};

Link _$LinkFromJson(Map<String, dynamic> json) => Link(
  text: json['#text'] as String?,
  rel: json['rel'] as String?,
  webLink: json['href'] as String?,
);

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
  '#text': ?instance.text,
  'rel': ?instance.rel,
  'href': ?instance.webLink,
};

Registered _$RegisteredFromJson(Map<String, dynamic> json) => Registered(
  unixTime: LastFMValueNormalizer.DateTimeFromUnixTime(json['unixtime']),
  text: LastFMValueNormalizer.MeaninglessNumber(json['#text']),
);

Map<String, dynamic> _$RegisteredToJson(Registered instance) =>
    <String, dynamic>{
      'unixtime': ?LastFMValueNormalizer.DateTimeToUnixTime(instance.unixTime),
      '#text': ?instance.text,
    };

Stats _$StatsFromJson(Map<String, dynamic> json) => Stats(
  listeners: LastFMValueNormalizer.NumberToInt(json['listeners']),
  playCount: LastFMValueNormalizer.NumberToInt(json['playcount']),
  userPlayCount: LastFMValueNormalizer.NumberToInt(json['userplaycount']),
);

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
  'listeners': ?instance.listeners,
  'playcount': ?instance.playCount,
  'userplaycount': ?instance.userPlayCount,
};

Streamable _$StreamableFromJson(Map<String, dynamic> json) => Streamable(
  text: json['#text'] as String?,
  fullTrack: json['fulltrack'] as String?,
);

Map<String, dynamic> _$StreamableToJson(Streamable instance) =>
    <String, dynamic>{
      '#text': ?instance.text,
      'fulltrack': ?instance.fullTrack,
    };

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
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

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
  'name': instance.name,
  'url': ?instance.url,
  'count': ?instance.count,
  'total': ?instance.total,
  'reach': ?instance.reach,
  'taggings': ?instance.taggings,
  'streamable': ?instance.streamable,
  'wiki': ?instance.wiki,
};

Taggings _$TaggingsFromJson(Map<String, dynamic> json) => Taggings(
  albums: LastFMValueNormalizer.albumsExtractor(
    json['albums'] as Map<String, dynamic>?,
  ),
  artists: LastFMValueNormalizer.artistsExtractor(
    json['artists'] as Map<String, dynamic>?,
  ),
  tracks: LastFMValueNormalizer.tracksExtractor(
    json['tracks'] as Map<String, dynamic>?,
  ),
);

Map<String, dynamic> _$TaggingsToJson(Taggings instance) => <String, dynamic>{
  'albums': ?instance.albums,
  'artists': ?instance.artists,
  'tracks': ?instance.tracks,
};

Track _$TrackFromJson(Map<String, dynamic> json) => Track(
  name: json['name'] as String,
  album: json['album'] == null
      ? null
      : Album.fromJson(json['album'] as Map<String, dynamic>),
  artist: LastFMValueNormalizer.ArtistParser(json['artist']),
  url: json['url'] as String?,
  duration: LastFMValueNormalizer.MillisecondsDurationParser(json['duration']),
  images: (json['image'] as List<dynamic>?)
      ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
      .toList(),
  topTags: LastFMValueNormalizer.tagsExtractor(
    json['toptags'] as Map<String, dynamic>?,
  ),
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

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
  'name': instance.name,
  'album': ?instance.album,
  'artist': ?instance.artist,
  'url': ?instance.url,
  'duration': ?instance.duration?.inMicroseconds,
  'image': ?instance.images,
  'toptags': ?instance.topTags,
  'date': ?instance.date,
  'streamable': ?instance.streamable,
  'listeners': ?instance.listeners,
  'playcount': ?instance.playCount,
  'wiki': ?instance.wiki,
  'mbid': ?instance.mbid,
  'loved': ?instance.loved,
};

TrackSearchResults _$TrackSearchResultsFromJson(Map<String, dynamic> json) =>
    TrackSearchResults(
      tracks: LastFMValueNormalizer.tracksExtractor(
        json['trackmatches'] as Map<String, dynamic>?,
      ),
      totalResults: LastFMValueNormalizer.NumberToInt(
        json['opensearch:TotalResults'],
      ),
      statingIndex: LastFMValueNormalizer.NumberToInt(
        json['opensearch:StartIndex'],
      ),
      itemsPerPage: LastFMValueNormalizer.NumberToInt(
        json['opensearch:ItemsPerPage'],
      ),
    );

Map<String, dynamic> _$TrackSearchResultsToJson(TrackSearchResults instance) =>
    <String, dynamic>{
      'trackmatches': ?instance.tracks,
      'opensearch:TotalResults': ?instance.totalResults,
      'opensearch:StartIndex': ?instance.statingIndex,
      'opensearch:ItemsPerPage': ?instance.itemsPerPage,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
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

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'name': instance.name,
  'realname': ?instance.realName,
  'gender': ?instance.gender,
  'age': ?instance.age,
  'country': ?instance.country,
  'url': ?instance.url,
  'image': ?instance.image,
  'subscriber': ?instance.subscriber,
  'playlists': ?instance.playlists,
  'playcount': ?instance.playCount,
  'registered': ?instance.registered,
  'bootstrap': ?instance.bootstrap,
  'type': ?instance.type,
};

Wiki _$WikiFromJson(Map<String, dynamic> json) => Wiki(
  published: json['published'] as String?,
  summary: json['summary'] as String?,
  content: json['content'] as String?,
);

Map<String, dynamic> _$WikiToJson(Wiki instance) => <String, dynamic>{
  'published': ?instance.published,
  'summary': ?instance.summary,
  'content': ?instance.content,
};

LibraryGetArtistsResponse _$LibraryGetArtistsResponseFromJson(
  Map<String, dynamic> json,
) => LibraryGetArtistsResponse(
  artist: (json['artist'] as List<dynamic>?)
      ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
      .toList(),
  attr: json['@attr'] == null
      ? null
      : Attr.fromJson(json['@attr'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LibraryGetArtistsResponseToJson(
  LibraryGetArtistsResponse instance,
) => <String, dynamic>{'artist': ?instance.artist, '@attr': ?instance.attr};
