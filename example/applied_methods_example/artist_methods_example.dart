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

  final artistInstance = (await scrobblenaut.artist.getInfo(
    artist: 'RADWIMPS',
    username: 'nebulino',
    autoCorrect: true,
  ));

  print('#########################artist.addTags#############################');

  // artist.addTags
  print('Result of addTag request: ' +
      (await artistInstance.addTags(tags: ['anime'])).toString());

  print('#######################artist.getCorrection#########################');

  // artist.getCorrection
  (await artistInstance.getCorrection())?.forEach((Artist artist) {
    print('Artist correction: ${artist.name}');
  });

  print('#########################artist.getInfo#############################');

  // artist.getInfo
  final artistGetInfo = (await artistInstance.getInfo(
    username: 'nebulino',
    autoCorrect: true,
  ));

  print('Artist Info Name: ${artistGetInfo.name} | '
      'Artist URL: ${artistGetInfo.url}');

  print('########################artist.getSimilar###########################');

  // artist.getSimilar
  (await artistInstance.getSimilar())?.forEach((Artist artist) {
    print('Similar Artist Name: ${artist.name}');
  });

  print('##########################artist.getTags############################');

  // artist.getTags
  (await artistInstance.getTags())?.forEach((Tag tag) {
    print('Tag name: ${tag.name} | Tag url: ${tag.url}');
  });

  print('#######################artist.getTopAlbums##########################');

  // artist.getTopAlbums
  (await artistInstance.getTopAlbums())?.forEach((Album album) {
    print('Album Name: ${album.name} | Album URL: ${album.url}');
  });

  print('########################artist.getTopTags###########################');

  // artist.getTopTags
  (await artistInstance.getTopTags())?.forEach((Tag tag) {
    print('Tag Name: ${tag.name} | Tag URL: ${tag.url}');
  });

  print('####################artist.getTopTracks#############################');

  // artist.getTopTracks
  (await artistInstance.getTopTracks())?.forEach((Track track) {
    print('Track Name: ${track.name}');
  });

  print('########################artist.removeTag############################');

  // artist.removeTag
  print('Result of removeTag request: ' +
      (await artistInstance.removeTag(tag: 'anime')).toString());

  print('##########################artist.search#############################');

  // artist.search
  (await artistInstance.search()).artists?.forEach((Artist artist) {
    print('Artist name from search: ${artist.name}');
  });

  print('####################################################################');
}
