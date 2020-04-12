/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

/// It implements [Exception] class.
/// You can find [description] that gives a brief information of what happened.
class ScrobblenautException implements Exception {
  String description;

  ScrobblenautException({this.description});

  @override
  String toString() =>
      '[ScrobblenautException]' +
      (description != null ? ': ${description}' : '');
}
