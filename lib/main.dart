import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cityfix/firebase_options.dart';
import 'package:cityfix/screens/wrapper.dart'; // Import unique du Wrapper
import 'package:cityfix/screens/profile_screen.dart';
import 'package:cityfix/screens/login_screen.dart';
import 'package:cityfix/screens/signup_screen.dart';
import 'package:cityfix/screens/home_screen.dart';
import 'package:cityfix/screens/onboarding_screen.dart';

void main() async {
  // 1. Initialisation des services Flutter et Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Lancement de l'application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityFix DZ',
      debugShowCheckedModeBanner: false,

      // Configuration du thème global pour correspondre à ton design
      theme: ThemeData(
        // Utilisation de la police Sora comme dans ton design initial
        textTheme: GoogleFonts.soraTextTheme(),

        // Couleur de fond générale (Blanc cassé/bleuté)
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),

        // Palette de couleurs principales
        primaryColor: const Color(0xFF2B58E4),
        useMaterial3: true,
      ),

      // Le Wrapper est le point d'entrée qui gère la logique de session
      home: const Wrapper(),
    );
  }
}