//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/lastfm_methods.dart';
import 'package:scrobblenaut/scrobblenaut.dart';
import 'package:scrobblenaut/scrobblenaut_helpers.dart';
import 'package:scrobblenaut/src/helpers/now_played_track.dart';

/// Give the ability of applying [TrackMethods] on [Track].
extension TrackExtension on Track {
  TrackMethods get _trackMethods => Scrobblenaut.instance.track;

  /// [TrackMethods.addTags]
  Future<bool> addTags({required List<String> tags}) async {
    return await _trackMethods.addTags(
      track: name,
      artist: artist?.name ?? '',
      tags: tags,
    );
  }

  /// [TrackMethods.getCorrection]
  Future<List<Track>> getCorrection() async {
    return await _trackMethods.getCorrection(
      track: name,
      artist: artist?.name ?? '',
    );
  }

  /// [TrackMethods.getInfo]
  Future<Track> getInfo({
    String? username,
    bool autoCorrect = false,
  }) async {
    return await _trackMethods.getInfo(
      track: name,
      artist: artist?.name,
      mbid: mbid,
      username: username,
      autoCorrect: autoCorrect,
    );
  }

  /// [TrackMethods.getSimilar]
  Future<List<Track>?> getSimilar({
    int? limit,
    bool autoCorrect = false,
  }) async {
    return await _trackMethods.getSimilar(
      track: name,
      artist: artist?.name,
      mbid: mbid,
      limit: limit,
      autoCorrect: autoCorrect,
    );
  }

  /// [TrackMethods.getTags]
  Future<List<Tag>?> getTags({
    String? user,
    bool autoCorrect = false,
  }) async {
    return await _trackMethods.getTags(
      track: name,
      artist: artist?.name,
      mbid: mbid,
      user: user,
      autoCorrect: autoCorrect,
    );
  }

  /// [TrackMethods.getTopTags]
  Future<List<Tag>?> getTopTags({
    bool autoCorrect = false,
  }) async {
    return await _trackMethods.getTopTags(
      track: name,
      artist: artist?.name,
      mbid: mbid,
      autoCorrect: autoCorrect,
    );
  }

  /// [TrackMethods.love]
  Future<bool> love() async {
    return await _trackMethods.love(
      track: name,
      artist: artist?.name ?? '',
    );
  }

  /// [TrackMethods.removeTag]
  Future<bool> removeTag({
    required String tag,
  }) async {
    return await _trackMethods.removeTag(
      track: name,
      artist: artist?.name ?? '',
      tag: tag,
    );
  }

  /// [TrackMethods.scrobble]
  Future<ScrobbleResponse> scrobble({
    String? album,
    int? trackNumber,
    Duration? duration,
    DateTime? timestamp,
    String? context,
    String? streamId,
    bool chosenByUser = false,
    String? mbid,
  }) async {
    timestamp ??= DateTime.now();

    return await _trackMethods.scrobble(
      track: name,
      album: album ?? this.album?.name,
      artist: artist?.name ?? '',
      trackNumber: trackNumber,
      duration: duration ?? this.duration,
      timestamp: timestamp,
      context: context,
      streamId: streamId,
      chosenByUser: chosenByUser,
      mbid: mbid ?? this.mbid,
    );
  }

  /// [TrackMethods.search]
  Future<TrackSearchResults> search({
    String? artist,
    int page = 1,
    int limit = 30,
  }) async {
    return await _trackMethods.search(
      track: name,
      artist: artist ?? this.artist?.name,
      page: page,
      limit: limit,
    );
  }

  /// [TrackMethods.unLove]
  Future<bool> unLove() async {
    return await _trackMethods.unLove(
      track: name,
      artist: artist?.name ?? '',
    );
  }

  /// [TrackMethods.updateNowPlaying]
  Future<NowPlayedTrack> updateNowPlaying({
    String? album,
    int? trackNumber,
    Duration? duration,
    DateTime? timestamp,
    String? context,
    String? streamId,
    bool chosenByUser = false,
    String? mbid,
  }) async {
    return await _trackMethods.updateNowPlaying(
      track: name,
      album: album ?? this.album?.name,
      artist: artist?.name ?? '',
      trackNumber: trackNumber,
      duration: duration ?? this.duration,
      timestamp: timestamp,
      context: context,
      streamId: streamId,
      chosenByUser: chosenByUser,
      mbid: mbid ?? this.mbid,
    );
  }
}
