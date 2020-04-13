/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

/// It implements [DioError] class.
/// You can find [description] that gives a brief information of what happened.
class LastFMException extends DioError {
  final int _errorCode;
  final String _description;

  LastFMException._(this._errorCode, this._description);

  LastFMException({@required String errorCode, @required String description})
      : this._(int.parse(errorCode), description);

  @override
  String toString() =>
      '[LastFMException] => [Code ${_errorCode}]: ${_description}';
}
