import 'package:latlong2/latlong.dart';

class Incident {
  final String id;
  final String title;
  final String description;
  final LatLng location; // Coordonnées GPS pour la carte
  final String type; // Exemple: 'water', 'road', 'electricity'
  final String status; // Exemple: 'pending', 'resolved'

  Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    this.status = 'pending',
  });
}
