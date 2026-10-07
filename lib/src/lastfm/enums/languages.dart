//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of '../../lastfm.dart';

/// List of different languages supported in LastFM methods.
enum Language { en, de, es, fr, it, pl, pt, sv, tr, ru, ja, zh }

extension LanguageExtension on Language {
  String get code => name;
}
