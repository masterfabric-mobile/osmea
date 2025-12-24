import 'package:flutter/material.dart';
import 'package:storefront_supabase/l10n/app_localizations.dart';

class OnboardingView extends StatelessWidget {
  final void Function(String) goRoute;

  const OnboardingView({super.key, required this.goRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.onboarding)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.onboardingScreen),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => goRoute('/home'),
              child: Text(AppLocalizations.of(context)!.goToHome),
            ),
          ],
        ),
      ),
    );
  }
}
