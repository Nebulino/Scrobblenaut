//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/scrobblenaut.dart';
import 'package:test/test.dart';

// Some Scrobblenaut tests.
void main() {
  group('A group of tests', () {
    late Scrobblenaut scrobblenaut;
    String token;
    LastFM lastFM;

    setUp(() {
      token = 'Just a token';
      lastFM = LastFM.noAuth(apiKey: token);
      scrobblenaut = Scrobblenaut(lastFM: lastFM);
    });

    test('Scrobblenaut Tests', () {
      expect(scrobblenaut, isA<Scrobblenaut>());
    });
  });
}
