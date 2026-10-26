//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// Routes every request of [dio] through the proxy at [hostPort].
///
/// Native implementation: it replaces the adapter with an
/// [IOHttpClientAdapter] whose `HttpClient.findProxy` returns
/// `PROXY hostPort`, so both `http` and `https` requests go through it.
Dio applyProxy(Dio dio, String hostPort) {
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      client.findProxy = (uri) => 'PROXY $hostPort';
      return client;
    },
  );

  return dio;
}
