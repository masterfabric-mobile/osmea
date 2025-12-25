import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class LogoHeaderWidget extends StatelessWidget {
  const LogoHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.sizedBox(height: 60),
        Center(
          child: OsmeaComponents.container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: OsmeaColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: OsmeaColors.silver,
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 40,
              color: OsmeaColors.black,
            ),
          ),
        ),
        OsmeaComponents.sizedBox(height: 24),
        OsmeaComponents.text(
          context.resources.welcomeTitle,
          textStyle: OsmeaTextStyle.headlineMedium(context).copyWith(
            fontWeight: FontWeight.w700,
            color: OsmeaColors.black,
            letterSpacing: -0.5,
          ),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.text(
          context.resources.welcomeSubtitle,
          textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
            color: OsmeaColors.slate,
          ),
        ),
        OsmeaComponents.sizedBox(height: 32),
      ],
    );
  }
}