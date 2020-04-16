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

  final trackInstance = (await scrobblenaut.track.getInfo(
    track: 'Tomoyo',
    artist: 'Zekk',
    autoCorrect: true,
  ));

  print('##########################track.addTags#############################');

  // track.addTags
  print('Result of addTag request: ' +
      (await trackInstance.addTags(tags: ['anime'])).toString());

  print('######################track.getCorrection###########################');

  // track.getCorrection
  (await trackInstance.getCorrection())?.forEach((Track track) {
    print('Track Correction Name: ${track.name} |'
        ' Track Correction URL: ${track.url}');
  });

  print('#########################track.getInfo##############################');

  // track.getInfo
  final trackGetInfo = (await trackInstance.getInfo(
    username: 'nebulino',
    autoCorrect: true,
  ));

  print('Track Info Name: ${trackGetInfo.name} '
      '| Track URL: ${trackGetInfo.url} '
      '| Track Duration: ${trackGetInfo.duration}');

  print('#########################track.getSimilar###########################');

  // track.getSimilar
  (await trackInstance.getSimilar())?.forEach((Track track) {
    print('Similar Track Name: ${track.name}');
  });

  print('###########################track.getTags############################');

  // track.getTags
  (await trackInstance.getTags(user: 'nebulino'))?.forEach((Tag tag) {
    print('Tag name: ${tag.name} | Tag url: ${tag.url}');
  });

  print('#########################track.getTopTags###########################');

  // track.getTopTags
  (await trackInstance.getTopTags())?.forEach((Tag tag) {
    print('Tag name: ${tag.name} | Tag url: ${tag.url}');
  });

  print('#############################track.love#############################');

  // track.love
  print('Result of love request: ' + (await trackInstance.love()).toString());

  print('########################track.removeTag#############################');

  // track.removeTag
  print('Result of removeTag request: ' +
      (await trackInstance.removeTag(tag: 'anime')).toString());

  print('#########################track.scrobble#############################');

  // track.scrobble
  final scrobbleResponse =
      await trackInstance.scrobble(timestamp: DateTime.now());
  // YAY. IT WORKS!

  scrobbleResponse.scrobbleResponses?.forEach((ScrobbledTrack scrobbledTrack) {
    print('Scrobbled Title: ${scrobbledTrack.track}');
  });

  print('###########################track.search#############################');

  // track.search
  (await trackInstance.search()).tracks?.forEach((Track track) {
    print('Track Name from search: ${track.name}');
  });

  print('##########################track.unlove##############################');

  // track.unlove
  print(
      'Result of unlove request: ' + (await trackInstance.unLove()).toString());

  print('#####################track.updateNowPlaying#########################');

  // track.updateNowPlaying
  final nowPlayingResponse = await trackInstance.updateNowPlaying();
  // YAY. IT WORKS!

  print('Result of updateNowPlaying request: ${nowPlayingResponse.status} | '
      '${nowPlayingResponse.track}');

  print('####################################################################');
}
