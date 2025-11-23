import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'package:maps_app/features/map/domain/poi.dart';

class MapState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<Poi> pois;
  final Position? userPosition;
  final Poi? selectedPoi;
  final List<LatLng> routePoints;

  const MapState({
    required this.isLoading,
    required this.errorMessage,
    required this.pois,
    required this.userPosition,
    required this.selectedPoi,
    required this.routePoints,
  });

  factory MapState.initial() {
    return const MapState(
      isLoading: true,
      errorMessage: null,
      pois: <Poi>[],
      userPosition: null,
      selectedPoi: null,
      routePoints: <LatLng>[],
    );
  }

  MapState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Poi>? pois,
    Position? userPosition,
    Poi? selectedPoi,
    List<LatLng>? routePoints,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      pois: pois ?? this.pois,
      userPosition: userPosition ?? this.userPosition,
      selectedPoi: selectedPoi ?? this.selectedPoi,
      routePoints: routePoints ?? this.routePoints,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        isLoading,
        errorMessage,
        pois,
        userPosition,
        selectedPoi,
        routePoints,
      ];
}