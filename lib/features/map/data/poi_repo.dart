import 'package:maps_app/features/map/domain/poi.dart';
import 'poi_loader.dart';

class PoiRepository {
  final PoiLoader _loader;

  PoiRepository({PoiLoader? loader}) : _loader = loader ?? const PoiLoader();

  Future<List<Poi>> getAllPoi() {
    return _loader.loadPoiList();
  }
}