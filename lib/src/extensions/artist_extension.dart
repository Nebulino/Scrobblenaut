//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/lastfm_methods.dart';
import 'package:scrobblenaut/scrobblenaut.dart';

/// Give the ability of applying [ArtistMethods] on [Artist].
extension ArtistExtension on Artist {
  ArtistMethods get _artistMethods => Scrobblenaut.instance.artist;

  /// [ArtistMethods.addTags]
  Future<bool> addTags({
    required List<String> tags,
  }) async {
    return await _artistMethods.addTags(
      artist: name ?? '',
      tags: tags,
    );
  }

  /// [ArtistMethods.getCorrection]
  Future<List<Artist>> getCorrection() async {
    return await _artistMethods.getCorrection(
      artist: name ?? '',
    );
  }

  /// [ArtistMethods.getInfo]
  Future<Artist> getInfo({
    String? username,
    Language language = Language.en,
    bool autoCorrect = false,
  }) async {
    return await _artistMethods.getInfo(
      artist: name,
      mbid: mbid,
      username: username,
      language: language,
      autoCorrect: autoCorrect,
    );
  }

  /// [ArtistMethods.getSimilar]
  Future<List<Artist>?> getSimilar({
    int? limit,
    bool autoCorrect = false,
  }) async {
    return await _artistMethods.getSimilar(
      artist: name,
      mbid: mbid,
      limit: limit,
      autoCorrect: autoCorrect,
    );
  }

  /// [ArtistMethods.getTags]
  Future<List<Tag>?> getTags({
    String? user,
    bool autoCorrect = false,
  }) async {
    return await _artistMethods.getTags(
      artist: name,
      mbid: mbid,
      user: user,
      autoCorrect: autoCorrect,
    );
  }

  /// [ArtistMethods.getTopAlbums]
  Future<List<Album>?> getTopAlbums({
    int page = 1,
    int limit = 50,
  }) async {
    return await _artistMethods.getTopAlbums(
      artist: name,
      mbid: mbid,
      page: page,
      limit: limit,
    );
  }

  /// [ArtistMethods.getTopTags]
  Future<List<Tag>?> getTopTags({
    bool autoCorrect = false,
  }) async {
    return await _artistMethods.getTopTags(
      artist: name,
      mbid: mbid,
      autoCorrect: autoCorrect,
    );
  }

  /// [ArtistMethods.getTopTracks]
  Future<List<Track>?> getTopTracks({
    int page = 1,
    int limit = 50,
    bool autoCorrect = false,
  }) async {
    return await _artistMethods.getTopTracks(
      artist: name,
      mbid: mbid,
      page: page,
      limit: limit,
      autoCorrect: autoCorrect,
    );
  }

  /// [ArtistMethods.removeTag]
  Future<bool> removeTag({
    required String tag,
  }) async {
    return await _artistMethods.removeTag(
      artist: name ?? '',
      tag: tag,
    );
  }

  /// [ArtistMethods.search]
  Future<ArtistSearchResults> search({
    int page = 1,
    int limit = 30,
  }) async {
    return await _artistMethods.search(
      artist: name ?? '',
      page: page,
      limit: limit,
    );
  }
}
