import '../models/incident_model.dart';
import 'package:latlong2/latlong.dart';

class IncidentController {
  // On place la liste ici pour qu'elle soit accessible partout dans la classe
  final List<Incident> _allIncidents = [
    Incident(
      id: "1",
      title: "Fuite d'eau importante",
      description: "Une canalisation a sauté dans la rue principale.",
      location: LatLng(19.4326, -99.1332),
      type: "water",
      status: "pending",
    ),
    Incident(
      id: "2",
      title: "Trou dans la chaussée",
      description: "Nid de poule dangereux pour les motos.",
      location: LatLng(19.4350, -99.1310),
      type: "road",
      status: "resolved",
    ),
    Incident(
      id: "3",
      title: "Panne d'éclairage",
      description: "Tout le quartier est dans le noir.",
      location: LatLng(19.4310, -99.1350),
      type: "electricity",
      status: "pending",
    ),
  ];

  // Cette fonction renvoie TOUS les incidents (utilisée au démarrage)
  List<Incident> fetchIncidents() {
    return _allIncidents;
  }

  // OPTIONNEL : Une fonction spécifique pour la recherche si tu veux
  // garder la logique de filtrage dans le contrôleur (MVC pur)
  List<Incident> searchIncidents(String query) {
    if (query.isEmpty) return _allIncidents;
    return _allIncidents.where((incident) {
      return incident.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
