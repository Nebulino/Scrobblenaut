//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// List of different periods used in LastFM methods.
enum Period {
  WEEK,
  MONTH,
  MONTHS3,
  MONTHS6,
  YEAR,
  OVERALL,
}

extension PeriodExtension on Period {
  String get value {
    switch (this) {
      case Period.WEEK:
        return '7day';
      case Period.MONTH:
        return '1month';
      case Period.MONTHS3:
        return '3month';
      case Period.MONTHS6:
        return '6month';
      case Period.YEAR:
        return '12month';
      case Period.OVERALL:
        return 'overall';
      default:
        return null;
    }
  }
}
