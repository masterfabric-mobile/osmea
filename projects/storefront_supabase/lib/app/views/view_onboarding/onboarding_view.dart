import 'package:flutter/material.dart';

class OnboardingView extends StatelessWidget {
  final void Function(String) goRoute;

  const OnboardingView({super.key, required this.goRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Onboarding Screen'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => goRoute('/home'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
