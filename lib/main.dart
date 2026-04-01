import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cityfix/firebase_options.dart';
import 'package:cityfix/screens/wrapper.dart'; 
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

      theme: ThemeData(
        textTheme: GoogleFonts.soraTextTheme(),

        scaffoldBackgroundColor: const Color(0xFFF8F9FE),

        primaryColor: const Color(0xFF2B58E4),
        useMaterial3: true,
      ),

      // Le Wrapper est le point d'entrée qui gère la logique de session
      home: const Wrapper(),
    );
  }
}