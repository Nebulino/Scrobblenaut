//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:meta/meta.dart';
import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';
import 'package:scrobblenaut/src/core/request.dart';
import 'package:scrobblenaut/src/core/request_mode.dart';
import 'package:scrobblenaut/src/exceptions/scrobblenaut_exception.dart';
import 'package:scrobblenaut/src/helpers/post_response_helper.dart';
import 'package:scrobblenaut/src/helpers/utils.dart';

/// This contains all the methods about an [Album].
class AlbumMethods {
  final LastFM _api;

  AlbumMethods(this._api);

  /// Tag an album using a list of user supplied tags.
  ///
  /// https://www.last.fm/api/show/album.addTags
  Future<bool> addTags({
    @required String artist,
    @required String album,
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
      'album': album,
      'tags': generateStringFromList(tags),
    };

    final request =
        Request(api: _api, method: 'album.addTags', parameters: parameters)
          ..signRequest();

    final response =
        PostResponseHelper.parse(await request.send(mode: RequestMode.POST));

    if (response.status) {
      return true;
    } else {
      return false;
    }
  }

  /// Get the metadata and tracklist for an album on Last.fm using the album
  /// name or a musicbrainz id.
  ///
  /// https://www.last.fm/api/show/album.getInfo
  Future<Album> getInfo({
    String artist,
    String album,
    String mbid,
    bool autoCorrect = false,
    String username,
    Language language = Language.en,
  }) async {
    if ((album == null || artist == null) && mbid == null) {
      return Future.error(ScrobblenautException(
          description: 'At least mbid is required. '
              'Can be used also album and artist.'));
    }

    final parameters = {
      'artist': artist,
      'album': album,
      'mbid': mbid,
      'autocorrect': (autoCorrect ? 1 : 0),
      'username': username,
      'lang': language?.code,
    };

    final request =
        Request(api: _api, method: 'album.getInfo', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    // This operation is necessary because the tracks have different duration
    // from [track.getInfo].
    var albumInfo = Album.fromJson(response['album']);
    albumInfo.tracks?.forEach((Track track) {
      track.duration = track.duration * 1000;
    });

    return albumInfo;
  }

  /// Get the tags applied by an individual user to an album on Last.fm.
  /// To retrieve the list of top tags applied to an album by all users use
  /// album.getTopTags.
  ///
  /// https://www.last.fm/api/show/album.getTags
  Future<List<Tag>> getTags({
    String artist,
    String album,
    String mbid,
    bool autoCorrect = false,
    String user,
  }) async {
    if ((album == null || artist == null) && mbid == null) {
      return Future.error(ScrobblenautException(
          description: 'At least mbid is required. '
              'Can be used also album and artist.'));
    }

    if (!_api.isAuth && user == null) {
      return Future.error(ScrobblenautException(
          description: "You're not authenticated, you must use user."));
    }

    final parameters = {
      'artist': artist,
      'album': album,
      'mbid': mbid,
      'user': user,
      'autocorrect': (autoCorrect ? 1 : 0),
    };

    final request =
        Request(api: _api, method: 'album.getTags', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final tags = response['tags']['tag'];

    return tags == null
        ? null
        : List.generate((tags as List).length, (i) => Tag.fromJson(tags[i]));
  }

  /// Get the top tags for an album on Last.fm, ordered by popularity.
  ///
  /// https://www.last.fm/api/show/album.getTopTags
  Future<List<Tag>> getTopTags({
    String artist,
    String album,
    String mbid,
    bool autoCorrect = false,
  }) async {
    if ((album == null || artist == null) && mbid == null) {
      return Future.error(ScrobblenautException(
          description: 'At least mbid is required. '
              'Can be used also album and artist.'));
    }

    final parameters = {
      'artist': artist,
      'album': album,
      'mbid': mbid,
      'autocorrect': (autoCorrect ? 1 : 0),
    };

    final request =
        Request(api: _api, method: 'album.getTopTags', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final tags = response['toptags']['tag'];

    return tags == null
        ? null
        : List.generate((tags as List).length, (i) => Tag.fromJson(tags[i]));
  }

  /// Remove a user's tag from an album.
  ///
  /// https://www.last.fm/api/show/album.removeTag
  Future<bool> removeTag({
    @required String artist,
    @required String album,
    @required String tag,
  }) async {
    if (!_api.isAuth) {
      return Future.error(ScrobblenautException(
          description: "You can't use this method unless you Authenticate."));
    }

    final parameters = {
      'artist': artist,
      'album': album,
      'tag': tag,
    };

    final request =
        Request(api: _api, method: 'album.removeTag', parameters: parameters)
          ..signRequest();

    final response =
        PostResponseHelper.parse(await request.send(mode: RequestMode.POST));

    if (response.status) {
      return true;
    } else {
      return false;
    }
  }

  /// Search for an album by name. Returns album matches sorted by relevance.
  ///
  /// https://www.last.fm/api/show/album.search
  Future<AlbumSearchResults> search({
    @required String album,
    int page = 1,
    int limit = 30,
  }) async {
    final parameters = {
      'album': album,
      'page': page,
      'limit': limit,
    };

    final request =
        Request(api: _api, method: 'album.search', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    return AlbumSearchResults.fromJson(response['results']);
  }
}
