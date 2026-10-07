//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/scrobblenaut.dart';
import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';
import 'package:scrobblenaut/src/core/request.dart';
import 'package:scrobblenaut/src/core/request_mode.dart';
import 'package:scrobblenaut/src/helpers/lastfm_value_normalizer.dart';
import 'package:scrobblenaut/src/helpers/utils.dart';

/// This contains all the methods about a [User].
class UserMethods {
  final LastFM _api;

  UserMethods(this._api);

  /// Get a list of the user's friends on Last.fm.
  ///
  /// https://www.last.fm/api/show/user.getFriends
  Future<List<User>?> getFriends({
    required String user,
    bool enableRecentTracks = false,
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'user': user,
      'recenttracks': (enableRecentTracks ? 1 : 0),
      'page': page,
      'limit': limit,
    };

    final request = Request(
      api: _api,
      method: 'user.getFriends',
      parameters: parameters,
    );

    final response = await request.send(mode: RequestMode.GET);

    final friends = response['friends']['user'];

    return parseLastFMList<User>(friends, (item) => User.fromJson(item));
  }

  /// Get information about a user profile.
  ///
  /// If [user] is null, defaults to the authenticated user.
  ///
  /// https://www.last.fm/api/show/user.getInfo
  Future<User> getInfo({String? user}) async {
    final parameters = {'user': user};

    final request = Request(
      api: _api,
      method: 'user.getInfo',
      parameters: parameters,
    );

    final response = await request.send(mode: RequestMode.GET);

    return User.fromJson(response['user']);
  }

