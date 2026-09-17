import 'package:hive/hive.dart';

import '../models/fixture.dart';
import '../models/prediction.dart';
import 'hive_type_ids.dart';

class FixtureAdapter extends TypeAdapter<Fixture> {
  @override
  final int typeId = HiveTypeIds.fixture;

  @override
  Fixture read(BinaryReader reader) {
    final raw = Map<String, dynamic>.from(reader.read() as Map);
    return Fixture.fromJson(raw);
  }

  @override
  void write(BinaryWriter writer, Fixture obj) {
    writer.write(obj.toJson());
  }
}

class PredictionAdapter extends TypeAdapter<Prediction> {
  @override
  final int typeId = HiveTypeIds.prediction;

  @override
  Prediction read(BinaryReader reader) {
    final raw = Map<String, dynamic>.from(reader.read() as Map);
    return Prediction.fromJson(raw);
  }

  @override
  void write(BinaryWriter writer, Prediction obj) {
    writer.write(obj.toJson());
  }
}
