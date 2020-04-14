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

  print('############################tag.getInfo#############################');

  // tag.getInfo
  final tagGetInfo = (await scrobblenaut.tag.getInfo(tag: 'anime'));
  print('Tag Name: ${tagGetInfo.name} | Tag total: ${tagGetInfo.total}');

  print('############################tag.getSimilar##########################');

  // tag.getSimilar
  (await scrobblenaut.tag.getSimilar(tag: 'anime'))?.forEach((Tag tag) {
    print('Similar Tag Name: ${tag.name}');
  });

  print('##########################tag.getTopAlbums##########################');

  // tag.getTopAlbums
  (await scrobblenaut.tag.getTopAlbums(tag: 'anime'))?.forEach((Album album) {
    print('Top Album Name: ${album.name}');
  });

  print('########################tag.getTopArtists###########################');

  // tag.getTopArtists
  (await scrobblenaut.tag.getTopArtists(tag: 'anime'))
      ?.forEach((Artist artist) {
    print('Top Artist Name: ${artist.name}');
  });

  print('##########################tag.getTopTags############################');

  // tag.getTopTags
  (await scrobblenaut.tag.getTopTags())?.forEach((Tag tag) {
    print('Top Tag Name: ${tag.name}');
  });

  print('########################tag.getTopTracks############################');

  // tag.getTopTracks
  (await scrobblenaut.tag.getTopTracks(tag: 'anime'))?.forEach((Track track) {
    print('Top Track Name: ${track.name} | Top Track URL: ${track.url}');
  });

  print('#######################tag.getWeeklyChartList#######################');

  // tag.getWeeklyChartList
  (await scrobblenaut.tag.getWeeklyChartList(tag: 'anime'))
      ?.forEach((Chart chart) {
    print('Chart FromDate: ${chart.fromDate} | Chart ToDate: ${chart.toDate}');
  });

  print('####################################################################');
}
