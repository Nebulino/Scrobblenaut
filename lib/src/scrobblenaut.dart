//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/lastfm_methods.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';

/// This connects all the various methods [LastFM] can provide.
///
/// [LastFM]: https://www.last.fm/api/
class Scrobblenaut {
  /// The Scrobblenaut instance.
  static late Scrobblenaut _instance;

  /// The [LastFM] object. Helps creating each methods.
  final LastFM _api;

  AlbumMethods _albumMethods;
  ArtistMethods _artistMethods;
  ChartMethods _chartMethods;
  GeoMethods _geoMethods;
  LibraryMethods _libraryMethods;
  TagMethods _tagMethods;
  TrackMethods _trackMethods;
  UserMethods _userMethods;

  Scrobblenaut._(this._api)
      : _albumMethods = AlbumMethods(_api),
        _artistMethods = ArtistMethods(_api),
        _chartMethods = ChartMethods(_api),
        _geoMethods = GeoMethods(_api),
        _libraryMethods = LibraryMethods(_api),
        _tagMethods = TagMethods(_api),
        _trackMethods = TrackMethods(_api),
        _userMethods = UserMethods(_api) {
    _instance = this;
  }

  // TODO: create a [User] if _api.isAuth

  /// It creates a Scrobblenaut Session using a LastFM object.
  Scrobblenaut({required LastFM lastFM}) : this._(lastFM);

  /// It returns the created instance.
  static Scrobblenaut get instance => _instance;

  /// It returns the LastFM object created.
  LastFM get api => _api;

  /// Use this to use [AlbumMethods].
  AlbumMethods get album => _albumMethods;

  /// Use this to use [ArtistMethods].
  ArtistMethods get artist => _artistMethods;

  /// Use this to use [ChartMethods].
  ChartMethods get chart => _chartMethods;

  /// Use this to use [GeoMethods].
  GeoMethods get geo => _geoMethods;

  /// Use this to use [LibraryMethods].
  LibraryMethods get library => _libraryMethods;

  /// Use this to use [TagMethods].
  TagMethods get tag => _tagMethods;

  /// Use this to use [TrackMethods].
  TrackMethods get track => _trackMethods;

  /// Use this to use [UserMethods].
  UserMethods get user => _userMethods;
}
