/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:meta/meta.dart';
import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/scrobblenaut.dart';
import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';
import 'package:scrobblenaut/src/core/request.dart';

/// This contains all the methods about a [User].
class UserMethods {
  final LastFM _api;

  UserMethods(this._api);

  /// Get a list of the user's friends on Last.fm.
  ///
  /// https://www.last.fm/api/show/user.getFriends
  Future<dynamic> getFriends({
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

    return Future.error(
        ScrobblenautException(description: 'Not yet implemented'));
  }

  /// Get information about a user profile.
  ///
  /// https://www.last.fm/api/show/user.getInfo
  Future<dynamic> getInfo({
    String user,
  }) async {
    final parameters = {
      'user': user,
    };

    final request =
        Request(api: _api, method: 'user.getInfo', parameters: parameters);

    return Future.error(
        ScrobblenautException(description: 'Not yet implemented'));
  }

  /// Get the last 50 tracks loved by a user.
  ///
  /// https://www.last.fm/api/show/user.getLovedTracks
  Future<dynamic> getLovedTracks({
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

    return Future.error(
        ScrobblenautException(description: 'Not yet implemented'));
  }

  /// Get the user's personal tags.
  ///
  /// https://www.last.fm/api/show/user.getPersonalTags
  Future<dynamic> getPersonalTags({
    @required String user,
    @required String tag,
    TaggingType taggingType,
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'user': user,
      'tag': tag,
      'taggingtype': taggingType?.index,
      'page': page,
      'limit': limit,
    };

    final request = Request(
        api: _api, method: 'user.getPersonalTags', parameters: parameters);

    return Future.error(
        ScrobblenautException(description: 'Not yet implemented'));
  }

  /// Get a list of the recent tracks listened to by this user.
  /// Also includes the currently playing track with the nowPlaying="true"
  /// attribute if the user is currently listening.
  ///
  /// https://www.last.fm/api/show/user.getRecentTracks
  Future<dynamic> getRecentTracks({
    @required String user,
    int page = 1,
    int limit = 50, // MAX 200
    DateTime from,
    DateTime to,
    bool extended = false,
    bool nowPlaying = false,
  }) async {
    final parameters = {
      'user': user,
      'page': page,
      'limit': limit,
      // TODO: fix datetime
      'extended': (extended ? 1 : 0),
      'nowplaying': (nowPlaying ? 1 : 0),
    };

    final request = Request(
        api: _api, method: 'user.getRecentTracks', parameters: parameters);

    return Future.error(
        ScrobblenautException(description: 'Not yet implemented'));
  }

  /// Get the top albums listened to by a user.
  /// You can stipulate a time period. Sends the overall chart by default.
  ///
  /// https://www.last.fm/api/show/user.getTopAlbums
  Future<dynamic> getTopAlbums({
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

    return Future.error(
        ScrobblenautException(description: 'Not yet implemented'));
  }

  /// Get the top artists listened to by a user.
  /// You can stipulate a time period.
  /// Sends the overall chart by default.
  ///
  /// https://www.last.fm/api/show/user.getTopArtists
  Future<dynamic> getTopArtists({
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

    return Future.error(
        ScrobblenautException(description: 'Not yet implemented'));
  }

  /// Get the top tags used by this user.
  ///
  /// https://www.last.fm/api/show/user.getTopTags
  Future<dynamic> getTopTags({
    @required String user,
    int limit,
  }) async {
    final parameters = {
      'user': user,
      'limit': limit,
    };

    final request =
        Request(api: _api, method: 'user.getTopTags', parameters: parameters);

    return Future.error(
        ScrobblenautException(description: 'Not yet implemented'));
  }

  /// Get the top tracks listened to by a user.
  /// You can stipulate a time period.
  /// Sends the overall chart by default.
  ///
  /// https://www.last.fm/api/show/user.getTopTracks
  Future<dynamic> getTopTracks({
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
        Request(api: _api, method: 'user.getTopTracks', parameters: parameters);

    return Future.error(
        ScrobblenautException(description: 'Not yet implemented'));
  }

  /// Get an album chart for a user profile, for a given date range.
  /// If no date range is supplied,
  /// it will return the most recent album chart for this user.
  ///
  /// https://www.last.fm/api/show/user.getWeeklyAlbumChart
  Future<void> getWeeklyAlbumChart({
    @required String user,
    DateTime from,
    DateTime to,
  }) async {
    final parameters = {
      'user': user,
      // TODO: fix datetime
    };

    final request = Request(
        api: _api, method: 'user.getWeeklyAlbumChart', parameters: parameters);

    return Future.error(
        ScrobblenautException(description: 'Not yet implemented'));
  }

  /// Get an artist chart for a user profile, for a given date range.
  /// If no date range is supplied,
  /// it will return the most recent artist chart for this user.
  ///
  /// https://www.last.fm/api/show/user.getWeeklyArtistChart
  Future<dynamic> getWeeklyArtistChart({
    @required String user,
    DateTime from,
    DateTime to,
  }) async {
    final parameters = {
      'user': user,
      // TODO: fix datetime
    };

    final request = Request(
        api: _api, method: 'user.getWeeklyArtistChart', parameters: parameters);

    return Future.error(
        ScrobblenautException(description: 'Not yet implemented'));
  }

  /// Get a list of available charts for this user,
  /// expressed as date ranges which can be sent to the chart services.
  ///
  /// https://www.last.fm/api/show/user.getWeeklyChartList
  Future<dynamic> getWeeklyChartList({
    @required String user,
  }) async {
    final parameters = {
      'user': user,
    };

    final request = Request(
        api: _api, method: 'user.getWeeklyChartList', parameters: parameters);

    return Future.error(
        ScrobblenautException(description: 'Not yet implemented'));
  }

  /// Get a track chart for a user profile, for a given date range.
  /// If no date range is supplied,
  /// it will return the most recent track chart for this user.
  ///
  /// https://www.last.fm/api/show/user.getWeeklyTrackChart
  Future<dynamic> getWeeklyTrackChart({
    @required String user,
    DateTime from,
    DateTime to,
  }) async {
    final parameters = {
      'user': user,
      // TODO: fix datetime
    };

    final request = Request(
        api: _api, method: 'user.getWeeklyTrackChart', parameters: parameters);

    return Future.error(
        ScrobblenautException(description: 'Not yet implemented'));
  }
}
