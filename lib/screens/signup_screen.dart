import 'package:cityfix/controllers/auth_controller.dart';
import 'package:cityfix/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:cityfix/models/user_model.dart';
import 'package:cityfix/widgets/input_field.dart';
import 'package:cityfix/widgets/password_strength_indicator.dart';
import 'package:cityfix/widgets/primary_gradient_button.dart';

import 'package:easy_localization/easy_localization.dart' as ez; 

import 'package:cityfix/screens/language_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthController _authController = AuthController();

  String? _selectedWilaya;
  final List<String> _wilayas = [
    "01 Adrar", 
    "02 Chlef",
     "03 Laghouat",
      "04 Oum El Bouaghi", 
      "05 Batna",
    "06 Béjaïa",
     "07 Biskra", 
     "08 Béchar", 
     "09 Blida", 
     "10 Bouira",
    "11 Tamanrasset", 
    "12 Tébessa", "13 Tlemcen",
     "14 Tiaret", 
     "15 Tizi Ouzou",
    "16 Alger",
     "17 Djelfa",
      "18 Jijel", 
      "19 Sétif", 
      "20 Saïda",
    "21 Skikda", 
    "22 Sidi Bel Abbès", 
    "23 Annaba", 
    "24 Guelma",
     "25 Constantine",
    "26 Médéa",
     "27 Mostaganem", 
     "28 M'Sila", 
     "29 Mascara",
      "30 Ouargla",
    "31 Oran", 
    "32 El Bayadh", 
    "33 Illizi", 
    "34 Bordj Bou Arreridj",
     "35 Boumerdès",
    "36 El Tarf", 
    "37 Tindouf",
     "38 Tissemsilt", 
     "39 El Oued",
      "40 Khenchela",
    "41 Souk Ahras",
     "42 Tipaza",
      "43 Mila",
       "44 Aïn Defla", 
       "45 Naâma",
    "46 Aïn Témouchent",
     "47 Ghardaïa", 
     "48 Relizane", 
     "49 El M'Ghair", 
     "50 El Meniaa",
    "51 Ouled Djellal",
     "52 Bordj Baji Mokhtar", 
     "53 Béni Abbès",
      "54 Timimoun", 
      "55 Touggourt",
    "56 Djanet", 
    "57 In Salah",
     "58 In Guezzam", 
     "59 Aflou", 
     "60 El Abiodh Sidi Cheikh",
    "61 El Aricha", 
    "62 Kantara",
     "63 Barika", 
     "64 Bou Saâda", 
     "65 Bir El Ater", 
     "66 Ksar El Boukhari",
    "67 Ksar Chellala", 
    "68 Aïn Oussara",
     "69 Messaad",
  ];

  bool showPass = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
  }

  _signUp() async {
    try {
      final user = UserModel(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phoneNumber: _phoneController.text,
        wilaya: _selectedWilaya?.replaceAll(RegExp(r'^\d+\s'), '') ?? '',
      );

      await _authController.signUp(user, _confirmPasswordController.text);
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll('Exception: ', ''),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF1D4ED8),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 52, left: 28, right: 28, bottom: 36),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1D4ED8), Color(0xFF2563EB), Color(0xFF3B82F6)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36, height: 36,
                    decoration: const BoxDecoration(color: Color(0x1AFFFFFF), shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  ez.tr('Create account '), // Utilisation de l'alias ez
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 26, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  ez.tr('Join and help improve your city today'), // Utilisation de l'alias ez
                  style: const TextStyle(fontSize: 14, color: Color(0x99FFFFFF)),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  children: [
                    InputField(
                      controller: _fullNameController,
                      icon: Icons.person_outline,
                      placeholder: ez.tr('Full name'), // Alias ici aussi
                    ),
                    const SizedBox(height: 14),
                    InputField(
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      placeholder: ez.tr('Email address'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    InputField(
                      controller: _phoneController,
                      icon: Icons.phone_outlined,
                      placeholder: ez.tr('Phone number'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedWilaya,
                          hint: Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: Color(0xFF94A3B8), size: 20),
                              const SizedBox(width: 12),
                              Text(ez.tr('Select wilaya'), style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 15)),
                            ],
                          ),
                          isExpanded: true,
                          items: _wilayas.map((String value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                          onChanged: (newValue) => setState(() => _selectedWilaya = newValue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    InputField(
                      controller: _passwordController,
                      icon: Icons.lock_outline,
                      placeholder: ez.tr('Password'),
                      obscureText: !showPass,
                      rightEl: IconButton(
                        icon: Icon(showPass ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: const Color(0xFF94A3B8), size: 20),
                        onPressed: () => setState(() => showPass = !showPass),
                      ),
                    ),
                    if (_passwordController.text.isNotEmpty)
                      PasswordStrengthIndicator(password: _passwordController.text),
                    const SizedBox(height: 14),
                    InputField(
                      controller: _confirmPasswordController,
                      icon: Icons.lock_outline,
                      placeholder: ez.tr('Confirm password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 28),
                    PrimaryGradientButton(
                      text: ez.tr('Create Account '),
                      onPressed: () => _signUp(),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(ez.tr('Already have an account? '), style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(ez.tr('Sign In'), style: const TextStyle(fontSize: 14, color: Color(0xFF1D4ED8), fontWeight: FontWeight.w700)),
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