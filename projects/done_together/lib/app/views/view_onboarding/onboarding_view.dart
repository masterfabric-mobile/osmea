/*
 * OnboardingView
 * ---------------
 * İlk kullanımda gösterilen onboarding akışı.
 * Core'daki OnboardingView kullanılır; bitince veya skip'te ana sayfaya (/) yönlendirilir.
 */

import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';

/// Done Together onboarding ekranı. Core OnboardingView ile aynı yapı;
/// tamamlanınca veya atlanınca [goRoute] ile ana sayfaya gider.
class OnboardingView extends StatelessWidget {
  const OnboardingView({
    super.key,
    required this.goRoute,
  });

  final void Function(String path) goRoute;

  void _goHome() => goRoute('/');

  @override
  Widget build(BuildContext context) {
    return core.OnboardingView(
      goRoute: goRoute,
      arguments: const {'onboarding': true},
      onCompleted: _goHome,
      onSkipped: _goHome,
      onContinue: _goHome,
      onError: (message) => debugPrint('Onboarding error: $message'),
    );
  }
}
