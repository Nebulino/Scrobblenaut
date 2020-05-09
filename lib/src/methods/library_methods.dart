//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:meta/meta.dart';
import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';
import 'package:scrobblenaut/src/core/request.dart';
import 'package:scrobblenaut/src/core/request_mode.dart';

/// This contains all the methods about a [Library].
class LibraryMethods {
  final LastFM _api;

  LibraryMethods(this._api);

  /// A paginated list of all the artists in a user's library, with play counts
  /// and tag counts.
  ///
  /// https://www.last.fm/api/show/library.getArtists
  Future<List<Artist>> getArtists({
    @required String user,
    int limit = 50,
    int page,
  }) async {
    final parameters = {
      'user': user,
      'limit': limit,
      'page': page,
    };

    final request = Request(
        api: _api, method: 'library.getArtists', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final artists = response['artists']['artist'];

    return artists == null
        ? null
        : List.generate(
            (artists as List).length, (i) => Artist.fromJson(artists[i]));
  }
}
