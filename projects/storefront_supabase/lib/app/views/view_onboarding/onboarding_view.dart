import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// 🎯 Masterfabric S Store Onboarding View
/// Simple onboarding screen that doesn't use core package's OnboardingView
/// to avoid config conflicts with storefront_woo
class SupabaseOnboardingView extends StatefulWidget {
  final Function(String path) goRoute;
  final VoidCallback? onCompleted;
  final VoidCallback? onSkipped;

  const SupabaseOnboardingView({
    super.key,
    required this.goRoute,
    this.onCompleted,
    this.onSkipped,
  });

  @override
  State<SupabaseOnboardingView> createState() => _SupabaseOnboardingViewState();
}

class _SupabaseOnboardingViewState extends State<SupabaseOnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome',
      description: 'Discover amazing products',
      icon: Icons.shopping_bag,
    ),
    OnboardingPage(
      title: 'Easy Shopping',
      description: 'Browse and buy with ease',
      icon: Icons.favorite,
    ),
    OnboardingPage(
      title: 'Fast Delivery',
      description: 'Get your orders delivered quickly',
      icon: Icons.local_shipping,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onSkip() {
    widget.onSkipped?.call();
    widget.goRoute('/home');
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onCompleted?.call();
      widget.goRoute('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final configHelper = AssetConfigHelper();
    
    final backgroundColor = _parseColor(
      configHelper.getString('onboarding_configuration.background_color', '#FFFFFF'),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: OsmeaComponents.padding(
                padding: const EdgeInsets.all(16.0),
                child: OsmeaComponents.textButton(
                  text: 'Skip',
                  onPressed: _onSkip,
                  variant: ButtonVariant.ghost,
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => _buildIndicator(index == _currentPage),
              ),
            ),

            OsmeaComponents.sizedBox(height: 32),

            // Next/Get Started button
            OsmeaComponents.padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: OsmeaComponents.button(
                text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                onPressed: _onNext,
                variant: ButtonVariant.primary,
                backgroundColor: OsmeaColors.black,
                textColor: OsmeaColors.white,
                fullWidth: true,
                size: ButtonSize.large,
              ),
            ),

            OsmeaComponents.sizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.all(32.0),
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            page.icon,
            size: 120,
            color: OsmeaColors.black,
          ),
          OsmeaComponents.sizedBox(height: 48),
          OsmeaComponents.text(
            page.title,
            textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: OsmeaColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text(
            page.description,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              fontSize: 16,
              color: OsmeaColors.grayMaterial[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? OsmeaColors.black : OsmeaColors.grayMaterial[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      String hex = colorString.replaceAll('#', '');
      if (hex.length == 8) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      return OsmeaColors.white;
    } catch (e) {
      return OsmeaColors.white;
    }
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });
}
