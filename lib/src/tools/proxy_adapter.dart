//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

/// Applies a `host:port` proxy to a [Dio] client.
///
/// Two implementations: the native one configures `dart:io`'s `HttpClient`,
/// the web one does nothing because the browser owns its proxy settings.
library;

export 'proxy_adapter_stub.dart' if (dart.library.io) 'proxy_adapter_io.dart';
