//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// This object represents the ArtistSearchResults from a search.
@JsonSerializable(includeIfNull: false)
class ArtistSearchResults {
  /// A list of matched artists from the search.
  @JsonKey(
      name: 'artistmatches', fromJson: LastFMValueNormalizer.artistsExtractor)
  List<Artist>? artists;

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

  ArtistSearchResults({
    this.artists,
    this.totalResults,
    this.statingIndex,
    this.itemsPerPage,
  });

  factory ArtistSearchResults.fromJson(Map<String, dynamic> json) =>
      _$ArtistSearchResultsFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistSearchResultsToJson(this);
}
