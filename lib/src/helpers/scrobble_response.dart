//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:scrobblenaut/src/helpers/lastfm_value_normalizer.dart';
import 'package:scrobblenaut/src/helpers/scrobbled_track.dart';
import 'package:xml/xml.dart' as xml;

/// It helps getting a object from a Response of [SpaceShip]
/// when a [Track.scrobbleOnce] or [Track.scrobble] is used.
/// It handles the different content.
class ScrobbleResponse {
  /// The response status of the [Scrobble] Response.
  final bool _status;

  /// A list of the scrobbles stats.
  final List<ScrobbledTrack> _scrobbledTracks;

  /// Number of accepted scrobble.
  final int? _scrobbleAccepted;

  /// Number of ignored scrobble.
  final int? _scrobbleIgnored;

  ScrobbleResponse._(
    this._status,
    this._scrobbledTracks,
    this._scrobbleAccepted,
    this._scrobbleIgnored,
  );

  /// Combines the responses of a chunked scrobble call into a single one.
  ///
  /// [status] is true only when every response succeeded, the per-scrobble
  /// entries keep the input order, and the accepted/ignored counters are the
  /// sums (null when no response carried them).
  factory ScrobbleResponse.merge(Iterable<ScrobbleResponse> responses) {
    final all = responses.toList(growable: false);

    int? sumOf(int? Function(ScrobbleResponse response) read) {
      int? total;
      for (final response in all) {
        final value = read(response);
        if (value != null) {
          total = (total ?? 0) + value;
        }
      }
      return total;
    }

    return ScrobbleResponse._(
      all.isNotEmpty && all.every((response) => response.status),
      [for (final response in all) ...response.scrobbleResponses],
      sumOf((response) => response.scrobbleAccepted),
      sumOf((response) => response.scrobbleIgnored),
    );
  }

  // It helps creating a ScrobbleResponseHelper from a response in String.
  factory ScrobbleResponse.parse(String response) {
    // It creates the document.
    final responseXML = xml.XmlDocument.parse(response);

    bool status;
    var scrobbledTracks = <ScrobbledTrack>[];
    int? scrobbleAccepted;
    int? scrobbleIgnored;

    // Status node.
    final statusNode = responseXML.findElements('lfm').first;

    if (statusNode.getAttribute('status') == 'ok') {
      status = true;
    } else if (statusNode.getAttribute('status') == 'failed') {
      status = false;
    } else {
      throw ScrobblenautException(description: 'Response unrecognized.');
    }

    // Scrobbles.
    final scrobblesNode = responseXML.findAllElements('scrobbles').first;

    scrobbleAccepted = LastFMValueNormalizer.NumberToInt(
      scrobblesNode.getAttribute('accepted'),
    );

    scrobbleIgnored = LastFMValueNormalizer.NumberToInt(
      scrobblesNode.getAttribute('ignored'),
    );

    final scrobbleListNode = responseXML.findAllElements('scrobble');

    scrobbleListNode.toList().forEach((xml.XmlElement scrobbleElement) {
      scrobbledTracks.add(ScrobbledTrack.parse(scrobbleElement));
    });

    return ScrobbleResponse._(
      status,
      scrobbledTracks,
      scrobbleAccepted,
      scrobbleIgnored,
    );
  }

  /// Returns the status.
  bool get status => _status;

  /// Returns the list of [scrobbled tracks]
  ///
  /// [scrobbled tracks]: [ScrobbledTrack]
  List<ScrobbledTrack> get scrobbleResponses => _scrobbledTracks;

  /// Returns the number of accepted scrobbles.
  int? get scrobbleAccepted => _scrobbleAccepted;

  /// Returns the number of ignored scrobbles.
  int? get scrobbleIgnored => _scrobbleIgnored;
}
