import 'package:flutter/material.dart';

class ReportDetailScreen extends StatelessWidget {
  const ReportDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- IMAGE HEADER AVEC BOUTON RETOUR ---
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4, // 40% de l'écran
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?q=80&w=1000',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Overlay pour le badge "In Progress"
              Positioned(
                top: 50,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "In Progress",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Bouton Retour
              Positioned(
                top: 50,
                left: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          // --- CONTENU DES DÉTAILS ---
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pothole",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1E)),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "2h ago",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 30),

                  // Boîte de Localisation
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F5FF), // Bleu très clair
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.location_on, color: Color(0xFF2B58E4)),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "LOCATION",
                              style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.2),
                            ),
                            const Text(
                              "Main Street, Downtown",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  const Spacer(), // Pousse le bouton vers le bas

                  // --- BOUTON DE CONFIRMATION ---
                  GestureDetector(
                    onTap: () {
                      // Action pour confirmer le problème
                    },
                    child: Container(
                      width: double.infinity,
                      height: 65,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4267F2), Color(0xFF2B58E4)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2B58E4).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.thumb_up, color: Colors.white, size: 24),
                          SizedBox(width: 12),
                          Text(
                            "Confirm Issue (13)",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}