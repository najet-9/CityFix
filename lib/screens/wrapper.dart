//this is the wrapper class which will decide which screen to show based on the authentication state of the user
import 'package:cityfix/screens/home_screen.dart';
import 'package:cityfix/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //Stream (S)
      stream: FirebaseAuth.instance.authStateChanges(),
      //builder (B)
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
