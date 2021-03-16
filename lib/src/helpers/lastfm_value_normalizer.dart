//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/src/exceptions/scrobblenaut_exception.dart';

/// It helps making LastFM response less... incoherent...
/// In my tests I saw a lot of incoherency in this API.
/// To be sure that all is fine, I've created some functions that helps
/// fixing them.
class LastFMValueNormalizer {
  /// It transforms a supposed number into a Dart int.
  /// This because LastFM sometimes sends a String, sometimes a int.
  /// How knows...
  static int NumberToInt(dynamic supposedNumber) {
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

  /// It transforms a supposed number into a Dart bool.
  /// This because LastFM sends int (0, 1) instead of a bool.
  static bool NumberToBool(dynamic supposedBool) {
    bool _intParser(int number) =>
        number == null ? null : (number == 1 ? true : false);

    if (supposedBool != null) {
      if (supposedBool is String) {
        return _intParser(int.parse(supposedBool));
      } else if (supposedBool is int) {
        return _intParser(supposedBool);
      } else {
        throw ScrobblenautException(
            description: 'The supposed bool is not recognized.');
      }
    } else {
      return null;
    }
  }

  /// It transforms a bool into a LastFM 'bool' [0,1].
  static int BoolToIntBool(bool booleanToTransform) =>
      booleanToTransform == null
          ? null
          : booleanToTransform
              ? 1
              : 0;

  /// It transforms a supposed artist into a real [Artist] object.
  /// This because sometimes LastFM returns an artist as Map,
  /// sometimes as String, which is the Artist name.
  static Artist ArtistParser(dynamic supposedArtist) {
    if (supposedArtist != null) {
      if (supposedArtist is String) {
        return Artist(name: supposedArtist);
      } else if (supposedArtist is Map) {
        return Artist.fromJson(supposedArtist);
      } else {
        throw ScrobblenautException(
            description: 'The supposed Artist is not recognized.');
      }
    } else {
      return null;
    }
  }

  /// It transforms a number that is supposed to mean milliseconds since epoch
  /// into a Dart duration.
  /// This is useful for [track.getInfo] for example because in other
  /// circumstances the received duration is in seconds since epoch (unix time).
  /// Thanks LastFM, really appreciated.
  static Duration MillisecondsDurationParser(dynamic supposedMilliseconds) {
    // Thanks LastFM: sometimes can contain 'FIX ME'.
    if (supposedMilliseconds.toString() == 'FIXME') return null;

    if (supposedMilliseconds != null) {
      if (supposedMilliseconds is String) {
        return Duration(milliseconds: int.parse(supposedMilliseconds));
      } else if (supposedMilliseconds is int) {
        return Duration(milliseconds: supposedMilliseconds);
      } else {
        throw ScrobblenautException(
            description:
                'The supposed duration in milliseconds is not recognized.');
      }
    } else {
      return null;
    }
  }

  /// It transforms a number that is supposed to mean seconds since epoch
  /// into a Dart duration.
  /// This is useful for [album.getInfo] for example because in other
  /// circumstances the received duration is in milliseconds since epoch.
  /// Thanks LastFM, really appreciated.
  static Duration SecondsDurationParser(dynamic supposedSeconds) {
    if (supposedSeconds != null) {
      if (supposedSeconds is String) {
        return Duration(seconds: int.parse(supposedSeconds));
      } else if (supposedSeconds is int) {
        return Duration(seconds: supposedSeconds);
      } else {
        throw ScrobblenautException(
            description: 'The supposed duration in seconds is not recognized.');
      }
    } else {
      return null;
    }
  }

  /// It transforms a Duration into Milliseconds.
  static int DurationToMilliseconds(Duration duration) =>
      duration == null ? null : duration.inMilliseconds;

  /// It transforms a Duration into Seconds.
  static int DurationToSeconds(Duration duration) =>
      duration == null ? null : duration.inSeconds;

  /// It transforms a LastFM number received from [Artist][streamable]
  /// into a bool.
  static bool isArtistStreamable(dynamic supposedBool) {
    if (supposedBool != null) {
      switch (supposedBool.toString()) {
        case '0':
          return false;
        case '1':
          return true;
        default:
          throw ScrobblenautException(
              description: 'The supposed streamable bool is not recognized.');
      }
    } else {
      return null;
    }
  }

  /// It helps managing a Streamable string or a object.
  static Streamable StreamableParser(dynamic streamable) {
    if (streamable != null) {
      if (streamable is String) {
        return Streamable(text: streamable);
      } else if (streamable is Map) {
        return Streamable.fromJson(streamable);
      } else {
        throw ScrobblenautException(
            description: 'The supposed streamable is not recognized.');
      }
    } else {
      return null;
    }
  }

  /// It transforms a LastFM supposed unixTime into a DateTime.
  static DateTime DateTimeFromUnixTime(dynamic unixTime) {
    // I've found a nil.
    if (unixTime.toString() == 'nil') {
      return null;
    }

    if (unixTime != null) {
      if (unixTime is String) {
        return DateTime.fromMillisecondsSinceEpoch(int.parse(unixTime) * 1000);
      } else if (unixTime is int) {
        return DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
      } else {
        throw ScrobblenautException(
            description: 'The supposed unixTime bool is not recognized.');
      }
    } else {
      return null;
    }
  }

  /// It transforms a LastFM supposed unixTime from a DateTime.
  static int DateTimeToUnixTime(DateTime dateTime) => dateTime == null
      ? null
      : (dateTime.millisecondsSinceEpoch / 1000).round();

  /// Makes a meaning-less number into a string.
  static String MeaninglessNumber(dynamic supposedText) =>
      supposedText == null ? null : (supposedText.toString());

  /// Tracks extractor.
  static List<Track> tracksExtractor(Map<String, dynamic> tracks) =>
      tracks == null
          ? null
          : List.generate((tracks['track'] as List).length,
              (i) => Track.fromJson(tracks['track'][i]));

  /// Tags extractor.
  static List<Tag> tagsExtractor(Map<String, dynamic> tags) => tags == null
      ? null
      : List.generate(
          (tags['tag'] as List).length, (i) => Tag.fromJson(tags['tag'][i]));

  /// Albums extractor.
  static List<Album> albumsExtractor(Map<String, dynamic> albums) =>
      albums == null
          ? null
          : List.generate((albums['album'] as List).length,
              (i) => Album.fromJson(albums['album'][i]));

  /// Artists extractor.
  static List<Artist> artistsExtractor(Map<String, dynamic> artists) =>
      artists == null
          ? null
          : List.generate((artists['artist'] as List).length,
              (i) => Artist.fromJson(artists['artist'][i]));

  /// SimilarArtists extractor.
  static List<Artist> similarArtistsExtractor(
          Map<String, dynamic> similarArtists) =>
      similarArtists == null
          ? null
          : List.generate((similarArtists['artist'] as List).length,
              (i) => Artist.fromJson(similarArtists['artist'][i]));

  /// Links extractor.
  static List<Link> linksExtractor(Map<String, dynamic> links) {
    final supposedLinksList = links;
    if (links != null) {
      if (supposedLinksList is List) {
        return List.generate((links['link'] as List).length,
            (i) => Link.fromJson(links['link'][i]));
      } else {
        return [Link.fromJson(links['link'])];
      }
    } else {
      return null;
    }
  }

  /// TimeStamp normalizer for POST methods.
  static int timestampToSecondsSinceEpoch(DateTime timestamp) =>
      timestamp == null
          ? null
          : (timestamp.millisecondsSinceEpoch / 1000).round();
}
