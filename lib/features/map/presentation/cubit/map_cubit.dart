import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:maps_app/features/map/data/poi_repo.dart';
import 'package:maps_app/features/map/data/routing_service.dart';
import 'package:maps_app/features/map/domain/poi.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final PoiRepository _poiRepository;
  final RoutingService _routingService;
  MapController? _mapController;

  MapCubit({
    required PoiRepository poiRepository,
    RoutingService? routingService,
  })  : _poiRepository = poiRepository,
        _routingService = routingService ?? RoutingService(),
        super(MapState.initial());

  void setMapController(MapController controller) {
    _mapController = controller;
  }

  Future<void> init() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      final pois = await _poiRepository.getAllPoi();
      final position = await _getUserPosition();

      emit(
        state.copyWith(
          isLoading: false,
          pois: pois,
          userPosition: position,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<Position?> _getUserPosition() async {
    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission permanently denied',
      );
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  void selectPoi(Poi poi) {
    emit(
      state.copyWith(
        selectedPoi: poi,
        routePoints: <LatLng>[],
      ),
    );
  }

  void clearRoute() {
    emit(
      state.copyWith(
        routePoints: <LatLng>[],
      ),
    );
  }

  Future<void> buildRoute() async {
    final position = state.userPosition;
    final selected = state.selectedPoi;

    if (position == null || selected == null) {
      return;
    }

    try {
      // Show loading state while fetching route
      emit(state.copyWith(isLoading: true));

      final start = LatLng(position.latitude, position.longitude);
      final end = LatLng(selected.lat, selected.lng);

      // Fetch real route from routing service
      final routePoints = await _routingService.getRoute(
        start: start,
        end: end,
      );

      emit(
        state.copyWith(
          routePoints: routePoints,
          isLoading: false,
          errorMessage: null,
        ),
      );
    } catch (e) {
      // On error, use straight line as fallback
      final fallbackPoints = <LatLng>[
        LatLng(position.latitude, position.longitude),
        LatLng(selected.lat, selected.lng),
      ];

      emit(
        state.copyWith(
          routePoints: fallbackPoints,
          isLoading: false,
          errorMessage: 'Could not fetch route, showing direct line',
        ),
      );
    }
  }

  double? distanceToSelectedPoiKm() {
    final position = state.userPosition;
    final selected = state.selectedPoi;

    if (position == null || selected == null) {
      return null;
    }

    final meters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      selected.lat,
      selected.lng,
    );

    return meters / 1000.0;
  }

  void zoomIn() {
    if (_mapController == null) return;
    final currentZoom = _mapController!.camera.zoom;
    _mapController!.move(
      _mapController!.camera.center,
      currentZoom + 1,
    );
  }

  void zoomOut() {
    if (_mapController == null) return;
    final currentZoom = _mapController!.camera.zoom;
    _mapController!.move(
      _mapController!.camera.center,
      currentZoom - 1,
    );
  }

  void zoomToUserLocation() {
    if (_mapController == null || state.userPosition == null) return;
    _mapController!.move(
      LatLng(
        state.userPosition!.latitude,
        state.userPosition!.longitude,
      ),
      15,
    );
  }
}