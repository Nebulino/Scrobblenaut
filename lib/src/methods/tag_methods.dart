//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:meta/meta.dart';
import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';
import 'package:scrobblenaut/src/core/request.dart';
import 'package:scrobblenaut/src/core/request_mode.dart';

/// This contains all the methods about a [Tag].
class TagMethods {
  final LastFM _api;

  TagMethods(this._api);

  /// Get the metadata for a tag.
  ///
  /// https://www.last.fm/api/show/tag.getInfo
  Future<Tag> getInfo({
    @required String tag,
    Language language = Language.en,
  }) async {
    final parameters = {
      'tag': tag,
      'lang': language?.code,
    };

    final request =
        Request(api: _api, method: 'tag.getInfo', parameters: parameters);

    return (Tag.fromJson((await request.send(mode: RequestMode.GET))['tag']));
  }

  /// Search for tags similar to this one.
  /// Returns tags ranked by similarity, based on listening data.
  ///
  /// https://www.last.fm/api/show/tag.getSimilar
  Future<List<Tag>> getSimilar({
    @required String tag,
  }) async {
    final parameters = {
      'tag': tag,
    };

    final request =
        Request(api: _api, method: 'tag.getSimilar', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final similarTags = response['similartags']['tag'];

    return similarTags == null
        ? null
        : List.generate(
            (similarTags as List).length, (i) => Tag.fromJson(similarTags[i]));
  }

  /// Get the top albums tagged by this tag, ordered by tag count.
  ///
  /// https://www.last.fm/api/show/tag.getTopAlbums
  Future<List<Album>> getTopAlbums({
    @required String tag,
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'tag': tag,
      'page': page,
      'limit': limit,
    };

    final request =
        Request(api: _api, method: 'tag.getTopAlbums', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final topAlbums = response['albums']['album'];

    return topAlbums == null
        ? null
        : List.generate(
            (topAlbums as List).length, (i) => Album.fromJson(topAlbums[i]));
  }

  /// Get the top artists tagged by this tag, ordered by tag count.
  ///
  /// https://www.last.fm/api/show/tag.getTopArtists
  Future<List<Artist>> getTopArtists({
    @required String tag,
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'tag': tag,
      'page': page,
      'limit': limit,
    };

    final request =
        Request(api: _api, method: 'tag.getTopArtists', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final topArtists = response['topartists']['artist'];

    return topArtists == null
        ? null
        : List.generate(
            (topArtists as List).length, (i) => Artist.fromJson(topArtists[i]));
  }

  /// Fetches the top global tags on Last.fm,
  /// sorted by popularity (number of times used).
  ///
  /// https://www.last.fm/api/show/tag.getTopTags
  Future<List<Tag>> getTopTags() async {
    final request = Request(api: _api, method: 'tag.getTopTags');

    final response = await request.send(mode: RequestMode.GET);

    final topTags = response['toptags']['tag'];

    return topTags == null
        ? null
        : List.generate(
            (topTags as List).length, (i) => Tag.fromJson(topTags[i]));
  }

  /// Get the top tracks tagged by this tag, ordered by tag count.
  ///
  /// https://www.last.fm/api/show/tag.getTopTracks
  Future<List<Track>> getTopTracks({
    @required String tag,
    int page = 1,
    int limit = 50,
  }) async {
    final parameters = {
      'tag': tag,
      'page': page,
      'limit': limit,
    };

    final request =
        Request(api: _api, method: 'tag.getTopTracks', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final topTracks = response['tracks']['track'];

    return topTracks == null
        ? null
        : List.generate(
            (topTracks as List).length, (i) => Track.fromJson(topTracks[i]));
  }

  /// Get a list of available charts for this tag,
  /// expressed as date ranges which can be sent to the chart services.
  ///
  /// https://www.last.fm/api/show/tag.getWeeklyChartList.
  Future<List<Chart>> getWeeklyChartList({
    @required String tag,
  }) async {
    final parameters = {
      'tag': tag,
    };

    final request = Request(
        api: _api, method: 'tag.getWeeklyChartList', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final chartList = response['weeklychartlist']['chart'];

    return chartList == null
        ? null
        : List.generate(
            (chartList as List).length, (i) => Chart.fromJson(chartList[i]));
  }
}
