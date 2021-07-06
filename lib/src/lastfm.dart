//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

/// LastFM Type Class.
library lastfm_objects;

import 'package:json_annotation/json_annotation.dart';
import 'package:scrobblenaut/src/helpers/lastfm_value_normalizer.dart';

part 'lastfm.g.dart';

// Core objects.
part 'package:scrobblenaut/src/lastfm/core/now_playing_object.dart';
part 'package:scrobblenaut/src/lastfm/core/scrobble_object.dart';
part 'package:scrobblenaut/src/lastfm/core/session.dart';
part 'package:scrobblenaut/src/lastfm/core/attr.dart';

// Enums.
part 'package:scrobblenaut/src/lastfm/enums/languages.dart';
part 'package:scrobblenaut/src/lastfm/enums/periods.dart';
part 'package:scrobblenaut/src/lastfm/enums/size.dart';
part 'package:scrobblenaut/src/lastfm/enums/tagging_type.dart';

// LastFM objects.
part 'package:scrobblenaut/src/lastfm/album.dart';
part 'package:scrobblenaut/src/lastfm/album_results.dart';
part 'package:scrobblenaut/src/lastfm/artist.dart';
part 'package:scrobblenaut/src/lastfm/artist_results.dart';
part 'package:scrobblenaut/src/lastfm/bio.dart';
part 'package:scrobblenaut/src/lastfm/chart.dart';
part 'package:scrobblenaut/src/lastfm/date.dart';
part 'package:scrobblenaut/src/lastfm/image.dart';
part 'package:scrobblenaut/src/lastfm/link.dart';
part 'package:scrobblenaut/src/lastfm/registered.dart';
part 'package:scrobblenaut/src/lastfm/stats.dart';
part 'package:scrobblenaut/src/lastfm/streamable.dart';
part 'package:scrobblenaut/src/lastfm/tag.dart';
part 'package:scrobblenaut/src/lastfm/taggings.dart';
part 'package:scrobblenaut/src/lastfm/track.dart';
part 'package:scrobblenaut/src/lastfm/track_results.dart';
part 'package:scrobblenaut/src/lastfm/user.dart';
part 'package:scrobblenaut/src/lastfm/wiki.dart';

// LastFM Responses
part 'package:scrobblenaut/src/lastfm/responses/library.dart';
