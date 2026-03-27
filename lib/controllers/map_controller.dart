import 'package:cityfix/models/incident_model.dart';

class MapIncidentController {
  // Simulez ou récupérez vos données ici
  List<Incident> getIncidents() {
    return [
      Incident(
        id: "1",
        type: "water",
        latitude: 34.8817,
        longitude: -1.3167,
      ), // Tlemcen par ex
      Incident(id: "2", type: "road", latitude: 34.8850, longitude: -1.3200),
    ];
  }
}
