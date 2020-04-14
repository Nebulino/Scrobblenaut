/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

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

  print('###########################album.addTags############################');

  // album.addTags
  print('Result of addTag request: ' +
      (await scrobblenaut.album.addTags(
              artist: 'RADWIMPS', album: 'Your Name.', tags: ['Anime']))
          .toString());

  print('#########################album.getInfo##############################');

  // album.getInfo
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

  print('#########################album.getTags##############################');

  // album.getTags
  (await scrobblenaut.album.getTags(album: 'Your Name.', artist: 'RADWIMPS'))
      ?.forEach((Tag tag) {
    print('Tag name: ${tag.name} | Tag url: ${tag.url}');
  });

  print('########################album.getTopTags############################');

  // album.getTopTags
  (await scrobblenaut.album
      .getTopTags(album: 'Your Name.', artist: 'RADWIMPS'));

  print('#########################album.removeTag############################');

  // album.removeTag
  print('Result of removeTag request: ' +
      (await scrobblenaut.album
              .removeTag(album: 'Your Name.', artist: 'RADWIMPS', tag: 'anime'))
          .toString());

  print('########################album.search################################');

  // album.search
  (await scrobblenaut.album.search(album: 'Your name.'))
      .albums
      ?.forEach((Album album) {
    print('Album title from search: ${album.name}');
  });

  print('####################################################################');
}
