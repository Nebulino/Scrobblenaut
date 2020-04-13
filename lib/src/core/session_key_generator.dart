/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:meta/meta.dart';
import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';
import 'package:scrobblenaut/src/core/request.dart';
import 'package:scrobblenaut/src/core/request_mode.dart';
import 'package:scrobblenaut/src/helpers/utils.dart';

/// It helps generating a session key.
///
///  A session key's lifetime is infinite, unless the user revokes the rights
///  of the given API Key.
class SessionKeyGenerator {
  final LastFM _api;

  SessionKeyGenerator(this._api);

  /// It generates a SessionKey from a [username] and a [passwordHash].
  /// It uses [auth.getMobileSession]
  ///
  /// [auth.getMobileSession]: https://www.last.fm/api/show/auth.getMobileSession
  Future<Session> getSessionKey(
      {@required String username, String passwordHash}) async {
    final parameters = {
      'username': username,
      'authToken': generateMD5(username + passwordHash)
    };

    final request = Request(
        api: _api, method: 'auth.getMobileSession', parameters: parameters);

    request.signRequest();

    final response = await request.send(mode: RequestMode.GET);

    return Session.fromJson(response['session']);
  }
}
