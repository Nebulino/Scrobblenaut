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

  final tagInstance = (await scrobblenaut.tag.getInfo(tag: 'anime'));

  print('############################tag.getInfo#############################');

  // tag.getInfo
  final tagGetInfo = (await tagInstance.getInfo());
  print('Tag Name: ${tagGetInfo.name} | Tag total: ${tagGetInfo.total}');

  print('############################tag.getSimilar##########################');

  // tag.getSimilar
  (await tagInstance.getSimilar())?.forEach((Tag tag) {
    print('Similar Tag Name: ${tag.name}');
  });

  print('##########################tag.getTopAlbums##########################');

  // tag.getTopAlbums
  (await tagInstance.getTopAlbums())?.forEach((Album album) {
    print('Top Album Name: ${album.name}');
  });

  print('########################tag.getTopArtists###########################');

  // tag.getTopArtists
  (await tagInstance.getTopArtists())?.forEach((Artist artist) {
    print('Top Artist Name: ${artist.name}');
  });

  print('########################tag.getTopTracks############################');

  // tag.getTopTracks
  (await tagInstance.getTopTracks())?.forEach((Track track) {
    print('Top Track Name: ${track.name} | Top Track URL: ${track.url}');
  });

  print('#######################tag.getWeeklyChartList#######################');

  // tag.getWeeklyChartList
  (await tagInstance.getWeeklyChartList())?.forEach((Chart chart) {
    print('Chart FromDate: ${chart.fromDate} | Chart ToDate: ${chart.toDate}');
  });

  print('####################################################################');
}
