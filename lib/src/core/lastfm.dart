//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:meta/meta.dart';
import 'package:scrobblenaut/src/core/session_key_generator.dart';
import 'package:scrobblenaut/src/helpers/utils.dart';
import 'package:scrobblenaut/src/tools/spaceship.dart';

/// It stores useful information and a client for HTTP requests.
class LastFM {
  SpaceShip _client;

  final String _apiKey;
  final String _apiSecret;
  final String _sessionKey;
  final String _username;
  final String _passwordHash;
  final bool _isAuth;

  /// Default constructor.
  LastFM._(this._apiKey, this._apiSecret, this._sessionKey, this._username,
      this._passwordHash, this._isAuth) {
    _client = SpaceShip(
      base_url: 'https://ws.audioscrobbler.com/2.0/',
    );
  }

  /// Default kind of API usage.
  /// You can use methods that does not required authentication.
  LastFM.noAuth({
    @required String apiKey,
    String proxy,
  }) : this._(apiKey, null, null, null, null, false);

  /// It creates a LastFM object with auth mode.
  static Future<LastFM> authenticate({
    @required String apiKey,
    @required String apiSecret,
    @required String username,
    @required String password,
    String sessionKey,
    String proxy,
  }) async {
    final passwordHash = generateMD5(password);

    if ((apiKey != null && apiSecret != null) &&
        sessionKey == null &&
        (username != null && password != null)) {
      final session = await SessionKeyGenerator(
        LastFM._(
          apiKey,
          apiSecret,
          null,
          null,
          null,
          false,
        ),
      ).getSessionKey(
        username: username,
        passwordHash: passwordHash,
      );

      return LastFM._(
        apiKey,
        apiSecret,
        session.sessionKey,
        username,
        passwordHash,
        true,
      );
    } else {
      return LastFM._(
        apiKey,
        apiSecret,
        sessionKey,
        username,
        passwordHash,
        true,
      );
    }
  }

  static Future<LastFM> authenticateWithPasswordHash({
    @required String apiKey,
    @required String apiSecret,
    @required String username,
    @required String passwordHash,
    String sessionKey,
  }) async {
    if ((apiKey != null && apiSecret != null) &&
        sessionKey == null &&
        (username != null && passwordHash != null)) {
      final session = await SessionKeyGenerator(
        LastFM._(
          apiKey,
          apiSecret,
          null,
          null,
          null,
          false,
        ),
      ).getSessionKey(
        username: username,
        passwordHash: passwordHash,
      );

      return LastFM._(
        apiKey,
        apiSecret,
        session.sessionKey,
        username,
        passwordHash,
        true,
      );
    } else {
      return LastFM._(
        apiKey,
        apiSecret,
        sessionKey,
        username,
        passwordHash,
        true,
      );
    }
  }

  /// It returns the created client.
  SpaceShip get client => _client;

  /// It returns the apiKey used.
  String get apiKey => _apiKey;

  /// It returns the apiSecret used.
  String get apiSecret => _apiSecret;

  /// It returns, if authenticated, the session key.
  String get sessionKey => _sessionKey;

  /// It returns, if authenticated, the username.
  String get username => _username;

  /// It returns, if authenticated, the passwordHash.
  String get passwordHash => _passwordHash;

  /// True if authenticated.
  bool get isAuth => _isAuth;
}
