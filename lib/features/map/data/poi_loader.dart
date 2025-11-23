import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:maps_app/features/map/domain/poi.dart';

class PoiLoader {
  final String assetPath;

  const PoiLoader({this.assetPath = 'assets/json/poi.json'});

  Future<List<Poi>> loadPoiList() async {
    final jsonString = await rootBundle.loadString(assetPath);
    final dynamic decoded = jsonDecode(jsonString);

    if (decoded is! List) {
      throw const FormatException('POI JSON must be a list');
    }

    return decoded
        .map((e) => Poi.fromJson(e as Map<String, dynamic>))
        .toList()
        .cast<Poi>();
  }
}