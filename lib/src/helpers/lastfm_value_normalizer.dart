/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:scrobblenaut/src/exceptions/scrobblenaut_exception.dart';

/// It helps making LastFM response less... incoherent...
/// In my tests I saw a lot of incoherency in this API.
/// To be sure that all is fine, I've created some functions that helps
/// fixing them.
class LastFMValueNormalizer {
  /// It transforms a supposed number into a Dart int.
  static int LastFMNumberToInt(dynamic supposedNumber) {
    if (supposedNumber != null) {
      if (supposedNumber is String) {
        return int.parse(supposedNumber);
      } else if (supposedNumber is int) {
        return supposedNumber;
      } else {
        throw ScrobblenautException(
            description: 'The supposed number is not recognized.');
      }
    } else {
      return null;
    }
  }
}
