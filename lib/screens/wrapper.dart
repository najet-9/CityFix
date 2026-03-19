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
        // 1. Waiting for Firebase response : Don’t show anything yet until Firebase finishes checking
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. User is logged in
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // 3. User is not logged in
        return const AuthChoiceScreen();
      },
    );
  }
}
