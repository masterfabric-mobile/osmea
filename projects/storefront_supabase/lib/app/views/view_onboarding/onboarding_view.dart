import 'package:flutter/material.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class OnboardingView extends StatelessWidget {
  final void Function(String) goRoute;

  const OnboardingView({super.key, required this.goRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.resources.onboarding)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.resources.onboardingScreen),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => goRoute('/home'),
              child: Text(context.resources.goToHome),
            ),
          ],
        ),
      ),
    );
  }
}
