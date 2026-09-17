import 'package:cloud_firestore/cloud_firestore.dart';

abstract final class FirestoreJson {
  static Map<String, dynamic> fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = Map<String, dynamic>.from(snapshot.data() ?? {});
    data['id'] = snapshot.id;
    return normalize(data);
  }

  static Map<String, dynamic> normalize(Map<String, dynamic> data) {
    return data.map((key, value) => MapEntry(key, _normalizeValue(value)));
  }

  static Map<String, dynamic> toDocument(
    Map<String, dynamic> json, {
    List<String> dateKeys = const [],
  }) {
    final data = Map<String, dynamic>.from(json)..remove('id');
    for (final key in dateKeys) {
      final value = data[key];
      if (value is String && value.isNotEmpty) {
        data[key] = Timestamp.fromDate(DateTime.parse(value));
      }
    }
    return data;
  }

  static Object? _normalizeValue(Object? value) {
    if (value is Timestamp) {
      return value.toDate().toIso8601String();
    }
    if (value is DateTime) {
      return value.toIso8601String();
    }
    if (value is Map) {
      return normalize(Map<String, dynamic>.from(value));
    }
    if (value is Iterable && value is! String) {
      return value.map(_normalizeValue).toList();
    }
    return value;
  }
}
