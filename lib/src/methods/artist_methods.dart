/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:meta/meta.dart';
import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';
import 'package:scrobblenaut/src/core/request.dart';
import 'package:scrobblenaut/src/core/request_mode.dart';
import 'package:scrobblenaut/src/helpers/post_response_helper.dart';
import 'package:scrobblenaut/src/helpers/utils.dart';

/// This contains all the methods about an [Artist].
class ArtistMethods {
  final LastFM _api;

  ArtistMethods(this._api);

  /// Tag an artist with one or more user supplied tags.
  ///
  /// https://www.last.fm/api/show/artist.addTags
  Future<bool> addTags({
    @required String artist,
    @required List<String> tags,
  }) async {
    if (!_api.isAuth) {
      return Future.error(ScrobblenautException(
          description: "You can't use this method unless you Authenticate."));
    }

    if (tags.length > 10) {
      return Future.error(ScrobblenautException(
          description: "You've supplied more than 10 tags."));
    }

    final parameters = {
      'artist': artist,
      'tags': generateStringFromList(tags),
    };

    final request =
        Request(api: _api, method: 'artist.addTags', parameters: parameters)
          ..signRequest();

    final response =
        PostResponseHelper.parse(await request.send(mode: RequestMode.POST));

    if (response.status) {
      return true;
    } else {
      return false;
    }
  }

