/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/scrobblenaut.dart';

import 'api_values.dart';

// Just an example of use.
void main() async {
  print('####################################################################');

  final lastFMAuth = await LastFM.authenticate(
    apiKey: APIValues.API,
    apiSecret: APIValues.secret,
    username: APIValues.username,
    password: APIValues.password,
    sessionKey: APIValues.sessionKey,
  );

  final scrobblenaut = Scrobblenaut(lastFM: lastFMAuth);

  print('#########################geo.getTopArtists##########################');

  // geo.getTopArtists
  (await scrobblenaut.geo.getTopArtists(country: 'canada'))
      ?.forEach((Artist artist) {
    print('Top Artist Name: ${artist.name} | Top Artist URL : ${artist.url}');
  });

  print('#########################geo.getTopTracks###########################');

  // geo.getTopTracks
  (await scrobblenaut.geo.getTopTracks(country: 'canada'))
      ?.forEach((Track track) {
    print('Top Track Name: ${track.name} | Top Track URL : ${track.url}');
  });

  print('####################################################################');
}
