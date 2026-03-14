import 'package:cityfix/controllers/auth_controller.dart';
import 'package:cityfix/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cityfix/models/user_model.dart';
import 'package:cityfix/widgets/input_field.dart';
import 'package:cityfix/widgets/password_strength_indicator.dart';
import 'package:cityfix/widgets/primary_gradient_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final AuthController _authController = AuthController();

  bool showPass = false;

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {
      setState(() {});
    });
  }

  //backend ---------------------------------------------------------------------
  _signUp() async {
    try {
      final user = UserModel(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text, //R
      );

      await _authController.signUp(user, _confirmPasswordController.text);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
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
  //------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(
              top: 52,
              left: 28,
              right: 28,
              bottom: 36,
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
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0x1AFFFFFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Create account ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Join and help improve your city today',
                  style: TextStyle(fontSize: 14, color: Color(0x99FFFFFF)),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: Column(
                  children: [
                    InputField(
                      controller: _fullNameController,
                      icon: Icons.person_outline,
                      placeholder: 'Full name',
                    ),

                    const SizedBox(height: 14),

                    InputField(
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      placeholder: 'Email address',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 14),

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

                    if (_passwordController.text.isNotEmpty)
                      PasswordStrengthIndicator(
                        password: _passwordController.text,
                      ),

                    const SizedBox(height: 14),

                    InputField(
                      controller: _confirmPasswordController,
                      icon: Icons.lock_outline,
                      placeholder: 'Confirm password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 28),

                    PrimaryGradientButton(
                      text: 'Create Account ',
                      onPressed: () => _signUp(),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Sign In',
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
            ),
          ),
        ],
      ),
    );
  }
}
