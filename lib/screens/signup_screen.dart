import 'package:cityfix/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:cityfix/widgets/input_field.dart';
import 'package:cityfix/widgets/primary_gradient_button.dart';
import 'package:cityfix/widgets/password_strength_indicator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final AuthController authController = AuthController();

  bool showPass = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    password.addListener(() => setState(() {}));
  }

  // --- LOGIQUE BACKEND COMPLÈTE ---
  Future<void> _handleSignUp() async {
    // 1. Vérifications locales
    if (fullName.text.isEmpty || email.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    if (password.text != confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Les mots de passe ne correspondent pas")),
      );
      return;
    }

    // 2. Lancement du chargement
    setState(() => isLoading = true);

    try {
      // 3. Appel au contrôleur Firebase
      await authController.signUp(
        fullName.text.trim(),
        email.text.trim(),
        password.text.trim(),
        confirmPassword.text.trim(),
      );
      
      // Pas de navigation manuelle ! 
      // Le Wrapper détectera le changement d'état via StreamBuilder.
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Dégradé
          Container(
            padding: const EdgeInsets.only(top: 52, left: 28, right: 28, bottom: 36),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1D4ED8), Color(0xFF2563EB), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(height: 24),
                const Text('Create account ✨', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26, color: Colors.white)),
              ],
            ),
          ),

          // Formulaire
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  InputField(controller: fullName, icon: Icons.person_outline, placeholder: 'Full name'),
                  const SizedBox(height: 14),
                  InputField(controller: email, icon: Icons.email_outlined, placeholder: 'Email address', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 14),
                  InputField(
                    controller: password,
                    icon: Icons.lock_outline,
                    placeholder: 'Password',
                    obscureText: !showPass,
                    rightEl: IconButton(
                      icon: Icon(showPass ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => showPass = !showPass),
                    ),
                  ),
                  if (password.text.isNotEmpty) PasswordStrengthIndicator(password: password.text),
                  const SizedBox(height: 14),
                  InputField(controller: confirmPassword, icon: Icons.lock_outline, placeholder: 'Confirm password', obscureText: true),
                  const SizedBox(height: 28),
                  
                  // Bouton avec état de chargement
                  isLoading 
                    ? const CircularProgressIndicator(color: Color(0xFF1D4ED8))
                    : PrimaryGradientButton(
                        text: 'Create Account 🚀', 
                        onPressed: _handleSignUp,
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}