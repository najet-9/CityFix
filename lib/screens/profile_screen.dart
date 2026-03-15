import 'package:cityfix/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = ProfileController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FB), // Fond gris très clair
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildMenuItem(
                    Icons.assignment_outlined,
                    "My Reports",
                    Colors.brown[300]!,
                  ),
                  _buildMenuItem(Icons.language, "Language", Colors.blue[300]!),
                  _buildMenuItem(
                    Icons.lock_outline,
                    "Privacy & Security",
                    Colors.green[300]!,
                  ),
                  _buildMenuItem(
                    Icons.help_outline,
                    "Help & Support",
                    Colors.red[300]!,
                  ),
                  _buildMenuItem(
                    Icons.door_front_door_outlined,
                    "Sign Out",
                    Colors.red[200]!,
                    isLogout: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),

      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4267F2), Color(0xFF2B58E4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white, size: 30),
          onPressed: () {
            // Action à faire quand on clique sur le bouton
            print("Bouton + cliqué");
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Widget _buildHeader() {
  String userName =
      FirebaseAuth.instance.currentUser?.email?.split('@')[0] ?? "User";
  return Container(
    padding: EdgeInsets.only(top: 60, bottom: 30),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF2962FF), Color(0xFF448AFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
    ),
    child: Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, size: 50, color: Colors.grey),
        ),
        SizedBox(height: 10),
        Text(
          userName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Active Citizen . Algiers",
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "🏆 Top Contributor",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCard("12", "Reports"),
            _buildStatCard("8", "Resolved"),
            _buildStatCard("145", "Points"),
          ],
        ),
      ],
    ),
  );
}

Widget _buildStatCard(String value, String label) {
  return Container(
    width: 80,
    padding: EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white24,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    ),
  );
}

Widget _buildMenuItem(
  IconData icon,
  String title,
  Color iconBg, {
  bool isLogout = false,
}) {
  var controller;
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: isLogout ? Colors.red[50] : Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
      ],
    ),
    child: ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBg.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconBg),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () =>
          isLogout ? controller.signOut() : controller.navigateTo(title),
    ),
  );
}

Widget _buildBottomNav(BuildContext context) {
  // On ajoute le context ici
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: 3, // Tu es sur l'onglet Profil
    selectedItemColor: Colors.blue[800],
    unselectedItemColor: Colors.grey,
    onTap: (index) {
      if (index == 0) {
        // Cette ligne "ferme" ton écran de profil et affiche celui qui est dessous (le Home)
        Navigator.pop(context);
      }
    },
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: "Map"),
      BottomNavigationBarItem(
        icon: Icon(Icons.notifications_outlined),
        label: "Alerts",
      ),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
    ],
  );
}
