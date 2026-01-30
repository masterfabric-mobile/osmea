import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:apis/apis.dart';
import 'package:go_router/go_router.dart';
import 'package:api_explorer/routes/app_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _progressValue;

  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkExistingConfiguration();
  }

  Future<void> _checkExistingConfiguration() async {
    try {
      debugPrint('🔧 Checking existing store configuration...');

      // Check if there's already a configured store
      final currentStore = await WizardHelper.getCurrentStore();

      if (currentStore != null) {
        debugPrint('✅ Found existing store: ${currentStore.storeName}');
        
        // Show splash animation even if store exists
        _initializeApp();
        return;
      }

      debugPrint('ℹ️ No existing store found, showing setup wizard');
      _initializeApp();
    } catch (e) {
      debugPrint('❌ Error checking configuration: $e');
      // Hata durumunda da devam et
      _initializeApp();
    }
  }

  Future<void> _initializeApp() async {
    try {
      // Web için ek initialization
      if (kIsWeb) {
        // Web'de DOM hazır olmasını bekle
        await Future.delayed(const Duration(milliseconds: 100));
      }

      setState(() {
        _isInitialized = true;
      });

      _startAnimationSequence();
    } catch (e) {
      debugPrint('❌ Error during app initialization: $e');
      setState(() {
        _hasError = true;
      });

      // Hata durumunda 3 saniye sonra home'a git
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _navigateToHome();
        }
      });
    }
  }

  void _initializeAnimations() {
    // Logo animations - extended duration for better visibility
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _logoRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
    );

    // Text animations - extended duration
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeInOut,
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Progress animation - extended duration
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startAnimationSequence() async {
    if (!mounted || !_isInitialized) return;

    try {
      debugPrint('🔧 Starting animation sequence...');

      // Run animations in parallel for smoother experience
      await Future.wait([
        _logoController.forward(),
        _textController.forward(),
        _progressController.forward(),
      ]);

      // Extended delay before navigation to show splash longer
      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        debugPrint('🔧 Navigating to home...');
        _navigateToHome();
      }
    } catch (e) {
      debugPrint('❌ Error during animation sequence: $e');
      // Hata durumunda da home'a git
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    if (!mounted) return;
    context.go(AppRouter.home);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hata durumunda basit loading göster
    if (_hasError) {
      return OsmeaComponents.scaffold(
        body: OsmeaComponents.container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                OsmeaColors.sunsetGlow,
                OsmeaColors.deepSea,
                OsmeaColors.atlantic,
              ],
            ),
          ),
          child: OsmeaComponents.center(
            child: OsmeaComponents.column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(OsmeaColors.white),
                ),
                OsmeaComponents.sizedBox(height: context.spacing20),
                OsmeaComponents.text(
                  'Loading...',
                  color: OsmeaColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return OsmeaComponents.scaffold(
      body: OsmeaComponents.container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              OsmeaColors.sunsetGlow,
              OsmeaColors.deepSea,
              OsmeaColors.atlantic,
            ],
          ),
        ),
        child: OsmeaComponents.center(
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScale.value,
                    child: Transform.rotate(
                      angle: _logoRotation.value * 0.5,
                      child: OsmeaComponents.container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: OsmeaColors.white.withValues(alpha: 0.2),
                          borderRadius: context.borderRadiusMedium,
                          border: Border.all(
                            color: OsmeaColors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: OsmeaColors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.api_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),

              OsmeaComponents.sizedBox(height: context.spacing40),

              // Animated Text
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: OsmeaComponents.column(
                        children: [
                          OsmeaComponents.text(
                            'OSMEA APIs',
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: OsmeaColors.white,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(
                                color: OsmeaColors.black.withValues(alpha: 0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          OsmeaComponents.sizedBox(height: context.spacing8),
                          OsmeaComponents.text(
                            'Modern API Testing Platform',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: OsmeaColors.white.withValues(alpha: 0.9),
                            letterSpacing: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              OsmeaComponents.sizedBox(height: context.spacing64),

              // Animated Progress Bar
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return OsmeaComponents.container(
                    width: 200,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: context.borderRadiusLow,
                      color: OsmeaColors.white.withValues(alpha: 0.3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _progressValue.value,
                      child: OsmeaComponents.container(
                        decoration: BoxDecoration(
                          borderRadius: context.borderRadiusLow,
                          color: OsmeaColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: OsmeaColors.white.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              OsmeaComponents.sizedBox(height: context.spacing20),

              // Loading text
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _progressController,
                    child: OsmeaComponents.text(
                      'Loading API Explorer...',
                      fontSize: 14,
                      color: OsmeaColors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