  /// Get the last 50 tracks loved by a user.
  ///
  /// https://www.last.fm/api/show/user.getLovedTracks
  Future<List<Track>?> getLovedTracks({
    required String user,
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {'user': user, 'page': page, 'limit': limit};

    final request = Request(
      api: _api,
      method: 'user.getLovedTracks',
      parameters: parameters,
    );

    final response = await request.send(mode: RequestMode.GET);

    final lovedTracks = response['lovedtracks']['track'];

    return parseLastFMList<Track>(lovedTracks, (item) => Track.fromJson(item));
  }

  /// Get the user's personal tags.
  ///
  /// https://www.last.fm/api/show/user.getPersonalTags
  Future<Taggings> getPersonalTags({
    required String user,
    required String tag,
    required TaggingType taggingType,
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'user': user,
      'tag': tag,
      'taggingtype': taggingType.type,
      'page': page,
      'limit': limit,
    };

    // TODO: a better implementation?

    final request = Request(
      api: _api,
      method: 'user.getPersonalTags',
      parameters: parameters,
    );

    final response = await request.send(mode: RequestMode.GET);

    var taggings = Taggings()
      ..albums = <Album>[]
      ..artists = <Artist>[]
      ..tracks = <Track>[];

    if (taggingType == TaggingType.album) {
      final taggedAlbum = response['taggings']['albums']['album'];
      taggings.albums =
          parseLastFMList<Album>(taggedAlbum, (i) => Album.fromJson(i)) ??
          <Album>[];
    }

    if (taggingType == TaggingType.artist) {
      final taggedArtists = response['taggings']['artists']['artist'];
      taggings.artists =
          parseLastFMList<Artist>(taggedArtists, (i) => Artist.fromJson(i)) ??
          <Artist>[];
    }

    if (taggingType == TaggingType.track) {
      final taggedTracks = response['taggings']['tracks']['track'];
      taggings.tracks =
          parseLastFMList<Track>(taggedTracks, (i) => Track.fromJson(i)) ??
          <Track>[];
    }

    return taggings;
  }

  /// Get a list of the recent tracks listened to by this user.
  ///
  /// **NOTE:** the output list is already ordered by last listened first.
  ///
  /// https://www.last.fm/api/show/user.getRecentTracks
  Future<List<Track>?> getRecentTracks({
    required String user,
    int page = 1,
    int limit = 50, // MAX 200
    DateTime? fromDate,
    DateTime? toDate,
    bool extended = false,
  }) async {
    if (limit > 200) {
      return Future.error(
        ScrobblenautException(description: 'The max limit is 200'),
      );
    }

    final parameters = {
      'user': user,
      'page': page,
      'limit': limit,
      'from': LastFMValueNormalizer.DateTimeToUnixTime(fromDate),
      'to': LastFMValueNormalizer.DateTimeToUnixTime(toDate),
      'extended': (extended ? 1 : 0),
    };

    final request = Request(
      api: _api,
      method: 'user.getRecentTracks',
      parameters: parameters,
    );

    final response = await request.send(mode: RequestMode.GET);

    final recentTracks = response['recenttracks']['track'];

    // View Issue in Github.
    // https://github.com/Nebulino/Scrobblenaut/issues/24
    if (recentTracks == null) {
      return null;
    } else {
      return parseLastFMList<Track>(recentTracks, (track) {
        if (track['artist'] is Map) {
          track['artist']['name'] ??=
              isValidParsableStringField(track['artist']['#text'])
              ? track['artist']['#text']
              : null;
        }
        return Track.fromJson(track);
      });
    }
  }

  /// Get the top albums listened to by a user.
  /// You can stipulate a time period. Sends the overall chart by default.
  ///
  /// **NOTE:** the output list is already ordered by rank.
  ///
  /// https://www.last.fm/api/show/user.getTopAlbums
  Future<List<Album>?> getTopAlbums({
    required String user,
    Period? period,
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'user': user,
      'period': period?.value,
      'page': page,
      'limit': limit,
    };

    final request = Request(
      api: _api,
      method: 'user.getTopAlbums',
      parameters: parameters,
    );

    final response = await request.send(mode: RequestMode.GET);

    final topAlbums = response['topalbums']['album'];

    return parseLastFMList<Album>(topAlbums, (i) => Album.fromJson(i));
  }

  /// Get the top artists listened to by a user.
  /// You can stipulate a time period.
  /// Sends the overall chart by default.
  ///
  /// **NOTE:** the output list is already ordered by rank.
  ///
  /// https://www.last.fm/api/show/user.getTopArtists
  Future<List<Artist>?> getTopArtists({
    required String user,
    Period? period,
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'user': user,
      'period': period?.value,
      'page': page,
      'limit': limit,
    };

    final request = Request(
      api: _api,
      method: 'user.getTopArtists',
      parameters: parameters,
    );

    final response = await request.send(mode: RequestMode.GET);

    final topArtist = response['topartists']['artist'];

    return parseLastFMList<Artist>(topArtist, (i) => Artist.fromJson(i));
  }

  /// Get the top tags used by this user.
  ///
  /// **NOTE:** the output list is already ordered by rank.
  ///
  /// https://www.last.fm/api/show/user.getTopTags
  Future<List<Tag>?> getTopTags({required String user, int? limit}) async {
    final parameters = {'user': user, 'limit': limit};

    final request = Request(
      api: _api,
      method: 'user.getTopTags',
      parameters: parameters,
    );

    final response = await request.send(mode: RequestMode.GET);

    final topTags = response['toptags']['tag'];

    return parseLastFMList<Tag>(topTags, (i) => Tag.fromJson(i));
  }

  /// Get the top tracks listened to by a user.
  /// You can stipulate a time period.
  /// Sends the overall chart by default.
  ///
  /// **NOTE:** the output list is already ordered by rank.
  ///
  /// https://www.last.fm/api/show/user.getTopTracks
  Future<List<Track>> getTopTracks({
    required String user,
    Period? period,
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'user': user,
      'period': period?.value,
      'page': page,
      'limit': limit,
    };

    // TODO: is the rank necessary!?

    final request = Request(
      api: _api,
      method: 'user.getTopTracks',
      parameters: parameters,
    );

    final response = await request.send(mode: RequestMode.GET);

    final topTracks = response['toptracks']['track'];

    if (topTracks == null) {
      return [];
    } else {
      // This operation is necessary because the tracks have different duration.
      var fixTopTracks =
          parseLastFMList<Track>(topTracks, (i) => Track.fromJson(i)) ?? [];

      for (var track in fixTopTracks) {
        if (track.duration != null) {
          track.duration = track.duration! * 1000;
        }
      }
      return fixTopTracks;
    }
  }

  /// Get an album chart for a user profile, for a given date range.
  /// If no date range is supplied,
  /// it will return the most recent album chart for this user.
  ///
  /// **NOTE:** the output list is already ordered by rank.
  ///
  /// https://www.last.fm/api/show/user.getWeeklyAlbumChart
  Future<List<Album>?> getWeeklyAlbumChart({
    required String user,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final parameters = {
      'user': user,
      'from': LastFMValueNormalizer.DateTimeToUnixTime(fromDate),
      'to': LastFMValueNormalizer.DateTimeToUnixTime(toDate),
    };

    // TODO: is the rank necessary!?

    final request = Request(
      api: _api,
      method: 'user.getWeeklyAlbumChart',
      parameters: parameters,
    );

    final response = await request.send(mode: RequestMode.GET);

    final weeklyAlbumChart = response['weeklyalbumchart']['album'];

    return parseLastFMList<Album>(weeklyAlbumChart, (i) => Album.fromJson(i));
  }

  /// Get an artist chart for a user profile, for a given date range.
  /// If no date range is supplied,
  /// it will return the most recent artist chart for this user.
  ///
  /// **NOTE:** the output list is already ordered by rank.
  ///
  /// https://www.last.fm/api/show/user.getWeeklyArtistChart
  Future<List<Artist>?> getWeeklyArtistChart({
    required String user,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final parameters = {
      'user': user,
      'from': LastFMValueNormalizer.DateTimeToUnixTime(fromDate),
      'to': LastFMValueNormalizer.DateTimeToUnixTime(toDate),
    };

    // TODO: is the rank necessary!?

    final request = Request(
      api: _api,
      method: 'user.getWeeklyArtistChart',
      parameters: parameters,
    );

    final response = await request.send(mode: RequestMode.GET);

    final weeklyArtistChart = response['weeklyartistchart']['artist'];

    return parseLastFMList<Artist>(
      weeklyArtistChart,
      (i) => Artist.fromJson(i),
    );
  }

  /// Get a list of available charts for this user,
  /// expressed as date ranges which can be sent to the chart services.
  ///
  /// https://www.last.fm/api/show/user.getWeeklyChartList
  Future<List<Chart>?> getWeeklyChartList({required String user}) async {
    final parameters = {'user': user};

    final request = Request(
      api: _api,
      method: 'user.getWeeklyChartList',
      parameters: parameters,
    );

    final response = await request.send(mode: RequestMode.GET);

    final weeklyChartList = response['weeklychartlist']['chart'];

    return parseLastFMList<Chart>(weeklyChartList, (i) => Chart.fromJson(i));
  }

  /// Get a track chart for a user profile, for a given date range.
  /// If no date range is supplied,
  /// it will return the most recent track chart for this user.
  ///
  /// **NOTE:** the output list is already ordered by rank.
  ///
  /// https://www.last.fm/api/show/user.getWeeklyTrackChart
  Future<List<Track>?> getWeeklyTrackChart({
    required String user,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final parameters = {
      'user': user,
      'from': LastFMValueNormalizer.DateTimeToUnixTime(fromDate),
      'to': LastFMValueNormalizer.DateTimeToUnixTime(toDate),
    };

    // TODO: is the rank necessary!?

    final request = Request(
      api: _api,
      method: 'user.getWeeklyTrackChart',
      parameters: parameters,
    );

    final response = await request.send(mode: RequestMode.GET);

    final weeklyTrackChart = response['weeklytrackchart']['track'];

    return parseLastFMList<Track>(weeklyTrackChart, (i) => Track.fromJson(i));
  }
}
