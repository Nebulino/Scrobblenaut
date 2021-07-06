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

  final lastFMAuth = LastFM.noAuth(
    apiKey: APIValues.API,
  );

  final scrobblenaut = Scrobblenaut(lastFM: lastFMAuth);

  print('#########################user.getFriends############################');

  // User.getFriends
  (await scrobblenaut.user.getFriends(user: 'nebulino'))?.forEach((User user) {
    print('Friend Name: ${user.name} | Friend URL: ${user.url}');
  });

  print('###########################user.getInfo#############################');

  // user.getInfo
  final userGetInfo = (await scrobblenaut.user.getInfo(user: 'nebulino'));

  print('User Name: ${userGetInfo.name} | User URL: ${userGetInfo.url}');

  print('########################user.getLovedTracks#########################');

  // user.getLovedTracks
  (await scrobblenaut.user.getLovedTracks(user: 'nebulino'))
      ?.forEach((Track track) {
    print('Track Name: ${track.name} | Track URL: ${track.url}');
  });

  print('#########################user.getPersonalTags#######################');

  // user.getPersonalTags
  (await scrobblenaut.user.getPersonalTags(
          user: 'nebulino', tag: 'anime', taggingType: TaggingType.track))
      .tracks
      ?.forEach((Track track) {
    print('Track Name: ${track.name} | Track URL: ${track.url}');
  });

  print('#######################user.getRecentTracks#########################');

  // user.getRecentTracks
  (await scrobblenaut.user.getRecentTracks(user: 'nebulino'))
      ?.forEach((Track track) {
    print('Track Name: ${track.name} | Track URL: ${track.url}');
  });

  print('#########################user.getTopAlbums##########################');

  // user.getTopAlbums
  (await scrobblenaut.user.getTopAlbums(user: 'nebulino'))
      ?.forEach((Album album) {
    print('Top Album Name: ${album.name} | Top Album URL : ${album.url}');
  });

  print('#######################user.getTopArtists###########################');

  // user.getTopArtists
  (await scrobblenaut.user.getTopArtists(user: 'nebulino'))
      ?.forEach((Artist artist) {
    print('Top Artist Name: ${artist.name} | Top Artist URL: ${artist.url}');
  });

  print('#########################user.getTopTracks##########################');

  // user.getTopTags
  (await scrobblenaut.user.getTopTags(user: 'nebulino'))?.forEach((Tag tag) {
    print('Top Tag Name: ${tag.name} | Top Tag URL: ${tag.url}');
  });

  print('#####################user.getWeeklyAlbumChart#######################');

  // user.getTopTracks
  (await scrobblenaut.user.getTopTracks(user: 'nebulino'))
      .forEach((Track track) {
    print('Top Tracks Name: ${track.name} | Top Tracks URL: ${track.url} |'
        ' Duration: ${track.duration}');
  });

  print('#####################user.getWeeklyArtistChart######################');

  // user.getWeeklyAlbumChart
  (await scrobblenaut.user.getTopTracks(user: 'nebulino'))
      .forEach((Track track) {
    print('Top Tracks Name: ${track.name} | Top Tracks URL: ${track.url} |'
        ' Duration: ${track.duration}');
  });

  print('#####################user.getWeeklyArtistChart######################');

  // user.getWeeklyArtistChart
  (await scrobblenaut.user.getWeeklyArtistChart(user: 'nebulino'))
      ?.forEach((Artist artist) {
    print('Top Artist Name: ${artist.name} | Top Artist URL: ${artist.url}');
  });

  print('#####################user.getWeeklyChartList########################');

  // user.getWeeklyChartList
  (await scrobblenaut.user.getWeeklyChartList(user: 'nebulino'))
      ?.forEach((Chart chart) {
    print('From: ${chart.fromDate} | To: ${chart.toDate}');
  });

  print('#####################user.getWeeklyTrackChart#######################');

  // user.getWeeklyTrackChart
  (await scrobblenaut.user.getWeeklyTrackChart(user: 'nebulino'))
      ?.forEach((Track track) {
    print(
        'Weekly Tracks Name: ${track.name} | Weekly Tracks URL: ${track.url} |'
        ' Duration: ${track.duration}');
  });

  print('####################################################################');
}
