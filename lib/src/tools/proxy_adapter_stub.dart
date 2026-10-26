//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:dio/dio.dart';

/// Web implementation: the browser owns its proxy settings, so there is no
/// hook to install here and [hostPort] is ignored.
///
/// Use [SpaceShip.proxy] to inspect what was configured.
Dio applyProxy(Dio dio, String hostPort) => dio;
