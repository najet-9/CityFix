//this is the home page
//if u want to display the email : final user = FirebaseAuth.instance.currentUser;
import 'package:cityfix/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  AuthController authController = AuthController();

  signOut() async {
    await authController.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(child: Text('Welcome to the Home Screen!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => signOut(),
        child: const Icon(Icons.logout),
      ),
    );
  }
}
