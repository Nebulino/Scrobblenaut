/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:scrobblenaut/scrobblenaut.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';

import 'api_values.dart';

// Just an example of use.
void main() async {
  final lastFM = await LastFM.authenticate(
    apiKey: APIValues.API,
    apiSecret: APIValues.secret,
    username: APIValues.username,
    password: APIValues.password,
  );

  final scrobblenaut = Scrobblenaut(lastFM: lastFM);

  print(lastFM.sessionKey);
}
