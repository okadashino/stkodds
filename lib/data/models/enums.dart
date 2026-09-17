import 'package:json_annotation/json_annotation.dart';

enum RoundType {
  @JsonValue('day')
  day,
  @JsonValue('matchday')
  matchday,
  @JsonValue('weekend')
  weekend,
}

enum RoundStatus {
  @JsonValue('upcoming')
  upcoming,
  @JsonValue('open')
  open,
  @JsonValue('locked')
  locked,
  @JsonValue('completed')
  completed,
}

enum FixtureStatus {
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('live')
  live,
  @JsonValue('finished')
  finished,
  @JsonValue('postponed')
  postponed,
  @JsonValue('cancelled')
  cancelled,
}

enum PredictionOutcome {
  @JsonValue('home')
  home,
  @JsonValue('draw')
  draw,
  @JsonValue('away')
  away,
}
