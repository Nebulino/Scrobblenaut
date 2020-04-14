/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:meta/meta.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';
import 'package:scrobblenaut/src/methods/album_methods.dart';
import 'package:scrobblenaut/src/methods/artist_methods.dart';
import 'package:scrobblenaut/src/methods/chart_methods.dart';
import 'package:scrobblenaut/src/methods/geo_methods.dart';
import 'package:scrobblenaut/src/methods/library_methods.dart';
import 'package:scrobblenaut/src/methods/tag_methods.dart';
import 'package:scrobblenaut/src/methods/track_methods.dart';

/// This connects all the various methods [LastFM] can provide.
///
/// [LastFM]: https://www.last.fm/api/
class Scrobblenaut {
  final LastFM _api;

  AlbumMethods _albumMethods;
  ArtistMethods _artistMethods;
  ChartMethods _chartMethods;
  GeoMethods _geoMethods;
  LibraryMethods _libraryMethods;
  TagMethods _tagMethods;
  TrackMethods _trackMethods;

  Scrobblenaut._(this._api) {
    _albumMethods = AlbumMethods(_api);
    _artistMethods = ArtistMethods(_api);
    _chartMethods = ChartMethods(_api);
    _geoMethods = GeoMethods(_api);
    _libraryMethods = LibraryMethods(_api);
    _tagMethods = TagMethods(_api);
    _trackMethods = TrackMethods(_api);
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

  /// Use this to use [Geo]'s methods.
  GeoMethods get geo => _geoMethods;

  /// Use this to use [Library]'s methods.
  LibraryMethods get library => _libraryMethods;

  /// Use this to use [Tag]'s methods.
  TagMethods get tag => _tagMethods;

  /// Use this to use [Track]'s methods.
  TrackMethods get track => _trackMethods;
}
