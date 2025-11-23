import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RoutingService {
  // Using OSRM (Open Source Routing Machine) - free, no API key needed
  static const String _baseUrl = 'https://router.project-osrm.org';

  /// Get route between two points
  /// Returns a list of LatLng points representing the route
  Future<List<LatLng>> getRoute({
    required LatLng start,
    required LatLng end,
  }) async {
    try {
      // OSRM API format: /route/v1/{profile}/{coordinates}
      // Profile can be: car, bike, foot
      final url = Uri.parse(
        '$_baseUrl/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['code'] == 'Ok' && data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'];

          if (geometry != null && geometry['coordinates'] != null) {
            final coordinates = geometry['coordinates'] as List;

            // Convert coordinates to LatLng
            return coordinates.map((coord) {
              return LatLng(
                (coord[1] as num).toDouble(), // latitude
                (coord[0] as num).toDouble(), // longitude
              );
            }).toList();
          }
        }
      }

      // If API fails, return straight line as fallback
      return [start, end];
    } catch (e) {
      // On error, return straight line as fallback
      return [start, end];
    }
  }

  /// Get route distance in meters
  Future<double?> getRouteDistance({
    required LatLng start,
    required LatLng end,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=false',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['code'] == 'Ok' && data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          return (route['distance'] as num?)?.toDouble();
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get route duration in seconds
  Future<double?> getRouteDuration({
    required LatLng start,
    required LatLng end,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=false',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['code'] == 'Ok' && data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          return (route['duration'] as num?)?.toDouble();
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
