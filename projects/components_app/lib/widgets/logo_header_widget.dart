import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../utils/asset_paths.dart';

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
            child: Image.asset(
              AssetPaths.osmeaLogo,
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Image error: $error');
                return const Icon(
                  Icons.dashboard_outlined,
                  size: 40,
                  color: OsmeaColors.black,
                );
              },
            ),
          ),
        ),
        OsmeaComponents.sizedBox(height: 24),

        // Welcome Text
        OsmeaComponents.text(
          'Ready to Explore?',
          textStyle: OsmeaTextStyle.headlineMedium(context).copyWith(
            fontWeight: FontWeight.w700,
            color: OsmeaColors.black,
            letterSpacing: -0.5,
          ),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.text(
          'Access the complete MasterFabric Components library',
          textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
            color: OsmeaColors.slate,
          ),
        ),
        OsmeaComponents.sizedBox(height: 32),
      ],
    );
  }
}
