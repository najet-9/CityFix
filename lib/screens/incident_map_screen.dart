import 'package:cityfix/controllers/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cityfix/screens/home_screen.dart';
import 'package:cityfix/screens/alerts_screen.dart';
import 'package:cityfix/screens/profile_screen.dart';
import 'package:cityfix/screens/submit_page.dart'; // Vérifie le chemin exact

// Importe tes autres interfaces ici pour que la navigation fonctionne
// import 'package:cityfix/screens/home_screen.dart';
// import 'package:cityfix/screens/profile_screen.dart';

class IncidentMapScreen extends StatelessWidget {
  final MapIncidentController controller = MapIncidentController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. La Carte
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(34.8817, -1.3167),
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.cityfix',
              ),
              MarkerLayer(
                markers: controller.getIncidents().map((incident) {
                  return Marker(
                    point: LatLng(incident.latitude, incident.longitude),
                    width: 40,
                    height: 40,
                    child: _buildMarkerIcon(incident.type),
                  );
                }).toList(),
              ),
            ],
          ),

          // 2. Barre de recherche flottante
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Incident Map",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.grey),
                      hintText: "Search a neighborhood...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // --- AJOUT DE LA BARRE DE NAVIGATION ICI ---
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, Icons.home_outlined, "Home"),
              _navItem(
                context,
                Icons.map,
                "Map",
                isSelected: true,
              ), // Sélectionné ici
              SizedBox(width: 40), // Espace pour le bouton central "+"
              _navItem(context, Icons.notifications_outlined, "Alerts"),
              _navItem(context, Icons.person_outline, "Profile"),
            ],
          ),
        ),
      ),

      // Bouton central "+"
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2B58E4), // Ton bleu spécifique
        onPressed: () {
          // On ajoute la navigation ici :
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const SubmitPage(), // Assure-toi que SubmitPage est bien importée en haut
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Fonction de navigation personnalisée

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label, {
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () {
        // Si on clique sur un bouton qui n'est pas déjà sélectionné
        if (!isSelected) {
          if (label == "Home") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (label == "Alerts") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AlertsScreen()),
            );
          } else if (label == "Profile") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }
          // Pas besoin de condition pour Map car on y est déjà (isSelected est true)
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkerIcon(String type) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Icon(
        type == 'water' ? Icons.water_drop : Icons.local_activity,
        color: Colors.blue,
        size: 20,
      ),
    );
  }
}
