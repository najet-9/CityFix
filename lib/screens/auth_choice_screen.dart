import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cityfix/screens/login_screen.dart';
import 'package:cityfix/screens/signup_screen.dart';

// WelcomeScreen: the first screen users see.
// Full-screen blue gradient with an animated floating logo, app title, tagline,
// and two buttons: "Sign Up" and "Sign In".
class WelcomeScreen extends StatefulWidget {
  final VoidCallback onGetStarted; // Called when user taps "Sign Up"
  final VoidCallback onLogin; // Called when user taps "Sign In"

  const WelcomeScreen({
    super.key,
    required this.onGetStarted,
    required this.onLogin,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  // Controls the up-down bobbing animation of the logo
  late AnimationController _bobController;
  late Animation<double> _bobAnimation;

  // Controls the fade-in + slide-up entrance animation
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    // Bobbing animation: loops forever, reversing direction each cycle (3.6s per cycle)
    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat(reverse: true);

    // Translates the logo between 0px and -10px vertically (gentle float effect)
    _bobAnimation = Tween<double>(
      begin: 0,
      end: -10,
    ).animate(CurvedAnimation(parent: _bobController, curve: Curves.easeInOut));

    // Trigger entrance animation after the first frame is drawn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true); // ← fixed: mounted check
    });
  }

  @override
  void dispose() {
    // Always dispose animation controllers to free resources
    _bobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      // Blue gradient background (top → bottom)
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3B72D9), Color(0xFF2B5BBF), Color(0xFF1E4BAD)],
        ),
      ),
      child: Stack(
        children: [
          // ── Soft radial glow behind the logo
          // a "light bloom" effect behind the logo
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 340,
                height: 340,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0x268CB9FF), Colors.transparent],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // ── Main content
          SafeArea(
            child: AnimatedOpacity(
              // Fades in the entire content when _visible becomes true
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              child: Column(
                children: [
                  // ── Logo + Title + Tagline section
                  Expanded(
                    child: AnimatedSlide(
                      // Slides up from slightly below on entrance
                      offset: _visible ? Offset.zero : const Offset(0, 0.08),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Floating logo with bobbing animation
                          AnimatedBuilder(
                            animation: _bobAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                // Apply vertical offset from bob animation
                                offset: Offset(0, _bobAnimation.value),
                                child: child,
                              );
                            },
                            child: Transform.scale(
                              scale: 2.2,
                              child: Image.asset(
                                'assets/images/cityfix_logo.png',
                                width: 180,
                                height: 180,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const SizedBox(height: 36),
                          // App name — slides up with slight delay feel
                          AnimatedSlide(
                            offset: _visible
                                ? Offset.zero
                                : const Offset(0, 0.1),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOut,
                            child: Text(
                              'CITYFIX DZ',
                              style: GoogleFonts.sora(
                                fontWeight: FontWeight.w800,
                                fontSize: 30,
                                color: Colors.white,
                                letterSpacing: 3.0,
                                decoration: TextDecoration.none,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Tagline — same entrance animation as the title
                          AnimatedSlide(
                            offset: _visible
                                ? Offset.zero
                                : const Offset(0, 0.1),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOut,
                            child: Text(
                              'See It. Report It. Fix It.',
                              style: GoogleFonts.sora(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.5,
                                color: Colors.white.withValues(alpha: 0.72),
                                letterSpacing: 0.3,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Buttons section
                  AnimatedSlide(
                    offset: _visible ? Offset.zero : const Offset(0, 0.08),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
                      child: Column(
                        children: [
                          // Primary button: filled white → navigates to Sign Up
                          _WelcomeButton(
                            text: 'Sign Up',
                            filled: true,
                            onPressed: widget.onGetStarted,
                          ),

                          const SizedBox(height: 14),

                          // Secondary button: outlined → navigates to Sign In
                          _WelcomeButton(
                            text: 'Sign In',
                            filled: false,
                            onPressed: widget.onLogin,
                          ),

                          const SizedBox(height: 20),

                          // Decorative home-indicator style bar at the bottom
                          Center(
                            child: Container(
                              width: 36,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.28),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
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

// ── Welcome Button
// Reusable button used for both "Sign Up" (filled) and "Sign In" (outlined).
// Has a subtle scale-down press animation for tactile feedback.
class _WelcomeButton extends StatefulWidget {
  final String text;
  final bool
  filled; // true = white filled button, false = transparent outlined button
  final VoidCallback onPressed;

  const _WelcomeButton({
    required this.text,
    required this.filled,
    required this.onPressed,
  });

  @override
  State<_WelcomeButton> createState() => _WelcomeButtonState();
}

class _WelcomeButtonState extends State<_WelcomeButton> {
  bool _pressed =
      false; // Tracks whether the button is currently being held down

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        // Shrinks slightly when pressed for a "click" feel
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            // Filled = solid white, Outlined = transparent with white border
            color: widget.filled ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            border: widget.filled
                ? null
                : Border.all(
                    color: Colors.white.withValues(alpha: 0.45),
                    width: 2,
                  ),
            boxShadow: widget.filled
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 22,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: GoogleFonts.sora(
              fontWeight: widget.filled ? FontWeight.w700 : FontWeight.w600,
              fontSize: 17,
              decoration: TextDecoration.none,
              // Filled button: dark blue text; Outlined button: white text
              color: widget.filled ? const Color(0xFF1A45C8) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// Wrapper widget to keep existing API (AuthChoiceScreen) used by Wrapper.
class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeScreen(
      onGetStarted: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignupScreen()),
        );
      },
      onLogin: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
    );
  }
}
