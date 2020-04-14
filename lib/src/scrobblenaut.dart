/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:meta/meta.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';
import 'package:scrobblenaut/src/methods/album_methods.dart';
import 'package:scrobblenaut/src/methods/artist_methods.dart';
import 'package:scrobblenaut/src/methods/chart_methods.dart';

/// This connects all the various methods [LastFM] can provide.
///
/// [LastFM]: https://www.last.fm/api/
class Scrobblenaut {
  final LastFM _api;

  AlbumMethods _albumMethods;
  ArtistMethods _artistMethods;
  ChartMethods _chartMethods;

  Scrobblenaut._(this._api) {
    _albumMethods = AlbumMethods(_api);
    _artistMethods = ArtistMethods(_api);
    _chartMethods = ChartMethods(_api);
  }

  /// It creates a Scrobblenaut Session using a LastFM object.
  Scrobblenaut({@required LastFM lastFM}) : this._(lastFM);

  /// It returns the LastFM object created.
  LastFM get api => _api;

  /// Use this to use [Album]'s methods.
  AlbumMethods get album => _albumMethods;

  /// Use this to use [Artist]'s methods.
  ArtistMethods get artist => _artistMethods;

  /// Use this to use [Chart]'s methods.
  ChartMethods get chart => _chartMethods;
}
