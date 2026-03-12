import 'package:cityfix/screens/auth_choice_screen.dart'; // Ton écran p1
import 'package:cityfix/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Si l'utilisateur est connecté, on montre la Home
        if (snapshot.hasData) {
          return const HomeScreen();
        } 
        // Sinon, on montre l'écran de choix (Sign Up / Sign In)
        else {
          return const AuthChoiceScreen();
        }
      },
    );
  }
}