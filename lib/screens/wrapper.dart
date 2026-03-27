import 'package:cityfix/screens/auth_choice_screen.dart';
import 'package:cityfix/screens/home_screen.dart';
import 'package:cityfix/screens/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cityfix/controllers/auth_controller.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late final AuthController authController;
  bool?
  _showOnboarding; // null = chargement, true = voir onboarding, false = fini

  @override
  void initState() {
    super.initState();
    authController = AuthController();
    _checkOnboardingStatus();

    // Écoute les changements de session Firebase
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        await authController.getUserName();
      }
    });
  }

  // Vérifie SharedPreferences une seule fois au démarrage
  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seen_onboarding') ?? false;
    if (mounted) {
      setState(() {
        _showOnboarding = !seen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Écran de chargement pendant que l'app lit les réglages
    if (_showOnboarding == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 1. Priorité à l'Onboarding si c'est la première fois
    if (_showOnboarding == true) {
      return const OnboardingScreen();
    }

    // 2. Sinon, on gère l'Auth Firebase normalement
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }

        return const AuthChoiceScreen();
      },
    );
  }
}
