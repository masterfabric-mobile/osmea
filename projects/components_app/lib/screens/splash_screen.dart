import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/asset_paths.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _fadeOpacity;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    _fadeOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    // Start logo animation
    _logoController.forward();

    // Start text animation after logo starts
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // Start fade animation
    await Future.delayed(const Duration(milliseconds: 500));
    _fadeController.forward();

    // Onboarding disabled for now: always go to main screen
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) context.go('/');

    // --- Onboarding (commented out for now) ---
    // await _checkOnboardingAndNavigate();
  }

  // ignore: unused_element
  Future<void> _checkOnboardingAndNavigate() async {
    // try {
    //   final prefs = await OnboardingPrefs.instance;
    //   final hasSeenOnboarding = await prefs.hasSeenOnboarding();
    //   debugPrint('📱 Onboarding status: ${hasSeenOnboarding ? "Seen" : "Not seen"}');
    //   if (mounted) {
    //     if (hasSeenOnboarding) {
    //       debugPrint('🚀 Navigating to main screen (onboarding already seen)');
    //       context.go('/');
    //     } else {
    //       debugPrint('📚 Navigating to onboarding screen');
    //       context.go('/intro');
    //     }
    //   }
    // } catch (e) {
    //   debugPrint('❌ Error checking onboarding status: $e');
    //   if (mounted) context.go('/intro');
    // }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      body: OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animation
            ScaleTransition(
              scale: _logoScale,
              child: FadeTransition(
                opacity: _logoOpacity,
                child: OsmeaComponents.container(
                  width: 120,
                  height: 120,
                  child: Image.asset(
                    AssetPaths.osmeaLogo,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            OsmeaComponents.sizedBox(height: 32),

            // Text Animation
            SlideTransition(
              position: _textSlide,
              child: FadeTransition(
                opacity: _fadeOpacity,
                child: OsmeaComponents.column(
                  children: [
                    OsmeaComponents.text(
                      'MasterFabric Components',
                      variant: OsmeaTextVariant.headlineLarge,
                      color: OsmeaColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    OsmeaComponents.sizedBox(height: 8),
                    OsmeaComponents.text(
                      'Enterprise Flutter Components',
                      variant: OsmeaTextVariant.bodyMedium,
                      color: OsmeaColors.grayMaterial,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
