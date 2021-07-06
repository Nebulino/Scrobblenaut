//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/lastfm_methods.dart';
import 'package:scrobblenaut/scrobblenaut.dart';

/// Give the ability of applying [TagMethods] on [Tag].
extension TagExtension on Tag {
  TagMethods get _tagMethods => Scrobblenaut.instance.tag;

  /// [TagMethods.getInfo]
  Future<Tag> getInfo({
    Language language = Language.en,
  }) async {
    return await _tagMethods.getInfo(
      tag: name,
      language: language,
    );
  }

  /// [TagMethods.getSimilar]
  Future<List<Tag>?> getSimilar() async {
    return await _tagMethods.getSimilar(
      tag: name,
    );
  }

  /// [TagMethods.getTopAlbums]
  Future<List<Album>?> getTopAlbums({
    int page = 1,
    int limit = 50,
  }) async {
    return await _tagMethods.getTopAlbums(
      tag: name,
      page: page,
      limit: limit,
    );
  }

  /// [TagMethods.getTopArtists]
  Future<List<Artist>?> getTopArtists({
    int page = 1,
    int limit = 50,
  }) async {
    return await _tagMethods.getTopArtists(
      tag: name,
      page: page,
      limit: limit,
    );
  }

  /// [TagMethods.getTopTracks]
  Future<List<Track>?> getTopTracks({
    int page = 1,
    int limit = 50,
  }) async {
    return await _tagMethods.getTopTracks(
      tag: name,
      page: page,
      limit: limit,
    );
  }

  /// [TagMethods.getWeeklyChartList]
  Future<List<Chart>?> getWeeklyChartList() async {
    return await _tagMethods.getWeeklyChartList(
      tag: name,
    );
  }
}
