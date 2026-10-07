//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/src/core/session_key_generator.dart';
import 'package:scrobblenaut/src/tools/spaceship.dart';

/// It stores useful information and a client for HTTP requests.
class LastFM {
  SpaceShip _client;

  final String _apiKey;
  final String? _apiSecret;
  final String? _sessionKey;
  final String? _username;
  final String? _passwordHash;
  final bool _isAuth;

  /// Default constructor.
  LastFM._(
    this._apiKey,
    this._apiSecret,
    this._sessionKey,
    this._username,
    this._passwordHash,
    this._isAuth,
  ) : _client = SpaceShip(baseUrl: 'https://ws.audioscrobbler.com/2.0/');

  /// Default kind of API usage.
  /// You can use methods that does not required authentication.
  LastFM.noAuth({required String apiKey, String? proxy})
    : this._(apiKey, null, null, null, null, false);

  /// It creates a LastFM object using an existing [sessionKey].
  LastFM.withSessionKey({
    required String apiKey,
    required String apiSecret,
    required String sessionKey,
    String? username,
    String? proxy,
  }) : this._(apiKey, apiSecret, sessionKey, username, null, true);

  /// It creates a LastFM object with auth mode using [username] and [password].
  /// Uses [auth.getMobileSession] via POST.
  static Future<LastFM> authenticate({
    required String apiKey,
    required String apiSecret,
    required String username,
    required String password,
    String? sessionKey,
    String? proxy,
  }) async {
    if (sessionKey != null) {
      return LastFM.withSessionKey(
        apiKey: apiKey,
        apiSecret: apiSecret,
        sessionKey: sessionKey,
        username: username,
      );
    }

    final session = await SessionKeyGenerator(
      LastFM._(apiKey, apiSecret, null, null, null, false),
    ).getMobileSessionKey(username: username, password: password);

    return LastFM._(
      apiKey,
      apiSecret,
      session.sessionKey,
      session.name ?? username,
      null,
      true,
    );
  }

  /// It creates a LastFM object from an authorized web/desktop [token].
  /// Uses [auth.getSession].
  static Future<LastFM> authenticateWithToken({
    required String apiKey,
    required String apiSecret,
    required String token,
    String? proxy,
  }) async {
    final session = await SessionKeyGenerator(
      LastFM._(apiKey, apiSecret, null, null, null, false),
    ).getSessionWithToken(token: token);

    return LastFM._(
      apiKey,
      apiSecret,
      session.sessionKey,
      session.name,
      null,
      true,
    );
  }

  @Deprecated(
    'Last.fm no longer supports passwordHash/authToken. '
    'Use LastFM.authenticate or LastFM.withSessionKey instead.',
  )
  static Future<LastFM> authenticateWithPasswordHash({
    required String apiKey,
    required String apiSecret,
    required String username,
    required String passwordHash,
    String? sessionKey,
    String? proxy,
  }) async {
    if (sessionKey != null) {
      return LastFM.withSessionKey(
        apiKey: apiKey,
        apiSecret: apiSecret,
        sessionKey: sessionKey,
        username: username,
      );
    }
    throw UnsupportedError(
      'Last.fm removed support for authToken/passwordHash in auth.getMobileSession. '
      'Please use LastFM.authenticate(password: ...) or LastFM.withSessionKey(...).',
    );
  }

  /// It returns the created client.
  SpaceShip get client => _client;

  /// It returns the apiKey used.
  String get apiKey => _apiKey;

  /// It returns the apiSecret used.
  String? get apiSecret => _apiSecret;

  /// It returns, if authenticated, the session key.
  String? get sessionKey => _sessionKey;

  /// It returns, if authenticated, the username.
  String? get username => _username;

  /// It returns, if authenticated, the passwordHash.
  String? get passwordHash => _passwordHash;

  /// True if authenticated.
  bool get isAuth => _isAuth;
}
