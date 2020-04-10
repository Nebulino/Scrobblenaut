/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:scrobblenaut/scrobblenaut.dart';
import 'package:test/test.dart';

// Some Scrobblenaut tests.
void main() {
  group('A group of tests', () {
    Scrobblenaut scrobblenaut;
    String token;

    setUp(() {
      scrobblenaut = Scrobblenaut(apiKey: 'Key', apiSecret: 'Secret');
    });

    test('Scrobblenaut Tests', () {
      expect(scrobblenaut, isA<Scrobblenaut>());
    });
  });
}
