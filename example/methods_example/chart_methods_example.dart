//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/scrobblenaut.dart';

import '../api_values.dart';

// Just an example of use.
void main() async {
  print('####################################################################');

  final lastFMAuth = await LastFM.authenticate(
    apiKey: APIValues.api,
    apiSecret: APIValues.secret,
    username: APIValues.username,
    password: APIValues.password,
    sessionKey: APIValues.sessionKey,
  );

  final scrobblenaut = Scrobblenaut(lastFM: lastFMAuth);

  print('#######################chart.getTopArtists##########################');

  // chart.getTopArtists
  (await scrobblenaut.chart.getTopArtists())?.forEach((Artist artist) {
    print('Top Artist Name: ${artist.name} | Top Artist URL : ${artist.url}');
  });

  print('#######################chart.getTopTags#############################');

  // chart.getTopTags
  (await scrobblenaut.chart.getTopTags())?.forEach((Tag tag) {
    print('Top Tag Name: ${tag.name} | Top Tag URL : ${tag.url}');
  });

  print('#######################chart.getTopTracks###########################');

  // chart.getTopTracks
  (await scrobblenaut.chart.getTopTracks())?.forEach((Track track) {
    print('Top Track Name: ${track.name} | Top Track URL : ${track.url}');
  });

  print('####################################################################');
}