  /// Use the last.fm corrections data to check whether the supplied artist has
  /// a correction to a canonical artist
  ///
  /// https://www.last.fm/api/show/artist.getCorrection
  Future<List<Artist>> getCorrection({
    @required String artist,
  }) async {
    final parameters = {
      'artist': artist,
    };

    final request = Request(
        api: _api, method: 'artist.getCorrection', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final corrections = response['corrections'];

    if (corrections is List) {
      return List.generate(
          corrections.length,
          (i) => Artist.fromJson(
              response['corrections']['correction']['artist'][i]));
    }

    // A list of a single correction.
    return [Artist.fromJson(corrections['correction']['artist'])];
  }

  /// Get the metadata for an artist. Includes biography, truncated at 300 characters.
  ///
  /// https://www.last.fm/api/show/artist.getInfo
  Future<Artist> getInfo({
    String artist,
    String mbid,
    String username,
    Language lang = Language.en,
    bool autoCorrect = false,
  }) async {
    if (artist == null && mbid == null) {
      return Future.error(ScrobblenautException(
          description: 'This method requires at least artist or mbid.'));
    }

    final parameters = {
      'artist': artist,
      'mbid': mbid,
      'username': username,
      'lang': lang?.code,
      'autocorrect': (autoCorrect ? 1 : 0),
    };

    final request =
        Request(api: _api, method: 'artist.getInfo', parameters: parameters);

    return (Artist.fromJson(
        (await request.send(mode: RequestMode.GET))['artist']));
  }

  /// Get all the artists similar to this artist.
  ///
  /// https://www.last.fm/api/show/artist.getSimilar
  Future<List<Artist>> getSimilar({
    String artist,
    String mbid,
    int limit,
    bool autoCorrect = false,
  }) async {
    if (artist == null && mbid == null) {
      return Future.error(ScrobblenautException(
          description: 'This method requires at least artist or mbid.'));
    }

    final parameters = {
      'artist': artist,
      'mbid': mbid,
      'limit': limit,
      'autocorrect': (autoCorrect ? 1 : 0),
    };

    final request =
        Request(api: _api, method: 'artist.getSimilar', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final similarArtists = response['similarartists']['artist'];

    return similarArtists == null
        ? null
        : List.generate((similarArtists as List).length,
            (i) => Artist.fromJson(similarArtists[i]));
  }

  /// Get the tags applied by an individual user to an artist on Last.fm.
  /// If accessed as an authenticated service /and/ you don't supply
  /// a user parameter then this service will return tags
  /// for the authenticated user.
  /// To retrieve the list of top tags applied to an artist
  /// by all users use artist.getTopTags.
  ///
  /// https://www.last.fm/api/show/artist.getTags
  Future<List<Tag>> getTags({
    String artist,
    String mbid,
    String user,
    bool autoCorrect = false,
  }) async {
    if (artist == null && mbid == null) {
      return Future.error(ScrobblenautException(
          description: 'This method requires at least artist or mbid.'));
    }

    if (!_api.isAuth && user == null) {
      return Future.error(ScrobblenautException(
          description: "You're not authenticated, you must use user."));
    }

    final parameters = {
      'artist': artist,
      'mbid': mbid,
      'user': user,
      'autocorrect': (autoCorrect ? 1 : 0),
    };

    final request =
        Request(api: _api, method: 'artist.getTags', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final tags = response['tags']['tag'];

    return tags == null
        ? null
        : List.generate((tags as List).length, (i) => Tag.fromJson(tags[i]));
  }

  /// Get the top albums for an artist on Last.fm, ordered by popularity.
  ///
  /// https://www.last.fm/api/show/artist.getTopAlbums
  Future<List<Album>> getTopAlbums({
    String artist,
    String mbid,
    int page,
    int limit = 50,
  }) async {
    if (artist == null && mbid == null) {
      return Future.error(ScrobblenautException(
          description: 'This method requires at least artist or mbid.'));
    }

    final parameters = {
      'artist': artist,
      'mbid': mbid,
      'page': page,
      'limit': limit,
    };

    final request = Request(
        api: _api, method: 'artist.getTopAlbums', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final topAlbums = response['topalbums']['album'];

    return topAlbums == null
        ? null
        : List.generate(
            (topAlbums as List).length, (i) => Album.fromJson(topAlbums[i]));
  }

  /// Get the top tags for an artist on Last.fm, ordered by popularity.
  ///
  /// https://www.last.fm/api/show/artist.getTopTags
  Future<dynamic> getTopTags({
    String artist,
    String mbid,
    bool autoCorrect = false,
  }) async {
    if (artist == null && mbid == null) {
      return Future.error(ScrobblenautException(
          description: 'This method requires at least artist or mbid.'));
    }
    final parameters = {
      'artist': artist,
      'mbid': mbid,
      'autocorrect': (autoCorrect ? 1 : 0),
    };

    final request =
        Request(api: _api, method: 'artist.getTopTags', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final topTags = response['toptags']['tag'];

    return topTags == null
        ? null
        : List.generate(
            (topTags as List).length, (i) => Tag.fromJson(topTags[i]));
  }

  /// Get the top tracks by an artist on Last.fm, ordered by popularity.
  ///
  /// https://www.last.fm/api/show/artist.getTopTracks
  Future<List<Track>> getTopTracks({
    String artist,
    String mbid,
    int page,
    int limit = 50,
    bool autoCorrect = false,
  }) async {
    if (artist == null && mbid == null) {
      return Future.error(ScrobblenautException(
          description: 'This method requires at least artist or mbid.'));
    }

    final parameters = {
      'artist': artist,
      'mbid': mbid,
      'page': page,
      'limit': limit,
      'autocorrect': (autoCorrect ? 1 : 0),
    };

    final request = Request(
        api: _api, method: 'artist.getTopTracks', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final topTracks = response['toptracks']['track'];

    return topTracks == null
        ? null
        : List.generate(
            (topTracks as List).length, (i) => Track.fromJson(topTracks[i]));
  }

  /// Remove a user's tag from an artist.
  ///
  /// https://www.last.fm/api/show/artist.removeTag
  Future<bool> removeTag({
    @required String artist,
    @required String tag,
  }) async {
    if (!_api.isAuth) {
      return Future.error(ScrobblenautException(
          description: "You can't use this method unless you Authenticate."));
    }

    final parameters = {
      'artist': artist,
      'tag': tag,
    };

    final request =
        Request(api: _api, method: 'artist.removeTag', parameters: parameters)
          ..signRequest();

    final response =
        PostResponseHelper.parse(await request.send(mode: RequestMode.POST));

    if (response.status) {
      return true;
    } else {
      return false;
    }
  }

  /// Search for an artist by name. Returns artist matches sorted by relevance.
  ///
  /// https://www.last.fm/api/show/artist.search.
  Future<ArtistSearchResults> search({
    @required String artist,
    int page,
    int limit,
  }) async {
    final parameters = {
      'artist': artist,
      'page': page,
      'limit': limit,
    };

    final request =
        Request(api: _api, method: 'artist.search', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    return ArtistSearchResults.fromJson(response['results']);
  }
}
