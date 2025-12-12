/*
 * SplashView
 * ------------
 * This file implements the splash screen for the Admin Dashboard app.
 * It demonstrates a clean separation of UI and navigation logic using a ViewModel.
 *
 * - UI: Displays a logo, app title, version, and credits.
 * - Navigation: Delegated to the ViewModel via a callback for testability and maintainability.
 */
import 'package:admin_dashboard/core/resources/resources.g.dart';
import 'package:admin_dashboard/app/views/view_splash/models/module/events.dart';
import 'package:admin_dashboard/app/views/view_splash/models/module/states.dart';
import 'package:admin_dashboard/app/views/view_splash/models/splash_view_model.dart';
import 'package:core/core.dart' hide SplashView, SplashState;
import 'package:flutter/material.dart';
import 'package:admin_dashboard/gen/assets.gen.dart';

/// SplashView displays the splash screen and delegates navigation logic to the ViewModel.
///
/// - Shows a logo in the center
/// - Shows app title, version, and credits at the bottom
/// - Triggers navigation to the home screen after splash logic completes
class SplashView extends MasterView<SplashViewModel, SplashEvent, SplashState> {
  SplashView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
  });

  @override
  void initialContent(SplashViewModel viewModel, BuildContext context) async {
    // --- Splash Logic Trigger ---
    // This method is called when the view is first built.
    // It delegates splash logic (timing, navigation) to the ViewModel.
    // The ViewModel will call the provided callback when it's time to navigate.
    viewModel.startSplashLogic(context, (route) {
      // [Callback] Navigates to the given route when ViewModel decides.
      navigateTo(context, route);
    });
  }

  @override
  Widget viewContent(
    BuildContext context,
    SplashViewModel viewModel,
    SplashState state,
  ) {
    // --- Splash Screen Layout ---
    // Navigation is now handled in the ViewModel via callback, so no check is needed here.
    return OsmeaComponents.column(
      mainAxisAlignment:
          spaceBetween, // Distributes space between top, center, and bottom
      children: [
        // ──────────────────────────────────────────────
        // Top right decorative container (visual accent, DEV mode only)
        // ──────────────────────────────────────────────
        // Show the decorative container only if the current flavor is DEV (runtime check)
        Builder(
          builder: (context) {
            final isDev = arguments["isDev"] as bool? ?? false;
            final environment =
                arguments["environment"] as String? ?? "unknown";
            debugPrint(
              'Current Environment from arguments: $environment (isDev: $isDev)',
            );
            if (isDev) {
              return OsmeaComponents.row(
                mainAxisAlignment: end,
                children: [
                  OsmeaComponents.container(
                    size: ContainerSize.tiny,
                    color: OsmeaColors.atlantic,
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // ──────────────────────────────────────────────
        // Centered logo (brand identity)
        // ──────────────────────────────────────────────
        OsmeaComponents.expanded(
          child: OsmeaComponents.center(
            child: OsmeaComponents.image(
              size: ImageSize.extraLarge,
              assetPath: Assets.images.osmeaLogoBlack.path,
            ),
          ),
        ),

        // ──────────────────────────────────────────────
        // Bottom section: title, version, and credits
        // ──────────────────────────────────────────────
        OsmeaComponents.column(
          mainAxisAlignment: end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- App Title ---
            OsmeaComponents.text(
              resource.application_config.app_name,
              textStyle: OsmeaTextStyle.titleSmall(context),
            ),
            CoreSpacer(CoreSpacerType.section),

            // --- Version Info ---
            OsmeaComponents.text(
              resource.application_config.app_version,
              textStyle: OsmeaTextStyle.labelSmall(context),
            ),
            CoreSpacer(CoreSpacerType.section),

            // --- Footer: Credits Row ---
            OsmeaComponents.row(
              mainAxisAlignment: centerMain, // Center the credits row
              children: [
                // Inline credit text
                OsmeaComponents.text(
                  resource.views.splash.made_by,
                  textStyle: OsmeaTextStyle.labelSmall(context),
                ),
                CoreSpacer(CoreSpacerType.horizontal),
                // Company logo (small)
                OsmeaComponents.sizedBox(
                  width: context.normalValue,
                  height: context.normalValue,
                  child: OsmeaComponents.image(
                    assetPath: Assets.images.mfLogo.path,
                    size: ImageSize.small,
                  ),
                ),
                CoreSpacer(CoreSpacerType.horizontal),
                // Company name
                OsmeaComponents.text(
                  resource.views.splash.mf,
                  textStyle: OsmeaTextStyle.labelSmall(context),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
