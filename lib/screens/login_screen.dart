import 'package:cityfix/controllers/auth_controller.dart';
import 'package:cityfix/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cityfix/widgets/input_field.dart';
import 'package:cityfix/widgets/primary_gradient_button.dart';
import 'package:cityfix/screens/home_screen.dart';
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
  //backend==============================
  _signIn() async {
    setState(() => loading = true);
    await _authController.signIn(
      _emailController.text,
      _passwordController.text,
    );
    setState(() => loading = false);
    Navigator.of(context).pop();
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
                        const Text(
                          'Welcome back ',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Sign in to continue improving your city',
                          style: TextStyle(
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
                      placeholder: 'Email address',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    // Password
                    InputField(
                      controller: _passwordController,
                      icon: Icons.lock_outline,
                      placeholder: 'Password',
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
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1D4ED8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Sign in button
                    loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF1D4ED8),
                            ),
                          )
                        : PrimaryGradientButton(
                            text: 'Sign In →',
                            onPressed: _signIn,
                          ),
                    const SizedBox(height: 28),
                    // Or continue with divider
                    Row(
                      children: [
                        Expanded(
                          child: Container(height: 1, color: Color(0xFFE2E8F0)),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or continue with',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(height: 1, color: Color(0xFFE2E8F0)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Google sign-in
                    OutlinedButton(
                      onPressed: () async {
                        await AuthController().signInWithGoogle();
                        Navigator.pushReplacement(
                         context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
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
                          const Text(
                            'Continue with Google',
                            style: TextStyle(
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
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
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
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
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
