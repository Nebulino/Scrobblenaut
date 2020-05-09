//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/scrobblenaut.dart';
import 'package:scrobblenaut/scrobblenaut_helpers.dart';

import '../api_values.dart';

// Just an example of use.
void main() async {
  final lastFMAuth = await LastFM.authenticate(
    apiKey: APIValues.API,
    apiSecret: APIValues.secret,
    username: APIValues.username,
    password: APIValues.password,
    sessionKey: APIValues.sessionKey,
  );

  // final lastFMnoAuth = await LastFM.noAuth(apiKey: APIValues.API);
  // When used a LastFM in noAuth mode, it raises an exception.

  final scrobblenaut = Scrobblenaut(lastFM: lastFMAuth);

  print('Single scrobble.');

  final response = await scrobblenaut.track.scrobble(
      track: 'Beautiful Moonlight',
      artist: 'QU4RTZ',
      timestamp: DateTime.now());
  // YAY. IT WORKS!

  response.scrobbleResponses?.forEach((ScrobbledTrack scrobbledTrack) {
    print('Scrobbled Title: ${scrobbledTrack.track}');
  });

  print('Another scrobble method.');

  final scrobble = Scrobble(track: 'Sunlight', artist: 'PLEEG');

  final anotherResponse =
      await scrobblenaut.track.scrobbleFromObject(scrobble: scrobble);

  anotherResponse.scrobbleResponses?.forEach((ScrobbledTrack scrobbledTrack) {
    print('Scrobbled Title: ${scrobbledTrack.track}');
  });

  print('Multiple scrobble.');
  final scrobble2 = Scrobble(track: 'Missing', artist: 'HoneyComeBear');

  final lastResponse =
      await scrobblenaut.track.multiScrobble(scrobbleList: [scrobble, scrobble2]);

  lastResponse.scrobbleResponses?.forEach((ScrobbledTrack scrobbledTrack) {
    print('Scrobbled Title: ${scrobbledTrack.track}');
  });

  // final response = await scrobblenaut.track.scrobble(scrobbleList);
}
