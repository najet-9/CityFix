import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/incident_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/incident_model.dart';

// ON CHANGE EN STATEFUL POUR QUE LA RECHERCHE ET LE SETSTATE MARCHENT
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final IncidentController _controller = IncidentController();
  final TextEditingController _searchController = TextEditingController();

  // Liste qui sera filtrée par la barre de recherche
  List<Incident> _filteredIncidents = [];

  @override
  void initState() {
    super.initState();
    // Au début, on affiche tous les incidents du contrôleur
    _filteredIncidents = _controller.fetchIncidents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. FOND DE CARTE (Optimisé avec limites de zoom)
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(
                36.75,
                3.05,
              ), // Centre sur ton pays (Algérie)
              initialZoom: 13.0,
              minZoom: 3.0, // Évite les images bizarres en dézoomant trop
              maxZoom: 18.0, // Évite les erreurs en zoomant trop fort
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.cityfix.app',
              ),

              // 2. LES MARQUEURS (Dynamiques selon la recherche)
              MarkerLayer(
                markers: _filteredIncidents.map((incident) {
                  return Marker(
                    point: incident.location,
                    width: 45,
                    height: 45,
                    child: _buildMarkerIcon(
                      incident.type == "water" ? Colors.blue : Colors.red,
                      incident.type == "water"
                          ? Icons.water_drop
                          : Icons.warning,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // 3. BARRE DE RECHERCHE FONCTIONNELLE
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Incident Map",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        // LOGIQUE DE RECHERCHE EN TEMPS RÉEL
                        setState(() {
                          _filteredIncidents = _controller
                              .fetchIncidents()
                              .where((incident) {
                                return incident.title.toLowerCase().contains(
                                  value.toLowerCase(),
                                );
                              })
                              .toList();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Search a neighborhood...",
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 4. BOUTON CENTRAL "+" (Action à brancher)
      floatingActionButton: GestureDetector(
        onTap: () {
          print("Ouverture de l'interface de signalement...");
          // Navigator.push(context, MaterialPageRoute(builder: (context) => AddIncidentPage()));
        },
        child: _buildCenterButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 5. BARRE DE NAVIGATION (Propre et sans doublon)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Fixé sur Map
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2B58E4),
        unselectedItemColor: Colors.grey,
        onTap: (index) => NavigationController.switchPage(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE DESIGN ---

  Widget _buildMarkerIcon(Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
        border: Border.all(color: color.withOpacity(0.5), width: 2),
      ),
      child: Center(child: Icon(icon, color: color, size: 20)),
    );
  }

  Widget _buildCenterButton() {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4267F2), Color(0xFF2B58E4)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 30),
    );
  }
}
