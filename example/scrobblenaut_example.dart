//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/scrobblenaut.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';

import 'api_values.dart';

// Just an example of use.
void main() async {
  var lastFM = await LastFM.noAuth(
    apiKey: APIValues.API,
  );

  var scrobblenaut = Scrobblenaut(lastFM: lastFM);

  final albumGetInfo = (await scrobblenaut.album.getInfo(
    album: 'Your Name.',
    artist: 'RADWIMPS',
    username: 'nebulino',
    autoCorrect: true,
  ));

  print('Album Name: ${albumGetInfo.name} |'
      ' Album Artist: ${albumGetInfo.artist.name}');

  albumGetInfo.tracks?.forEach((Track track) {
    print('Track Title: ${track.name} | Track Duration: ${track.duration}');
  });

  lastFM = await LastFM.authenticate(
    apiKey: APIValues.API,
    apiSecret: APIValues.secret,
    username: APIValues.username,
    password: APIValues.password
  );

  scrobblenaut = Scrobblenaut(lastFM: lastFM);

  print(
    'Username: ${(await scrobblenaut.user.getInfo(
      user: APIValues.username,
    )).name}',
  );
}
