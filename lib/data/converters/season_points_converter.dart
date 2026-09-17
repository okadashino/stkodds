import 'package:json_annotation/json_annotation.dart';

class SeasonPointsConverter
    implements JsonConverter<Map<String, int>, Object> {
  const SeasonPointsConverter();

  @override
  Map<String, int> fromJson(Object json) {
    final map = Map<String, dynamic>.from(json as Map);
    return map.map((key, value) => MapEntry(key, (value as num).toInt()));
  }

  @override
  Object toJson(Map<String, int> object) => object;
}
