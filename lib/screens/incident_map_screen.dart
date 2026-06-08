import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cityfix/screens/home_screen.dart';
import 'package:cityfix/screens/alerts_screen.dart';
import 'package:cityfix/screens/profile_screen.dart';
import 'package:cityfix/screens/submit_page.dart';
import 'package:cityfix/services/report_service.dart';
import 'package:cityfix/models/report_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:easy_localization/easy_localization.dart';

class IncidentMapScreen extends StatefulWidget {
  const IncidentMapScreen({super.key});

  @override
  State<IncidentMapScreen> createState() => _IncidentMapScreenState();
}

class _IncidentMapScreenState extends State<IncidentMapScreen> {
  final ReportService _reportService = ReportService();
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //  MAP WITH FIREBASE DATA
          StreamBuilder<List<ReportModel>>(
            stream: _reportService.getReports(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final reports = snapshot.data!;

              return FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: LatLng(
                    36.737,
                    3.088,
                  ), // Coordonnées par défaut
                  initialZoom: 13,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.cityfix',
                  ),

                  //  MARKERS FROM FIREBASE
                  MarkerLayer(
                    markers: reports.map((report) {
                      return Marker(
                        point: LatLng(
                          report.location.latitude,
                          report.location.longitude,
                        ),
                        width: 40,
                        height: 40,
                        child: _buildMarkerIcon(report.category),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),

          //  SEARCH UI
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Incident Map".tr(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search, color: Colors.grey),
                      hintText: "Search a neighborhood...".tr(),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) async {
                      try {
                        List<Location> locations = await locationFromAddress(
                          value,
                        );

                        if (locations.isNotEmpty) {
                          final lat = locations.first.latitude;
                          final lng = locations.first.longitude;

                          _mapController.move(LatLng(lat, lng), 15);
                        }
                      } catch (e) {
                        print("Erreur: $e");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      //  NAV BAR
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, Icons.home_outlined, "Home".tr()),
              _navItem(context, Icons.map, "Maps".tr(), isSelected: true),
              const SizedBox(width: 40),
              _navItem(context, Icons.notifications_outlined, "Alerts".tr()),
              _navItem(context, Icons.person_outline, "Profile".tr()),
            ],
          ),
        ),
      ),

      //  BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2B58E4),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SubmitPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  //  NAVIGATION
  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label, {
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          // Comparaison avec les traductions pour maintenir la logique de navigation
          if (label == "Home".tr()) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (label == "Alerts".tr()) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AlertsScreen()),
            );
          } else if (label == "Profile".tr()) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }
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

  //  MARKER STYLE
  Widget _buildMarkerIcon(String type) {
    IconData icon;

    switch (type.toLowerCase()) {
      case "water":
        icon = Icons.water_drop;
        break;
      case "lighting":
        icon = Icons.lightbulb;
        break;
      case "roads":
        icon = Icons.warning;
        break;
      default:
        icon = Icons.location_on;
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Icon(icon, color: Colors.blue, size: 20),
    );
  }
}
