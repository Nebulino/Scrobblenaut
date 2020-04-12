/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:scrobblenaut/src/core/lastfm.dart';

/// This connects all the various methods [LastFM] can provide.
///
/// [LastFM]: https://www.last.fm/api/
class Scrobblenaut {
  LastFM _api;

  Scrobblenaut({
    String apiKey,
    String apiSecret,
    String sessionKey,
    String username,
    String password,
    String proxy,
  }) {
    _api = LastFM(
        api_key: apiKey,
        api_secret: apiSecret,
        session_key: sessionKey,
        proxy: proxy);
  }
}
