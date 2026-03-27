import 'package:flutter/material.dart';
import 'package:cityfix/screens/profile_screen.dart';
import 'package:cityfix/screens/submit_page.dart';
import 'package:cityfix/screens/incident_map_screen.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      // Le body contient tout le contenu visuel
      body: Column(
        children: [
          // HEADER BLEU
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 70,
              left: 25,
              right: 25,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF2B58E4),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Stay Updated",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(height: 5),
                Text(
                  "Notifications",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // LISTE DES NOTIFICATIONS
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 5),
                  child: Text(
                    "TODAY",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),

                _buildNotificationCard(
                  Icons.check_circle,
                  Colors.green.shade100,
                  Colors.green,
                  "Your report #031 has been resolved",
                  showDot: true,
                  dotColor: Colors.teal,
                ),
                _buildNotificationCard(
                  Icons.refresh,
                  Colors.blue.shade50,
                  Colors.blue,
                  "Report #020 assigned to field team",
                  showDot: true,
                  dotColor: Colors.blue,
                ),
                _buildNotificationCard(
                  Icons.warning_amber_rounded,
                  Colors.orange.shade50,
                  Colors.orange,
                  "Urgent incident detected near you",
                ),
                _buildNotificationCard(
                  Icons.thumb_up,
                  Colors.amber.shade50,
                  Colors.amber,
                  "2 people confirmed your report",
                ),
              ],
            ),
          ),
        ],
      ),

      // LA BARRE DE NAVIGATION EST ICI, HORS DU BODY
      bottomNavigationBar: _buildCustomBottomBar(context),
    );
  }

  // MÉTHODE POUR UNE CARTE DE NOTIFICATION

  Widget _buildNotificationCard(
    IconData icon,
    Color bgIcon,
    Color iconColor,
    String title, {
    bool showDot = false,
    Color dotColor = Colors.transparent,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgIcon,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),

          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          if (showDot)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  // LA BARRE DE NAVIGATION PERSONNALISÉE

  Widget _buildCustomBottomBar(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            Icons.home_outlined,
            "Home",
            onTap: () => Navigator.pop(context),
          ),
          _navItem(
            Icons.map_outlined,
            "Maps",
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => IncidentMapScreen(),
              ), // Utilise le nom EXACT de ta classe Map
            ),
          ),

          // BOUTON CENTRAL "+" FLOTTANT
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubmitPage(),
                ), // Assure-toi d'importer SubmitPage
              );
            },
            child: Transform.translate(
              offset: const Offset(0, -15),
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFF2B58E4),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2B58E4).withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
          _navItem(Icons.notifications, "Alerts", isSelected: true),

          _navItem(
            Icons.person_outline,
            "Profile",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  // WIDGET POUR CHAQUE ÉLÉMENT DE NAVIGATION
  Widget _navItem(
    IconData icon,
    String label, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF2B58E4) : Colors.grey[400],
            size: 28,
          ),

          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF2B58E4) : Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
