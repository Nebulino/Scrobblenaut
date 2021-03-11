//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:meta/meta.dart';
import 'package:scrobblenaut/lastfm.dart';
import 'package:scrobblenaut/scrobblenaut_exceptions.dart';
import 'package:scrobblenaut/src/core/lastfm.dart';
import 'package:scrobblenaut/src/core/request.dart';
import 'package:scrobblenaut/src/core/request_mode.dart';
import 'package:scrobblenaut/src/helpers/lastfm_value_normalizer.dart';
import 'package:scrobblenaut/src/helpers/now_played_track.dart';
import 'package:scrobblenaut/src/helpers/post_response_helper.dart';
import 'package:scrobblenaut/src/helpers/scrobble_response.dart';
import 'package:scrobblenaut/src/helpers/utils.dart';

/// This contains all the methods about a [Track].
class TrackMethods {
  final LastFM _api;

  TrackMethods(this._api);

  /// Tag a track using a list of user supplied tags.
  ///
  /// https://www.last.fm/api/show/track.addTags
  Future<bool> addTags({
    @required String track,
    @required String artist,
    @required List<String> tags,
  }) async {
    if (!_api.isAuth) {
      return Future.error(ScrobblenautException(
          description: "You can't use this method unless you Authenticate."));
    }

    if (tags.length > 10) {
      return Future.error(ScrobblenautException(
          description: "You've supplied more than 10 tags."));
    }

    final parameters = {
      'track': track,
      'artist': artist,
      'tags': generateStringFromList(tags),
    };

    final request =
        Request(api: _api, method: 'track.addTags', parameters: parameters)
          ..signRequest();

    final response =
        PostResponseHelper.parse(await request.send(mode: RequestMode.POST));

    if (response.status) {
      return true;
    } else {
      return false;
    }
  }

