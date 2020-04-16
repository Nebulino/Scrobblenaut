/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/scrobblenaut.dart';

import '../api_values.dart';

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

  final userInstance = (await scrobblenaut.user.getInfo(user: 'nebulino'));

  print('#########################user.getFriends############################');

  // User.getFriends
  (await userInstance.getFriends())?.forEach((User user) {
    print('Friend Name: ${user.name} | Friend URL: ${user.url}');
  });

  print('###########################user.getInfo#############################');

  // user.getInfo
  final userGetInfo = (await userInstance.getInfo());

  print('User Name: ${userGetInfo.name} | User URL: ${userGetInfo.url}');

  print('########################user.getLovedTracks#########################');

  // user.getLovedTracks
  (await userInstance.getLovedTracks())?.forEach((Track track) {
    print('Track Name: ${track.name} | Track URL: ${track.url}');
  });

  print('#########################user.getPersonalTags#######################');

  // user.getPersonalTags
  (await userInstance.getPersonalTags(
          tag: 'anime', taggingType: TaggingType.track))
      .tracks
      ?.forEach((Track track) {
    print('Track Name: ${track.name} | Track URL: ${track.url}');
  });

  print('#######################user.getRecentTracks#########################');

  // user.getRecentTracks
  (await userInstance.getRecentTracks())?.forEach((Track track) {
    print('Track Name: ${track.name} | Track URL: ${track.url}');
  });

  print('#########################user.getTopAlbums##########################');

  // user.getTopAlbums
  (await userInstance.getTopAlbums())?.forEach((Album album) {
    print('Top Album Name: ${album.name} | Top Album URL : ${album.url}');
  });

  print('#######################user.getTopArtists###########################');

  // user.getTopArtists
  (await userInstance.getTopArtists())?.forEach((Artist artist) {
    print('Top Artist Name: ${artist.name} | Top Artist URL: ${artist.url}');
  });

  print('#########################user.getTopTracks##########################');

  // user.getTopTags
  (await userInstance.getTopTags())?.forEach((Tag tag) {
    print('Top Tag Name: ${tag.name} | Top Tag URL: ${tag.url}');
  });

  print('#####################user.getWeeklyAlbumChart#######################');

  // user.getTopTracks
  (await userInstance.getTopTracks())?.forEach((Track track) {
    print('Top Tracks Name: ${track.name} | Top Tracks URL: ${track.url} |'
        ' Duration: ${track.duration}');
  });

  print('#####################user.getWeeklyArtistChart######################');

  // user.getWeeklyAlbumChart
  (await userInstance.getTopTracks())?.forEach((Track track) {
    print('Top Tracks Name: ${track.name} | Top Tracks URL: ${track.url} |'
        ' Duration: ${track.duration}');
  });

  print('#####################user.getWeeklyArtistChart######################');

  // user.getWeeklyArtistChart
  (await userInstance.getWeeklyArtistChart())?.forEach((Artist artist) {
    print('Top Artist Name: ${artist.name} | Top Artist URL: ${artist.url}');
  });

  print('#####################user.getWeeklyChartList########################');

  // user.getWeeklyChartList
  (await userInstance.getWeeklyChartList())?.forEach((Chart chart) {
    print('From: ${chart.fromDate} | To: ${chart.toDate}');
  });

  print('#####################user.getWeeklyTrackChart#######################');

  // user.getWeeklyTrackChart
  (await userInstance.getWeeklyTrackChart())?.forEach((Track track) {
    print(
        'Weekly Tracks Name: ${track.name} | Weekly Tracks URL: ${track.url} |'
        ' Duration: ${track.duration}');
  });

  print('####################################################################');
}
