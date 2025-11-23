import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/poi.dart';
import '../cubit/map_cubit.dart';
import '../cubit/map_state.dart';

class MapWidget extends StatefulWidget {
  final MapState state;

  const MapWidget({
    super.key,
    required this.state,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late final MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapCubit>().setMapController(mapController);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userPosition = widget.state.userPosition;

    final LatLng initialCenter = userPosition != null
        ? LatLng(userPosition.latitude, userPosition.longitude)
        : _fallbackCenter();

    final markers = _buildPoiMarkers(context, widget.state.pois);
    final userMarker = _buildUserMarker(userPosition);

    if (userMarker != null) {
      markers.add(userMarker);
    }

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: 14,
        maxZoom: 18,
        minZoom: 3,
        onTap: (tapPosition, point) {
          context.read<MapCubit>().clearRoute();
        },
      ),
      children: <Widget>[
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.nearby_points_routes',
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 45,
            size: const Size(40, 40),
            markers: markers,
            builder: (BuildContext context, List<Marker> cluster) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  cluster.length.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.state.routePoints.isNotEmpty)
          PolylineLayer(
            polylines: <Polyline>[
              Polyline(
                points: widget.state.routePoints,
                strokeWidth: 4,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
      ],
    );
  }

  LatLng _fallbackCenter() {
    // Центр Алматы как дефолт
    return const LatLng(43.238949, 76.889709);
  }

  List<Marker> _buildPoiMarkers(BuildContext context, List<Poi> pois) {
    return pois.map((Poi poi) {
      final LatLng point = LatLng(poi.lat, poi.lng);

      return Marker(
        point: point,
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () {
            context.read<MapCubit>().selectPoi(poi);
          },
          child: Icon(
            Icons.place,
            size: 40,
            color: Theme.of(context).colorScheme.error,
            shadows: const [
              Shadow(
                blurRadius: 4,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Marker? _buildUserMarker(userPosition) {
    if (userPosition == null) {
      return null;
    }

    final LatLng point = LatLng(
      userPosition.latitude,
      userPosition.longitude,
    );

    return Marker(
      point: point,
      width: 40,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black26,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.person_pin_circle,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}