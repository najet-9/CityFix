import 'package:cityfix/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cityfix/screens/home_screen.dart';
import 'package:cityfix/screens/alerts_screen.dart';
import 'package:cityfix/screens/submit_page.dart';
import 'package:cityfix/screens/privacy_security_screen.dart';
import 'package:cityfix/screens/incident_map_screen.dart';
import 'package:cityfix/screens/my_reports_screen.dart';
import 'package:cityfix/screens/help_support_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = AuthController();
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await authController.getUserName();
    if (mounted) {
      setState(() {
        userName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(20),
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
                  const SizedBox(height: 15),
                  _buildMenuItem(
                    context,
                    Icons.assignment_outlined,
                    "My Reports",
                    Colors.brown[300]!,
                  ),
                  _buildMenuItem(
                    context,
                    Icons.language,
                    "Language",
                    Colors.blue[300]!,
                  ),
                  _buildMenuItem(
                    context,
                    Icons.lock_outline,
                    "Privacy & Security",
                    Colors.green[300]!,
                  ),
                  _buildMenuItem(
                    context,
                    Icons.help_outline,
                    "Help & Support",
                    Colors.red[300]!,
                  ),
                  _buildMenuItem(
                    context,
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
      bottomNavigationBar: _buildCustomBottomBar(context),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      decoration: const BoxDecoration(
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
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Active Citizen . Algiers",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "🏆 Top Contributor",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    Color iconBg, {
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isLogout ? Colors.red[50] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
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
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () async {
          if (isLogout) {
            await authController.signOut();
            if (context.mounted) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            }
          } else if (title == "Privacy & Security") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacySecurityScreen()),
            );
          } else if (title == "My Reports") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyReportsScreen()),
            );
          } else if (title == "Help & Support") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildCustomBottomBar(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
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
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
          _navItem(
            Icons.map_outlined,
            "Maps",
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => IncidentMapScreen(),
              ), // Redirection vers la Map
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubmitPage()),
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
          _navItem(
            Icons.notifications_outlined,
            "Alerts",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AlertsScreen()),
              );
            },
          ),
          _navItem(Icons.person, "Profile", isSelected: true),
        ],
      ),
    );
  }

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