  /// Use the last.fm corrections data to check whether
  /// the supplied artist has a correction to a canonical artist.
  ///
  /// https://www.last.fm/api/show/artist.getCorrection
  Future<List<Track>> getCorrection({
    @required String track,
    @required String artist,
  }) async {
    final parameters = {
      'track': track,
      'artist': artist,
    };

    final request = Request(
        api: _api, method: 'track.getCorrection', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final corrections = response['corrections'];

    if (corrections is List) {
      return List.generate(
          corrections.length,
          (i) => Track.fromJson(
              response['corrections']['correction']['track'][i]));
    }

    // A list of a single correction.
    return [Track.fromJson(corrections['correction']['track'])];
  }

  /// Get the metadata for a track on Last.fm
  /// using the artist/track name or a musicbrainz id.
  ///
  /// https://www.last.fm/api/show/track.getInfo
  Future<Track> getInfo({
    String track,
    String artist,
    String mbid,
    String username,
    bool autoCorrect = false,
  }) async {
    if ((track == null || artist == null) && mbid == null) {
      return Future.error(ScrobblenautException(
          description: 'At least mbid is required. '
              'Can be used also track and artist.'));
    }

    final parameters = {
      'track': track,
      'artist': artist,
      'mbid': mbid,
      'username': username,
      'autocorrect': (autoCorrect ? 1 : 0),
    };

    final request =
        Request(api: _api, method: 'track.getInfo', parameters: parameters);

    return (Track.fromJson(
        (await request.send(mode: RequestMode.GET))['track']));
  }

  /// Get the similar tracks for this track on Last.fm, based on listening data.
  ///
  /// https://www.last.fm/api/show/track.getSimilar
  Future<List<Track>> getSimilar({
    String track,
    String artist,
    String mbid,
    int limit,
    bool autoCorrect = false,
  }) async {
    if ((track == null || artist == null) && mbid == null) {
      return Future.error(ScrobblenautException(
          description: 'At least mbid is required. '
              'Can be used also track and artist.'));
    }

    final parameters = {
      'track': track,
      'artist': artist,
      'mbid': mbid,
      'limit': limit,
      'autocorrect': (autoCorrect ? 1 : 0),
    };

    final request =
        Request(api: _api, method: 'track.getSimilar', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final similarTracks = response['similartracks']['track'];

    return similarTracks == null
        ? null
        : List.generate((similarTracks as List).length,
            (i) => Track.fromJson(similarTracks[i]));
  }

  /// Get the tags applied by an individual user to a track on Last.fm.
  /// To retrieve the list of top tags applied to a track by
  /// all users use track.getTopTags.
  ///
  /// https://www.last.fm/api/show/track.getTags
  Future<List<Tag>> getTags({
    String track,
    String artist,
    String mbid,
    String user,
    bool autoCorrect = false,
  }) async {
    if ((track == null || artist == null) && mbid == null) {
      return Future.error(ScrobblenautException(
          description: 'At least mbid is required. '
              'Can be used also track and artist.'));
    }

    if (!_api.isAuth && user == null) {
      return Future.error(ScrobblenautException(
          description: "You're not authenticated, you must use user."));
    }

    final parameters = {
      'track': track,
      'artist': artist,
      'mbid': mbid,
      'user': user,
      'autocorrect': (autoCorrect ? 1 : 0),
    };

    final request =
        Request(api: _api, method: 'track.getTags', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    // Tag sometimes even exists... For some reason... Thanks LastFM...
    final tags = response.toString() == '{}'
        ? throw LastFMException(
            errorCode: '0',
            description: "There's a problem with Your request."
                " Check You're input data such as artist-track / mbid.")
        : response['tags'];

    return tags['tag'] == null
        ? null
        : List.generate(
            (tags['tag'] as List).length, (i) => Tag.fromJson(tags['tag'][i]));
  }

  /// Get the top tags for this track on Last.fm, ordered by tag count.
  /// Supply either track & artist name or mbid.
  ///
  /// https://www.last.fm/api/show/track.getTopTags
  Future<List<Tag>> getTopTags({
    String track,
    String artist,
    String mbid,
    bool autoCorrect = false,
  }) async {
    if ((track == null || artist == null) && mbid == null) {
      return Future.error(ScrobblenautException(
          description: 'At least mbid is required. '
              'Can be used also track and artist.'));
    }

    final parameters = {
      'track': track,
      'artist': artist,
      'mbid': mbid,
      'autocorrect': (autoCorrect ? 1 : 0),
    };

    final request =
        Request(api: _api, method: 'track.getTopTags', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    final tags = response['toptags']['tag'];

    return tags == null
        ? null
        : List.generate((tags as List).length, (i) => Tag.fromJson(tags[i]));
  }

  /// Love a track for a user profile.
  ///
  /// https://www.last.fm/api/show/track.love
  Future<bool> love({
    @required String track,
    @required String artist,
  }) async {
    if (!_api.isAuth) {
      return Future.error(ScrobblenautException(
          description: "You can't use this method unless you Authenticate."));
    }

    final parameters = {
      'track': formatUnicode(text: track),
      'artist': formatUnicode(text: artist),
    };

    final request =
        Request(api: _api, method: 'track.love', parameters: parameters)
          ..signRequest();

    final response =
        PostResponseHelper.parse(await request.send(mode: RequestMode.POST));

    if (response.status) {
      return true;
    } else {
      return false;
    }
  }

  /// Remove a user's tag from a track.
  ///
  /// https://www.last.fm/api/show/track.removeTag
  Future<bool> removeTag({
    @required String track,
    @required String artist,
    @required String tag,
  }) async {
    if (!_api.isAuth) {
      return Future.error(ScrobblenautException(
          description: "You can't use this method unless you Authenticate."));
    }

    final parameters = {
      'track': track,
      'artist': artist,
      'tag': tag,
    };

    final request =
        Request(api: _api, method: 'track.removeTag', parameters: parameters)
          ..signRequest();

    final response =
        PostResponseHelper.parse(await request.send(mode: RequestMode.POST));

    if (response.status) {
      return true;
    } else {
      return false;
    }
  }

  /// Used to add a track-play to a user's profile.
  /// Scrobble a track, or a batch of tracks.
  /// Tracks are passed to the service using array notation for each of the
  /// below params, up to a maximum of 50 scrobbles per batch [0<=i<=49].
  /// If you are only sending a single scrobble the array notation may be
  /// omitted.
  ///
  /// **Note:** Extra care should be taken while calculating the signature
  /// when using array notation as the parameter names *MUST*
  /// be sorted according to the ASCII table
  /// (i.e., artist[10] comes before artist[1]).
  ///
  /// It is important to not use the corrections returned by
  /// the now playing service as input for the scrobble request,
  /// unless they have been explicitly approved by the user.
  /// Parameter names are case sensitive.
  Future<ScrobbleResponse> scrobble({
    @required String track,
    String album,
    @required String artist,
    int trackNumber,
    Duration duration,
    DateTime timestamp,
    String context,
    String streamId,
    bool chosenByUser = false,
    String mbid,
  }) async {
    if (!_api.isAuth) {
      return Future.error(ScrobblenautException(
          description: "You can't use this method unless you Authenticate."));
    }

    timestamp ??= DateTime.now();

    final parameters = {
      'track': track,
      'album': album,
      'artist': artist,
      'trackNumber': trackNumber,
      'duration': duration?.inSeconds,
      'timestamp':
          LastFMValueNormalizer.timestampToSecondsSinceEpoch(timestamp),
      'context': context,
      'streamId': streamId,
      'chosenByUser': (chosenByUser ? 1 : 0),
      'mbid': mbid,
    };

    final request =
        Request(api: _api, method: 'track.scrobble', parameters: parameters)
          ..signRequest();

    final response = (await request.send(mode: RequestMode.POST));

    return ScrobbleResponse.parse(response);
  }

  /// See [TrackMethods.scrobble].
  Future<ScrobbleResponse> scrobbleFromObject(
      {@required Scrobble scrobble}) async {
    if (!_api.isAuth) {
      return Future.error(ScrobblenautException(
          description: "You can't use this method unless you Authenticate."));
    }

    final parameters = {
      'track': scrobble.track,
      'album': scrobble.album,
      'artist': scrobble.artist,
      'trackNumber': scrobble.trackNumber,
      'duration': scrobble.duration?.inSeconds,
      'timestamp': scrobble.timestamp == null
          ? LastFMValueNormalizer.timestampToSecondsSinceEpoch(DateTime.now())
          : LastFMValueNormalizer.timestampToSecondsSinceEpoch(
              scrobble.timestamp),
      'context': scrobble.context,
      'streamId': scrobble.streamId,
      'chosenByUser': (scrobble.chosenByUser == null
          ? null
          : scrobble.chosenByUser
              ? 1
              : 0),
      'mbid': scrobble.mbid,
    };

    final request =
        Request(api: _api, method: 'track.scrobble', parameters: parameters)
          ..signRequest();

    final response = (await request.send(mode: RequestMode.POST));

    return ScrobbleResponse.parse(response);
  }

  /// See [TrackMethods.scrobble] and [Scrobble] for more information.
  Future<ScrobbleResponse> multiScrobble(
      {@required List<Scrobble> scrobbleList}) async {
    // TODO: make a queue for scrobbleList longer than 50?

    if (scrobbleList.length > 50) {
      return Future.error(ScrobblenautException(
          description: "You've supplied more than 50 scrobbles."));
    }

    var parameters = <String, dynamic>{};

    var i = 1;

    scrobbleList.forEach((Scrobble scrobble) {
      parameters['track[${i}]'] = scrobble.track;
      parameters['album[${i}]'] = scrobble.album;
      parameters['artist[${i}]'] = scrobble.artist;
      parameters['trackNumber[${i}]'] = scrobble.trackNumber;
      parameters['duration[${i}]'] = scrobble.duration;
      parameters['timestamp[${i}]'] = scrobble.timestamp;
      parameters['context[${i}]'] = scrobble.context;
      parameters['streamId[${i}]'] = scrobble.streamId;
      parameters['chosenByUser[${i}]'] = scrobble.chosenByUser;
      parameters['mbid[${i}]'] = scrobble.mbid;

      i++;
    });

    final request =
        Request(api: _api, method: 'track.scrobble', parameters: parameters)
          ..signRequest();

    final response = await request.send(mode: RequestMode.POST);

    return ScrobbleResponse.parse(response);
  }

  /// Search for a track by track name.
  /// Returns track matches sorted by relevance.
  ///
  /// https://www.last.fm/api/show/track.search
  Future<TrackSearchResults> search({
    @required String track,
    String artist,
    int page = 1,
    int limit = 30,
  }) async {
    final parameters = {
      'track': track,
      'artist': artist,
      'page': page,
      'limit': limit,
    };

    final request =
        Request(api: _api, method: 'track.search', parameters: parameters);

    final response = await request.send(mode: RequestMode.GET);

    return TrackSearchResults.fromJson(response['results']);
  }

  /// UnLove a track for a user profile.
  ///
  /// https://www.last.fm/api/show/track.unlove
  Future<bool> unLove({
    @required String track,
    @required String artist,
  }) async {
    if (!_api.isAuth) {
      return Future.error(ScrobblenautException(
          description: "You can't use this method unless you Authenticate."));
    }

    final parameters = {
      'track': track,
      'artist': artist,
    };

    final request =
        Request(api: _api, method: 'track.unlove', parameters: parameters)
          ..signRequest();

    final response =
        PostResponseHelper.parse(await request.send(mode: RequestMode.POST));

    if (response.status) {
      return true;
    } else {
      return false;
    }
  }

  /// Used to notify Last.fm that a user has started listening to a track.
  /// Parameter names are case **sensitive**.
  ///
  /// https://www.last.fm/api/show/track.updateNowPlaying
  Future<NowPlayedTrack> updateNowPlaying({
    @required String track,
    String album,
    @required String artist,
    int trackNumber,
    Duration duration,
    DateTime timestamp,
    String context,
    String streamId,
    bool chosenByUser = false,
    String mbid,
  }) async {
    if (!_api.isAuth) {
      return Future.error(ScrobblenautException(
          description: "You can't use this method unless you Authenticate."));
    }

    final parameters = {
      'track': track,
      'album': album,
      'artist': artist,
      'trackNumber': trackNumber,
      'duration': duration?.inSeconds,
      'timestamp':
          LastFMValueNormalizer.timestampToSecondsSinceEpoch(timestamp),
      'context': context,
      'streamId': streamId,
      'chosenByUser': (chosenByUser ? 1 : 0),
      'mbid': mbid,
    };

    final request = Request(
        api: _api, method: 'track.updateNowPlaying', parameters: parameters)
      ..signRequest();

    final response = (await request.send(mode: RequestMode.POST));

    return NowPlayedTrack.parse(response);
  }

  /// See [TrackMethods.updateNowPlaying].
  Future<NowPlayedTrack> updateNowPlayingFromObject(
      {@required NowPlaying track}) async {
    if (!_api.isAuth) {
      return Future.error(ScrobblenautException(
          description: "You can't use this method unless you Authenticate."));
    }

    final parameters = {
      'track': track.track,
      'album': track.album,
      'artist': track.artist,
      'trackNumber': track.trackNumber,
      'duration': track.duration?.inSeconds,
      'context': track.context,
      'mbid': track.mbid,
    };

    final request = Request(
        api: _api, method: 'track.updateNowPlaying', parameters: parameters)
      ..signRequest();

    final response = (await request.send(mode: RequestMode.POST));

    return NowPlayedTrack.parse(response);
  }
}
