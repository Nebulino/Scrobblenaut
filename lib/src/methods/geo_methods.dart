/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:meta/meta.dart';
import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';
import 'package:scrobblenaut/src/core/request.dart';
import 'package:scrobblenaut/src/core/request_mode.dart';

/// This contains all the methods about an [Geo].
class GeoMethods {
  final LastFM _api;

  GeoMethods(this._api);

  /// Get the most popular artists on Last.fm by country.
  ///
  /// https://www.last.fm/api/show/geo.getTopArtists
  Future<List<Artist>> getTopArtists({
    @required String country,
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'country': country,
      'page': page,
      'limit': limit,
    };

    final request =
        Request(api: _api, method: 'geo.getTopArtists', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final topArtists = response['topartists']['artist'];

    return topArtists == null
        ? null
        : List.generate(
            (topArtists as List).length, (i) => Artist.fromJson(topArtists[i]));
  }

  /// Get the most popular tracks on Last.fm last week by country.
  ///
  /// https://www.last.fm/api/show/geo.getTopTracks
  Future<List<Track>> getTopTracks({
    @required String country,
    String location,
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'country': country,
      'location': location,
      'page': page,
      'limit': limit,
    };

    final request =
        Request(api: _api, method: 'geo.getTopTracks', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final topTracks = response['tracks']['track'];

    return topTracks == null
        ? null
        : List.generate(
            (topTracks as List).length, (i) => Track.fromJson(topTracks[i]));
  }
}
