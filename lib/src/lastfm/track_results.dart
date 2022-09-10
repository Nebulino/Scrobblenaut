//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// This object represents the TrackSearchResults from a search.
@JsonSerializable(includeIfNull: false)
class TrackSearchResults {
  /// A list of matched tracks from the search.
  @JsonKey(
      name: 'trackmatches', fromJson: LastFMValueNormalizer.tracksExtractor)
  List<Track>? tracks;

  /// The number of generated matches from the search.
  @JsonKey(
      name: 'opensearch:TotalResults',
      fromJson: LastFMValueNormalizer.NumberToInt)
  int? totalResults;

  /// A value that sign the starting index of the search.
  @JsonKey(
      name: 'opensearch:StartIndex',
      fromJson: LastFMValueNormalizer.NumberToInt)
  int? statingIndex;

  /// Number of matches per page.
  @JsonKey(
      name: 'opensearch:ItemsPerPage',
      fromJson: LastFMValueNormalizer.NumberToInt)
  int? itemsPerPage;

  TrackSearchResults({
    this.tracks,
    this.totalResults,
    this.statingIndex,
    this.itemsPerPage,
  });

  factory TrackSearchResults.fromJson(Map<String, dynamic> json) =>
      _$TrackSearchResultsFromJson(json);

  Map<String, dynamic> toJson() => _$TrackSearchResultsToJson(this);
}
