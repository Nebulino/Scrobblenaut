//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/lastfm_methods.dart';
import 'package:scrobblenaut/scrobblenaut.dart';

/// Give the ability of applying [UserMethods] on [User].
extension UserExtension on User {
  UserMethods get _userMethods => Scrobblenaut.instance.user;

  /// [UserMethods.getFriends]
  Future<List<User>?> getFriends({
    bool enableRecentTracks = false,
    int page = 1,
    int limit = 50,
  }) async {
    return await _userMethods.getFriends(
      user: name,
      enableRecentTracks: enableRecentTracks,
      page: page,
      limit: limit,
    );
  }

  /// [UserMethods.getInfo]
  Future<User> getInfo() async {
    return await _userMethods.getInfo(
      user: name,
    );
  }

  /// [UserMethods.getLovedTracks]
  Future<List<Track>?> getLovedTracks({
    int page = 1,
    int limit = 50,
  }) async {
    return await _userMethods.getLovedTracks(
      user: name,
      page: page,
      limit: limit,
    );
  }

  /// [UserMethods.getPersonalTags]
  Future<Taggings> getPersonalTags({
    required String tag,
    required TaggingType taggingType,
    int page = 1,
    int limit = 50,
  }) async {
    return await _userMethods.getPersonalTags(
      user: name,
      tag: tag,
      taggingType: taggingType,
    );
  }

  /// [UserMethods.getRecentTracks]
  Future<List<Track>?> getRecentTracks({
    int page = 1,
    int limit = 50, // MAX 200
    DateTime? fromDate,
    DateTime? toDate,
    bool extended = false,
  }) async {
    return await _userMethods.getRecentTracks(
      user: name,
      page: page,
      limit: limit,
      fromDate: fromDate,
      toDate: toDate,
      extended: extended,
    );
  }

  /// [UserMethods.getTopAlbums]
  Future<List<Album>?> getTopAlbums({
    Period? period,
    int page = 1,
    int limit = 50,
  }) async {
    return await _userMethods.getTopAlbums(
      user: name,
      period: period,
      page: page,
      limit: limit,
    );
  }

  /// [UserMethods.getTopArtists]
  Future<List<Artist>?> getTopArtists({
    Period? period,
    int page = 1,
    int limit = 50,
  }) async {
    return await _userMethods.getTopArtists(
      user: name,
      period: period,
      page: page,
      limit: limit,
    );
  }

  /// [UserMethods.getTopTags]
  Future<List<Tag>?> getTopTags({
    int? limit,
  }) async {
    return await _userMethods.getTopTags(
      user: name,
      limit: limit,
    );
  }

  /// [UserMethods.getTopTracks]
  Future<List<Track>> getTopTracks({
    Period? period,
    int page = 1,
    int limit = 50,
  }) async {
    return await _userMethods.getTopTracks(
      user: name,
      period: period,
      page: page,
      limit: limit,
    );
  }

  /// [UserMethods.getWeeklyAlbumChart]
  Future<List<Album>?> getWeeklyAlbumChart({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return await _userMethods.getWeeklyAlbumChart(
      user: name,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  /// [UserMethods.getWeeklyArtistChart]
  Future<List<Artist>?> getWeeklyArtistChart({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return await _userMethods.getWeeklyArtistChart(
      user: name,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  /// [UserMethods.getWeeklyChartList]
  Future<List<Chart>?> getWeeklyChartList() async {
    return await _userMethods.getWeeklyChartList(
      user: name,
    );
  }

  /// [UserMethods.getWeeklyTrackChart]
  Future<List<Track>?> getWeeklyTrackChart({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return await _userMethods.getWeeklyTrackChart(
      user: name,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}
