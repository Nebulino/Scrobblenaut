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

  print('#########################library.getArtists#########################');

  // library.getArtist
  (await scrobblenaut.library.getArtists(user: 'nebulino'))
      ?.artist
      ?.forEach((Artist artist) {
    print('Top Artist Name: ${artist.name} | Top Artist URL : ${artist.url}');
  });

  print('####################################################################');
}
