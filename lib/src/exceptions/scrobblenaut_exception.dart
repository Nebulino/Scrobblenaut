//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

/// It implements [Exception] class.
/// You can find [description] that gives a brief information of what happened.
class ScrobblenautException implements Exception {
  final String _description;

  ScrobblenautException._(this._description);

  ScrobblenautException({String description}) : this._(description);

  @override
  String toString() =>
      '[ScrobblenautException]' +
      (_description != null ? ': ${_description}' : '');
}
