//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:meta/meta.dart';
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
  Future<List<User>> getFriends({
    @required String user,
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

    final request =
        Request(api: _api, method: 'user.getFriends', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final friends = response['friends']['user'];

    return friends == null
        ? null
        : List.generate(
            (friends as List).length, (i) => User.fromJson(friends[i]));
  }

  /// Get information about a user profile.
  ///
  /// https://www.last.fm/api/show/user.getInfo
  Future<User> getInfo({
    String user,
  }) async {
    final parameters = {
      'user': user,
    };

    final request =
        Request(api: _api, method: 'user.getInfo', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    return User.fromJson(response['user']);
  }

  /// Get the last 50 tracks loved by a user.
  ///
  /// https://www.last.fm/api/show/user.getLovedTracks
  Future<List<Track>> getLovedTracks({
    @required String user,
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'user': user,
      'page': page,
      'limit': limit,
    };

    final request = Request(
        api: _api, method: 'user.getLovedTracks', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final lovedTracks = response['lovedtracks']['track'];

    return lovedTracks == null
        ? null
        : List.generate((lovedTracks as List).length,
            (i) => Track.fromJson(lovedTracks[i]));
  }

  /// Get the user's personal tags.
  ///
  /// https://www.last.fm/api/show/user.getPersonalTags
  Future<Taggings> getPersonalTags({
    @required String user,
    @required String tag,
    @required TaggingType taggingType,
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'user': user,
      'tag': tag,
      'taggingtype': taggingType?.type,
      'page': page,
      'limit': limit,
    };

    // TODO: a better implementation?

    final request = Request(
        api: _api, method: 'user.getPersonalTags', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    var taggings = Taggings()
      ..albums = <Album>[]
      ..artists = <Artist>[]
      ..tracks = <Track>[];

    if (taggingType == TaggingType.album) {
      final taggedAlbum = response['taggings']['albums']['album'];

      if (taggedAlbum != null) {
        taggings.albums = List.generate((taggedAlbum as List).length,
            (i) => Album.fromJson(taggedAlbum[i]));
      }
    }

    if (taggingType == TaggingType.artist) {
      final taggedArtists = response['taggings']['artists']['artist'];

      if (taggedArtists != null) {
        taggings.artists = List.generate((taggedArtists as List).length,
            (i) => Artist.fromJson(taggedArtists[i]));
      }
    }

    if (taggingType == TaggingType.track) {
      final taggedTracks = response['taggings']['tracks']['track'];

      if (taggedTracks != null) {
        taggings.tracks = List.generate((taggedTracks as List).length,
            (i) => Track.fromJson(taggedTracks[i]));
      }
    }

    return taggings;
  }

  /// Get a list of the recent tracks listened to by this user.
  /// Also includes the currently playing track with the nowPlaying="true"
  /// attribute if the user is currently listening.
  ///
  /// **NOTE:** the output list is already ordered by last listened first.
  ///
  /// https://www.last.fm/api/show/user.getRecentTracks
  Future<List<Track>> getRecentTracks({
    @required String user,
    int page = 1,
    int limit = 50, // MAX 200
    DateTime fromDate,
    DateTime toDate,
    bool extended = false,
    bool nowPlaying = false,
  }) async {
    if (limit > 200) {
      return Future.error(
          ScrobblenautException(description: 'The max limit is 200'));
    }

    final parameters = {
      'user': user,
      'page': page,
      'limit': limit,
      'from': LastFMValueNormalizer.DateTimeToUnixTime(fromDate),
      'to': LastFMValueNormalizer.DateTimeToUnixTime(toDate),
      'extended': (extended ? 1 : 0),
      'nowplaying': (nowPlaying ? 1 : 0),
    };

    final request = Request(
        api: _api, method: 'user.getRecentTracks', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final recentTracks = response['recenttracks']['track'];

    // View Issue in Github.
    // https://github.com/Nebulino/Scrobblenaut/issues/24
    if (recentTracks == null) {
      return null;
    } else {
      (recentTracks as List).forEach((track) {
        // Fixing the track value.
        track['artist']['name'] ??=
            isValidParsableStringField(track['artist']['#text'])
                ? track['artist']['#text']
                : null; // If there's no #text field, don't touch the artist.
      });

      return List.generate((recentTracks as List).length,
          (i) => Track.fromJson(recentTracks[i]));
    }
  }

  /// Get the top albums listened to by a user.
  /// You can stipulate a time period. Sends the overall chart by default.
  ///
  /// **NOTE:** the output list is already ordered by rank.
  ///
  /// https://www.last.fm/api/show/user.getTopAlbums
  Future<List<Album>> getTopAlbums({
    @required String user,
    Period period,
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'user': user,
      'period': period?.value,
      'page': page,
      'limit': limit,
    };

    final request =
        Request(api: _api, method: 'user.getTopAlbums', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final topAlbums = response['topalbums']['album'];

    return topAlbums == null
        ? null
        : List.generate(
            (topAlbums as List).length, (i) => Album.fromJson(topAlbums[i]));
  }

  /// Get the top artists listened to by a user.
  /// You can stipulate a time period.
  /// Sends the overall chart by default.
  ///
  /// **NOTE:** the output list is already ordered by rank.
  ///
  /// https://www.last.fm/api/show/user.getTopArtists
  Future<List<Artist>> getTopArtists({
    @required String user,
    Period period,
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
        api: _api, method: 'user.getTopArtists', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final topArtist = response['topartists']['artist'];

    return topArtist == null
        ? null
        : List.generate(
            (topArtist as List).length, (i) => Artist.fromJson(topArtist[i]));
  }

  /// Get the top tags used by this user.
  ///
  /// **NOTE:** the output list is already ordered by rank.
  ///
  /// https://www.last.fm/api/show/user.getTopTags
  Future<List<Tag>> getTopTags({
    @required String user,
    int limit,
  }) async {
    final parameters = {
      'user': user,
      'limit': limit,
    };

    final request =
        Request(api: _api, method: 'user.getTopTags', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final topTags = response['toptags']['tag'];

    return topTags == null
        ? null
        : List.generate(
            (topTags as List).length, (i) => Tag.fromJson(topTags[i]));
  }

  /// Get the top tracks listened to by a user.
  /// You can stipulate a time period.
  /// Sends the overall chart by default.
  ///
  /// **NOTE:** the output list is already ordered by rank.
  ///
  /// https://www.last.fm/api/show/user.getTopTracks
  Future<List<Track>> getTopTracks({
    @required String user,
    Period period,
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

    final request =
        Request(api: _api, method: 'user.getTopTracks', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final topTracks = response['toptracks']['track'];

    if (topTracks == null) {
      return [];
    } else {
      // This operation is necessary because the tracks have different duration.
      var fixTopTracks = List.generate(
          (topTracks as List).length, (i) => Track.fromJson(topTracks[i]));

      fixTopTracks.forEach((Track track) {
        track.duration = track.duration * 1000;
      });
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
  Future<List<Album>> getWeeklyAlbumChart({
    @required String user,
    DateTime fromDate,
    DateTime toDate,
  }) async {
    final parameters = {
      'user': user,
      'from': LastFMValueNormalizer.DateTimeToUnixTime(fromDate),
      'to': LastFMValueNormalizer.DateTimeToUnixTime(toDate),
    };

    // TODO: is the rank necessary!?

    final request = Request(
        api: _api, method: 'user.getWeeklyAlbumChart', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final weeklyAlbumChart = response['weeklyalbumchart']['album'];

    return weeklyAlbumChart == null
        ? null
        : List.generate((weeklyAlbumChart as List).length,
            (i) => Album.fromJson(weeklyAlbumChart[i]));
  }

  /// Get an artist chart for a user profile, for a given date range.
  /// If no date range is supplied,
  /// it will return the most recent artist chart for this user.
  ///
  /// **NOTE:** the output list is already ordered by rank.
  ///
  /// https://www.last.fm/api/show/user.getWeeklyArtistChart
  Future<List<Artist>> getWeeklyArtistChart({
    @required String user,
    DateTime fromDate,
    DateTime toDate,
  }) async {
    final parameters = {
      'user': user,
      'from': LastFMValueNormalizer.DateTimeToUnixTime(fromDate),
      'to': LastFMValueNormalizer.DateTimeToUnixTime(toDate),
    };

    // TODO: is the rank necessary!?

    final request = Request(
        api: _api, method: 'user.getWeeklyArtistChart', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final weeklyArtistChart = response['weeklyartistchart']['track'];

    return weeklyArtistChart == null
        ? null
        : List.generate((weeklyArtistChart as List).length,
            (i) => Artist.fromJson(weeklyArtistChart[i]));
  }

  /// Get a list of available charts for this user,
  /// expressed as date ranges which can be sent to the chart services.
  ///
  /// https://www.last.fm/api/show/user.getWeeklyChartList
  Future<List<Chart>> getWeeklyChartList({
    @required String user,
  }) async {
    final parameters = {
      'user': user,
    };

    final request = Request(
        api: _api, method: 'user.getWeeklyChartList', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final weeklyChartList = response['weeklychartlist']['chart'];

    return weeklyChartList == null
        ? null
        : List.generate((weeklyChartList as List).length,
            (i) => Chart.fromJson(weeklyChartList[i]));
  }

  /// Get a track chart for a user profile, for a given date range.
  /// If no date range is supplied,
  /// it will return the most recent track chart for this user.
  ///
  /// **NOTE:** the output list is already ordered by rank.
  ///
  /// https://www.last.fm/api/show/user.getWeeklyTrackChart
  Future<List<Track>> getWeeklyTrackChart({
    @required String user,
    DateTime fromDate,
    DateTime toDate,
  }) async {
    final parameters = {
      'user': user,
      'from': LastFMValueNormalizer.DateTimeToUnixTime(fromDate),
      'to': LastFMValueNormalizer.DateTimeToUnixTime(toDate),
    };

    // TODO: is the rank necessary!?

    final request = Request(
        api: _api, method: 'user.getWeeklyTrackChart', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final weeklyTrackChart = response['weeklytrackchart']['track'];

    return weeklyTrackChart == null
        ? null
        : List.generate((weeklyTrackChart as List).length,
            (i) => Track.fromJson(weeklyTrackChart[i]));
  }
}
