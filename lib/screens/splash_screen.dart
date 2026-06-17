import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_finance_platform/providers/index.dart';
import 'package:ai_finance_platform/utils/index.dart';
import 'package:ai_finance_platform/widgets/finance_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _ringController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _textFadeAnim;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateAfterDelay();
  }

  void _setupAnimations() {
    // Logo entry (fade + elastic scale)
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _textFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    // Continuously spinning ring
    _ringController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat();

    _entryController.forward();
  }

  void _navigateAfterDelay() {
    Future.delayed(AppConstants.splashDuration, () {
      if (!mounted) return;
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        Navigator.of(context)
            .pushReplacementNamed(AppConstants.dashboardRoute);
      } else {
        Navigator.of(context).pushReplacementNamed(AppConstants.loginRoute);
      }
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050D1F),
      body: Container(
        // Subtle radial background glow emanating from center
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.9,
            colors: [
              Color(0xFF0A1833),
              Color(0xFF050D1F),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Logo + animated ring ───────────────────────────────────
                FadeTransition(
                  opacity: _fadeAnim,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    child: AnimatedBuilder(
                      animation: _ringController,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Static outer glow ring
                            Container(
                              width: 178,
                              height: 178,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF2979FF)
                                      .withOpacity(0.15),
                                  width: 1,
                                ),
                              ),
                            ),

                            // Spinning arc (the "loading line around the logo")
                            SizedBox(
                              width: 174,
                              height: 174,
                              child: Transform.rotate(
                                angle:
                                    _ringController.value * 2 * math.pi,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF2979FF),
                                  ),
                                  backgroundColor: const Color(0xFF2979FF)
                                      .withOpacity(0.08),
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                            ),

                            // Gold accent spinning arc (offset phase)
                            SizedBox(
                              width: 164,
                              height: 164,
                              child: Transform.rotate(
                                angle: (_ringController.value + 0.5) *
                                    2 *
                                    math.pi,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Color(0xFFFFD54F),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  strokeCap: StrokeCap.round,
                                  value: 0.25,
                                ),
                              ),
                            ),

                            // The logo itself
                            child!,
                          ],
                        );
                      },
                      child: const FinanceAILogo(size: 120),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ── App name & tagline ─────────────────────────────────────
                FadeTransition(
                  opacity: _textFadeAnim,
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF82B1FF),
                            Color(0xFFFFFFFF),
                            Color(0xFF82B1FF),
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          'FINANCE AI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Smart Financial Intelligence',
                        style: TextStyle(
                          color: Color(0xFF8BA3C9),
                          fontSize: 14,
                          letterSpacing: 2.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
