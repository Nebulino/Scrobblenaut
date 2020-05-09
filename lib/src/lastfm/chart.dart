//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

part of lastfm_objects;

/// This object represents a chart.
@JsonSerializable(includeIfNull: false)
class Chart {
  // TODO: What is this?
  @JsonKey(name: '#text')
  String text;

  /// The starting date of the chart.
  @JsonKey(
      name: 'from',
      fromJson: LastFMValueNormalizer.DateTimeFromUnixTime,
      toJson: LastFMValueNormalizer.DateTimeToUnixTime)
  DateTime fromDate;

  /// The ending date of the chart.
  @JsonKey(
      name: 'to',
      fromJson: LastFMValueNormalizer.DateTimeFromUnixTime,
      toJson: LastFMValueNormalizer.DateTimeToUnixTime)
  DateTime toDate;

  Chart({
    this.text,
    this.fromDate,
    this.toDate,
  });

  factory Chart.fromJson(Map<String, dynamic> json) => _$ChartFromJson(json);

  Map<String, dynamic> toJson() => _$ChartToJson(this);
}
