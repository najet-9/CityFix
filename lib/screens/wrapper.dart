import 'package:cityfix/screens/auth_choice_screen.dart'; // Ton écran p1
import 'package:cityfix/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cityfix/controllers/auth_controller.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = AuthController();

    // Listen to auth state and cache name as soon as user is confirmed logged in
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        await authController.getUserName(); // wait for it
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        }

        return const AuthChoiceScreen();
      },
    );
  }
}
