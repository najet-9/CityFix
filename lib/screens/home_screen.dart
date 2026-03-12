//this is the home page
import 'package:cityfix/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _authController = AuthController();

  _signOut() async {
    await _authController.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(child: Text('Welcome to the Home Screen!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _signOut(),
        child: const Icon(Icons.logout),
      ),
    );
  }
}
