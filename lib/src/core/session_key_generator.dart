//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';
import 'package:scrobblenaut/src/core/request.dart';
import 'package:scrobblenaut/src/core/request_mode.dart';

/// It helps generating a session key.
///
///  A session key's lifetime is infinite, unless the user revokes the rights
///  of the given API Key.
class SessionKeyGenerator {
  final LastFM _api;

  SessionKeyGenerator(this._api);

  /// It generates a SessionKey from a [username] and a [password].
  /// It uses [auth.getMobileSession] via POST.
  ///
  /// [auth.getMobileSession]: https://www.last.fm/api/show/auth.getMobileSession
  Future<Session> getMobileSessionKey({
    required String username,
    required String password,
  }) async {
    final parameters = {'username': username, 'password': password};

    final request = Request(
      api: _api,
      method: 'auth.getMobileSession',
      parameters: parameters,
    );

    request.signRequest();

    final response = await request.send(mode: RequestMode.POST);

    return Session.fromJson(response['session']);
  }

  /// Alias for [getMobileSessionKey].
  Future<Session> getSessionKey({
    required String username,
    required String password,
  }) => getMobileSessionKey(username: username, password: password);

  /// It generates a SessionKey from an authorized web/desktop [token].
  /// It uses [auth.getSession]
  ///
  /// [auth.getSession]: https://www.last.fm/api/show/auth.getSession
  Future<Session> getSessionWithToken({required String token}) async {
    final parameters = {'token': token};

    final request = Request(
      api: _api,
      method: 'auth.getSession',
      parameters: parameters,
    );

    request.signRequest();

    final response = await request.send(mode: RequestMode.GET);

    return Session.fromJson(response['session']);
  }

  /// It fetches an unauthorized request token.
  /// It uses [auth.getToken]
  ///
  /// [auth.getToken]: https://www.last.fm/api/show/auth.getToken
  Future<String> getToken() async {
    final request = Request(api: _api, method: 'auth.getToken');

    request.signRequest();

    final response = await request.send(mode: RequestMode.GET);

    return response['token'] as String;
  }
}
