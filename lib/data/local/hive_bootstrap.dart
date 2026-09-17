import 'package:hive_flutter/hive_flutter.dart';

import '../models/fixture.dart';
import '../models/prediction.dart';
import 'hive_adapters.dart';
import 'hive_boxes.dart';
import 'hive_type_ids.dart';

Future<void> initializeHive() async {
  await Hive.initFlutter();
  _registerAdapters();
  await Future.wait([
    Hive.openBox<Fixture>(HiveBoxes.fixtures),
    Hive.openBox<Prediction>(HiveBoxes.predictions),
  ]);
}

void _registerAdapters() {
  if (!Hive.isAdapterRegistered(HiveTypeIds.fixture)) {
    Hive.registerAdapter(FixtureAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveTypeIds.prediction)) {
    Hive.registerAdapter(PredictionAdapter());
  }
}
