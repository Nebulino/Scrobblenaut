import 'package:scrobblenaut/lastfm.dart';
/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

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

  print('#########################artist.addTags#############################');

  // artist.addTags
  print('Result of addTag request: ' +
      (await scrobblenaut.artist.addTags(artist: 'RADWIMPS', tags: ['anime']))
          .toString());

  print('#######################artist.getCorrection#########################');

  // artist.getCorrection
  (await scrobblenaut.artist.getCorrection(artist: 'RADWIMPS'))
      ?.forEach((Artist artist) {
    print('Artist correction: ${artist.name}');
  });

  print('#########################artist.getInfo#############################');

  // artist.getInfo
  final artistGetInfo = (await scrobblenaut.artist.getInfo(
    artist: 'RADWIMPS',
    username: 'nebulino',
    autoCorrect: true,
  ));

  print(
      'Artist Info Name: ${artistGetInfo.name} | Artist URL: ${artistGetInfo.url}');

  print('########################artist.getSimilar###########################');

  // artist.getSimilar
  (await scrobblenaut.artist.getSimilar(artist: 'RADWIMPS'))
      ?.forEach((Artist artist) {
    print('Similar Artist Name: ${artist.name}');
  });

  print('##########################artist.getTags############################');

  // artist.getTags
  (await scrobblenaut.artist.getTags(artist: 'RADWIMPS'))?.forEach((Tag tag) {
    print('Tag name: ${tag.name} | Tag url: ${tag.url}');
  });

  print('#######################artist.getTopAlbums##########################');

  // artist.getTopAlbums
  (await scrobblenaut.artist.getTopAlbums(artist: 'RADWIMPS'))
      ?.forEach((Album album) {
    print('Album Name: ${album.name} | Album URL: ${album.url}');
  });

  print('########################artist.getTopTags###########################');

  // artist.getTopTags
  (await scrobblenaut.artist.getTopTags(artist: 'RADWIMPS'))
      ?.forEach((Tag tag) {
    print('Tag Name: ${tag.name} | Tag URL: ${tag.url}');
  });

  print('####################artist.getTopTracks#############################');

  // artist.getTopTracks
  (await scrobblenaut.artist.getTopTracks(artist: 'RADWIMPS'))
      ?.forEach((Track track) {
    print('Track Name: ${track.name}');
  });

  print('########################artist.removeTag############################');

  // artist.removeTag
  print('Result of removeTag request: ' +
      (await scrobblenaut.artist.removeTag(artist: 'RADWIMPS', tag: 'anime'))
          .toString());

  print('##########################artist.search#############################');

  // artist.search
  (await scrobblenaut.artist.search(artist: 'RADWIMPS'))
      .artists
      ?.forEach((Artist artist) {
    print('Artist name from search: ${artist.name}');
  });

  print('####################################################################');
}
