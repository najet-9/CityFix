class Incident {
  final String id;
  final String type; // ex: 'water', 'road'
  final double latitude;
  final double longitude;

  Incident({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
  });
}
