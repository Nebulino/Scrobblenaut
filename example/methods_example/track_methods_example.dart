/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/scrobblenaut.dart';
import 'package:scrobblenaut/scrobblenaut_helpers.dart';

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

  print('##########################track.addTags#############################');

  // track.addTags
  print('Result of addTag request: ' +
      (await scrobblenaut.track
              .addTags(track: 'Flay', artist: 'PLEEG', tags: ['anime']))
          .toString());

  print('######################track.getCorrection###########################');

  // track.getCorrection
  (await scrobblenaut.track.getCorrection(track: 'TOMOYO', artist: 'Zekk'))
      ?.forEach((Track track) {
    print('Track Correction Name: ${track.name} |'
        ' Track Correction URL: ${track.url}');
  });

  print('#########################track.getInfo##############################');

  // track.getInfo
  final trackGetInfo = (await scrobblenaut.track.getInfo(
    track: 'Tomoyo',
    artist: 'Zekk',
    username: 'nebulino',
    autoCorrect: true,
  ));

  print('Track Info Name: ${trackGetInfo.name} '
      '| Track URL: ${trackGetInfo.url} '
      '| Track Duration: ${trackGetInfo.duration}');

  print('#########################track.getSimilar###########################');

  // track.getSimilar
  (await scrobblenaut.track.getSimilar(track: 'Tomoyo', artist: 'Zekk'))
      ?.forEach((Track track) {
    print('Similar Track Name: ${track.name}');
  });

  print('###########################track.getTags############################');

  // track.getTags
  (await scrobblenaut.track
          .getTags(track: 'Hells Bells', artist: 'AC/DC', user: 'nebulino'))
      ?.forEach((Tag tag) {
    print('Tag name: ${tag.name} | Tag url: ${tag.url}');
  });

  print('#########################track.getTopTags###########################');

  // track.getTopTags
  (await scrobblenaut.track.getTopTags(track: 'Hells Bells', artist: 'AC/DC'))
      ?.forEach((Tag tag) {
    print('Tag name: ${tag.name} | Tag url: ${tag.url}');
  });

  print('#############################track.love#############################');

  // track.love
  print('Result of love request: ' +
      (await scrobblenaut.track.love(track: 'Sunlight', artist: 'PLEEG'))
          .toString());

  print('########################track.removeTag#############################');

  // track.removeTag
  print('Result of removeTag request: ' +
      (await scrobblenaut.track
              .removeTag(track: 'Flay', artist: 'PLEEG', tag: 'anime'))
          .toString());

  print('#########################track.scrobble#############################');

  // track.scrobble
  final scrobbleResponse = await scrobblenaut.track.scrobble(
      track: 'Beautiful Moonlight',
      artist: 'QU4RTZ',
      timestamp: DateTime.now());
  // YAY. IT WORKS!

  scrobbleResponse.scrobbleResponses?.forEach((ScrobbledTrack scrobbledTrack) {
    print('Scrobbled Title: ${scrobbledTrack.track}');
  });

  print('###########################track.search#############################');

  // track.search
  (await scrobblenaut.track.search(track: 'Horizon', artist: 'PLEEG'))
      .tracks
      ?.forEach((Track track) {
    print('Track Name from search: ${track.name}');
  });

  print('##########################track.unlove##############################');

  // track.unlove
  print('Result of unlove request: ' +
      (await scrobblenaut.track.unLove(track: 'Sunlight', artist: 'PLEEG'))
          .toString());

  print('#####################track.updateNowPlaying#########################');

  // track.updateNowPlaying
  final nowPlayingResponse = await scrobblenaut.track
      .updateNowPlaying(track: 'Beautiful Moonlight', artist: 'QU4RTZ');
  // YAY. IT WORKS!

  print('Result of updateNowPlaying request: ${nowPlayingResponse.status} | '
      '${nowPlayingResponse.track}');

  print('####################################################################');
}
