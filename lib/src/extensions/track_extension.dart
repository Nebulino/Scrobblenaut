/**
 * Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:meta/meta.dart';
import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/lastfm_methods.dart';
import 'package:scrobblenaut/scrobblenaut.dart';

/// Give the ability of applying [TrackMethods] on [Track].
extension TrackExtension on Track {
  TrackMethods get _trackMethods => Scrobblenaut.instance.track;
}
