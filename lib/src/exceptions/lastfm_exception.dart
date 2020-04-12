/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

/// It implements [DioError] class.
/// You can find [description] that gives a brief information of what happened.
class LastFMException extends DioError {
  int errorCode;
  String description;

  LastFMException({@required this.errorCode, @required this.description});

  @override
  String toString() =>
      '[LastFMException] => [Code ${errorCode}]: ${description}';
}
