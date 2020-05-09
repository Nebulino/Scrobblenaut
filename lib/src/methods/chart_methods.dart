//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';
import 'package:scrobblenaut/src/core/request.dart';
import 'package:scrobblenaut/src/core/request_mode.dart';

/// This contains all the methods about a [Chart].
class ChartMethods {
  final LastFM _api;

  ChartMethods(this._api);

  /// Get the top artists chart.
  ///
  /// https://www.last.fm/api/show/chart.getTopArtists
  Future<List<Artist>> getTopArtists({
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'page': page,
      'limit': limit,
    };

    final request = Request(
        api: _api, method: 'chart.getTopArtists', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final topArtists = response['artists']['artist'];

    return topArtists == null
        ? null
        : List.generate(
            (topArtists as List).length, (i) => Artist.fromJson(topArtists[i]));
  }

  /// Get the top tags chart.
  ///
  /// https://www.last.fm/api/show/chart.getTopTags
  Future<List<Tag>> getTopTags({
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'page': page,
      'limit': limit,
    };

    final request =
        Request(api: _api, method: 'chart.getTopTags', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final topTags = response['tags']['tag'];

    return topTags == null
        ? null
        : List.generate(
            (topTags as List).length, (i) => Tag.fromJson(topTags[i]));
  }

  /// Get the top tracks chart.
  ///
  /// https://www.last.fm/api/show/chart.getTopTracks
  Future<List<Track>> getTopTracks({
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'page': page,
      'limit': limit,
    };

    final request = Request(
        api: _api, method: 'chart.getTopTracks', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final topTrack = response['tracks']['track'];

    return topTrack == null
        ? null
        : List.generate(
            (topTrack as List).length, (i) => Track.fromJson(topTrack[i]));
  }
}
