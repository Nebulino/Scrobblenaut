//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/lastfm_methods.dart';
import 'package:scrobblenaut/scrobblenaut.dart';

/// Give the ability of applying [AlbumMethods] on [Album].
extension AlbumExtension on Album {
  AlbumMethods get _albumMethods => Scrobblenaut.instance.album;

  /// [AlbumMethods.addTags]
  Future<bool> addTags({
    required List<String> tags,
  }) async {
    return await _albumMethods.addTags(
        album: name ?? '', artist: artist?.name ?? '', tags: tags);
  }

  /// [AlbumMethods.getInfo]
  Future<Album> getInfo({
    bool autoCorrect = false,
    String? username,
    Language language = Language.en,
  }) async {
    if (username == null && Scrobblenaut.instance.api.isAuth) {
      username = Scrobblenaut.instance.api.username;
    }
    return await _albumMethods.getInfo(
      artist: artist?.name,
      album: name,
      autoCorrect: autoCorrect,
      username: username,
      language: language,
    );
  }

  /// [AlbumMethods.getTags]
  Future<List<Tag>?> getTags({
    bool autoCorrect = false,
    String? user,
  }) async {
    return await _albumMethods.getTags(
      artist: artist?.name,
      album: name,
      mbid: mbid,
      autoCorrect: autoCorrect,
      user: user,
    );
  }

  /// [AlbumMethods.getTopTags]
  Future<List<Tag>?> getTopTags({
    bool autoCorrect = false,
  }) async {
    return await _albumMethods.getTopTags(
        artist: artist?.name,
        album: name,
        mbid: mbid,
        autoCorrect: autoCorrect);
  }

  /// [AlbumMethods.removeTag]
  Future<bool> removeTag({
    required String tag,
  }) async {
    return await _albumMethods.removeTag(
      artist: artist?.name ?? '',
      album: name ?? '',
      tag: tag,
    );
  }

  /// [AlbumMethods.search]
  Future<AlbumSearchResults> search({
    int page = 1,
    int limit = 30,
  }) async {
    return await _albumMethods.search(
      album: name ?? '',
      page: page,
      limit: limit,
    );
  }
}
