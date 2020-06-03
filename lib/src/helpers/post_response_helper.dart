//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:xml/xml.dart' as xml;

/// It helps getting a object from a Response of [SpaceShip].
class PostResponseHelper {
  /// The response status of a POST Response.
  final bool _status;

  PostResponseHelper._(this._status);

  factory PostResponseHelper.parse(String response) {
    final statusNode =
        xml.XmlDocument.parse(response).findElements('lfm').first;

    if (statusNode.getAttribute('status') == 'ok') {
      return PostResponseHelper._(true);
    } else if (statusNode.getAttribute('status') == 'failed') {
      return PostResponseHelper._(false);
    } else {
      throw ScrobblenautException(description: 'Response unrecognized.');
    }
  }

  /// It returns the status of a POST Response.
  bool get status => _status;
}
