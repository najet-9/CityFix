import 'package:cityfix/controllers/auth_controller.dart';
import 'package:cityfix/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cityfix/widgets/input_field.dart';
import 'package:cityfix/widgets/primary_gradient_button.dart';
import 'package:cityfix/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart' as ez;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  bool showPass = false;
  bool loading = false;

  //==============================================BACKEND==============================

  // 2. Added Reset Password Logic
  _resetPassword() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ez.tr("Please enter your email address first."),
          ), // Changé en ez.tr()
          backgroundColor: const Color(0xFF1D4ED8),
        ),
      );
      return;
    }

    try {
      // Send reset email via Firebase
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ez.tr("Password reset link sent! Check your inbox."),
          ), // Changé en ez.tr()
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  _signIn() async {
    //try to sign in
    try {
      setState(() => loading = true);
      await _authController.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (!mounted) return; // "if I'm no longer on screen, stop here"
      setState(() => loading = false);
      Navigator.of(context).popUntil((route) => route.isFirst);
      //if an exception occurs, we catch it and show a snackbar with the error message
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            //1] e.toString() gives us the full error message,
            //which starts with "Exception: " followed by the actual message we threw in the AuthController
            //2] we remove the "Exception: " part from the error message to make it cleaner
            e.toString().replaceAll('Exception: ', ''),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color(0xFF1D4ED8),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
  //====================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with circles
              Container(
                padding: const EdgeInsets.only(
                  top: 60,
                  left: 28,
                  right: 28,
                  bottom: 44,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1D4ED8),
                      Color(0xFF2563EB),
                      Color(0xFF3B82F6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(32),
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -80,
                      right: -60,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: const BoxDecoration(
                          color: Color(0x12FFFFFF),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -20,
                      right: 30,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color(0x0CFFFFFF),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CityFix DZ',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          ez.tr('Welcome back '), // Changé en ez.tr()
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          ez.tr('Sign in to continue improving your city'),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xBFFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Form section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    // Email
                    InputField(
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      placeholder: ez.tr('Email address'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    // Password
                    InputField(
                      controller: _passwordController,
                      icon: Icons.lock_outline,
                      placeholder: ez.tr('Password'),
                      obscureText: !showPass,
                      rightEl: IconButton(
                        icon: Icon(
                          showPass
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF94A3B8),
                          size: 20,
                        ),
                        onPressed: () => setState(() => showPass = !showPass),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 3. Wrapped "Forgot password?" text with GestureDetector
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _resetPassword,
                        child: Text(
                          ez.tr('Forgot password?'),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1D4ED8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Sign in button
                    //loading================================================
                    loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF1D4ED8),
                            ),
                          )
                        : PrimaryGradientButton(
                            text: ez.tr('Sign In →'),
                            onPressed: _signIn,
                          ),
                    const SizedBox(height: 28),
                    // Or continue with divider
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: const Color(0xFFE2E8F0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            ez.tr('or continue with'),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: const Color(0xFFE2E8F0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Google sign-in
                    OutlinedButton(
                      onPressed: () async {
                        await AuthController().signInWithGoogle();
                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(
                          color: Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'G',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.blue.shade600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            ez.tr('Continue with Google'),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Switch to sign up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ez.tr("Don't have an account? "),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            );
                          },
                          child: Text(
                            ez.tr('Sign Up'),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1D4ED8),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
