import 'package:flutter/material.dart';
import '../controllers/privacy_security_controller.dart';

class PrivacySecurityScreen extends StatelessWidget {
  PrivacySecurityScreen({super.key});

  final PrivacySecurityController controller =
      PrivacySecurityController();

  final TextEditingController passwordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy & Security"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            //  Change password
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "New Password",
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () async {
                await controller.changePassword(
                  passwordController.text,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Password updated"),
                  ),
                );
              },
              child: const Text("Change Password"),
            ),

            const SizedBox(height: 20),

            //  Delete account
            ElevatedButton(
              onPressed: () async {
                await controller.deleteAccount();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Account deleted"),
                  ),
                );
              },
              child: const Text("Delete Account"),
            ),

            const SizedBox(height: 20),

            //  Logout
            ElevatedButton(
              onPressed: () async {
                await controller.signOut();
                Navigator.pop(context);
              },
              child: const Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}