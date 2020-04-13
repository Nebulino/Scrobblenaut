/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:meta/meta.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';
import 'package:scrobblenaut/src/core/request_mode.dart';
import 'package:scrobblenaut/src/helpers/utils.dart';

/// It's creates a request object for the method.
class Request {
  LastFM _api;
  Map<String, dynamic> _parameters;

  Request({
    @required LastFM api,
    @required String method,
    Map<String, dynamic> parameters,
  }) {
    parameters ?? {};

    _api = api;

    _parameters = {};

    parameters?.forEach((key, value) {
      if (value != null) {
        _parameters[key] = formatUnicode(text: value);
      }
    });

    _parameters['api_key'] = _api.apiKey;
    _parameters['method'] = method;

    if (_api.sessionKey != null) {
      _parameters['sk'] = _api.sessionKey;
      signRequest();
    }
  }

  /// It signs the [Request].
  void signRequest() {
    if (!_parameters.containsKey('api_sig')) {
      _parameters['api_sig'] = _getSignature();
    }
  }

  /// It generates a signature.
  String _getSignature() {
    var signature = '';
    var sortedKeys = _parameters.keys.toList()..sort();

    for (var key in sortedKeys) {
      signature += key;
      signature += _parameters[key];
    }

    signature += _api.apiSecret;

    return generateMD5(signature);
  }

  /// It sends the request to the API.
  Future<dynamic> send({@required RequestMode mode}) async {
    switch (mode) {
      case RequestMode.GET:
        return await _api.client.get(parameters: _parameters);
      case RequestMode.POST:
        return await _api.client.post(parameters: _parameters);
    }
  }
}
