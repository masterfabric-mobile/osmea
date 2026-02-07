import 'package:flutter/material.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension; 

class OnboardingView extends StatelessWidget {
  final void Function(String) goRoute;

  const OnboardingView({super.key, required this.goRoute});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(
          context.resources.onboarding,
          textStyle: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OsmeaComponents.text(context.resources.onboardingScreen),
            OsmeaComponents.sizedBox(height: 20),
            OsmeaComponents.button(
              onPressed: () => goRoute('/home'),
              text: context.resources.goToHome,
            ),
          ],
        ),
      ),
    );
  }
}
