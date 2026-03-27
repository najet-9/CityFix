import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to CITYFIX DZ",
      "subtitle":
          "Report urban problems in seconds and help improve your city.",
      "image": "assets/onboarding1.png", // Remplace par tes images
    },
    {
      "title": "Report Issues Instantly",
      "subtitle":
          "Take a photo, add a description, and we automatically capture your location.",
      "image": "assets/onboarding2.png",
    },
    {
      "title": "Track & Get Notified",
      "subtitle":
          "Follow your reports in real-time and get notified when problems are resolved.",
      "image": "assets/onboarding3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (value) => setState(() => _currentPage = value),
              itemCount: onboardingData.length,
              itemBuilder: (context, index) => _buildPageContent(index),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                // Indicateurs (Dots)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                    (index) => _buildDot(index),
                  ),
                ),
                const Spacer(),
                // Boutons de navigation
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => _pageController.jumpToPage(2),
                        child: const Text(
                          "Skip",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage == 2) {
                            _showLoginOptions(context);
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2B58E4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                        child: Text(
                          _currentPage == 2 ? "Get Started" : "Next",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(int index) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image illustrative
          Image.network(
            // Utilise Image.asset une fois tes fichiers ajoutés
            "https://cdni.iconscout.com/illustration/premium/thumb/city-maintenance-illustration-download-in-svg-png-gif-file-formats--construction-builder-road-pack-people-illustrations-5217145.png",
            height: 300,
          ),
          const SizedBox(height: 40),
          Text(
            onboardingData[index]["title"]!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B58E4),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            onboardingData[index]["subtitle"]!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? const Color(0xFF2B58E4)
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // --- MODAL OU PAGE DE CHOIX LOGIN/SIGNUP (p1 sur ton image) ---
  void _showLoginOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2B58E4), Color(0xFF4221C1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "CITYFIX DZ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "See it. Report it. Fix it.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 60),
            _buildAuthButton("Sign Up", Colors.white, const Color(0xFF2B58E4)),
            const SizedBox(height: 20),
            _buildAuthButton(
              "Sign In",
              Colors.transparent,
              Colors.white,
              isOutline: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthButton(
    String text,
    Color bg,
    Color textColor, {
    bool isOutline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            side: isOutline ? const BorderSide(color: Colors.white) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
