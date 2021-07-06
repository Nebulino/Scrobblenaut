//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// This object represents the AlbumSearchResults from a search.
@JsonSerializable(includeIfNull: false)
class AlbumSearchResults {
  /// A list of matched albums from the search.
  @JsonKey(
      name: 'albummatches', fromJson: LastFMValueNormalizer.albumsExtractor)
  List<Album>? albums;

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

  AlbumSearchResults({
    this.albums,
    this.totalResults,
    this.statingIndex,
    this.itemsPerPage,
  });

  factory AlbumSearchResults.fromJson(Map<String, dynamic> json) =>
      _$AlbumSearchResultsFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumSearchResultsToJson(this);
}
