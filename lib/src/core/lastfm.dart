/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:meta/meta.dart';
import 'package:scrobblenaut/src/tools/spaceship.dart';

/// It stores useful information and a client for HTTP requests.
class LastFM {
  SpaceShip _client;

  String api_key;
  String api_secret;
  String session_key;
  String username;
  String password_hash;

  bool _isAuth;

  LastFM({
    @required this.api_key,
    @required this.api_secret,
    this.session_key,
    String proxy,
  }) {
    _client = SpaceShip(
      base_url: 'https://ws.audioscrobbler.com/2.0/',
      proxy: proxy,
    );
  }

  SpaceShip get client => _client;

  bool get isAuth => _isAuth;
}
