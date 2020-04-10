/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:scrobblenaut/scrobblenaut.dart';

import 'api_values.dart';

// Just an example of use.
void main() {
  final scrobblenaut =
      Scrobblenaut(apiKey: APIValues.API, apiSecret: APIValues.secret);
}
