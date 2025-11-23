class Poi {
  final int id;
  final String name;
  final double lat;
  final double lng;

  const Poi({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Poi &&
        other.id == id &&
        other.name == name &&
        other.lat == lat &&
        other.lng == lng;
  }

  @override
  int get hashCode => Object.hash(id, name, lat, lng);

  factory Poi.fromJson(Map<String, dynamic> json) {
    return Poi(
      id: json['id'] as int,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }
}