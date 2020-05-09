//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// List of different languages supported in LastFM methods.
enum Language {
  en,
  de,
  es,
  fr,
  it,
  pl,
  pt,
  sv,
  tr,
  ru,
  ja,
  zh,
}

extension LanguageExtension on Language {
  String get code {
    switch (this) {
      case Language.en:
        return 'en';
      case Language.de:
        return 'de';
      case Language.es:
        return 'es';
      case Language.fr:
        return 'fr';
      case Language.it:
        return 'it';
      case Language.pl:
        return 'pl';
      case Language.pt:
        return 'pt';
      case Language.sv:
        return 'sv';
      case Language.tr:
        return 'tr';
      case Language.ru:
        return 'ru';
      case Language.ja:
        return 'ja';
      case Language.zh:
        return 'zh';
      default:
        return 'en';
    }
  }
}
