/*
 * OnboardingContent – space design from core (packages/core/.../onboarding_space_widget).
 * OsmeaColors + app_config; buttons and all from OsmeaComponents. Single background (no per-page color).
 */

import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:tiny_plates/app/core/helpers/color_helper.dart';
import 'package:tiny_plates/app/views/view_onboarding/models/module/onboarding_state.dart';
import 'package:tiny_plates/app/views/view_onboarding/models/onboarding_view_model.dart';
import 'package:tiny_plates/gen/strings.g.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.viewModel,
    required this.state,
  });

  final OnboardingViewModel viewModel;
  final OnboardingState state;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final primaryColor = colorFromHex(state.primaryColorHex, fallback: OsmeaColors.shark);
    final textColor = colorFromHex(state.textColorHex, fallback: OsmeaColors.shark);
    final loadingBgColor = colorFromHex(state.loadingBackgroundColorHex, fallback: OsmeaColors.white);
    final descriptionColor = textColor.withValues(alpha: 0.7);

    if (state.status == OnboardingStatus.loading) {
      return OsmeaComponents.container(
        color: loadingBgColor,
        child: OsmeaComponents.center(
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OsmeaComponents.loading(
                type: LoadingType.rotatingDots,
                size: 36,
                color: primaryColor,
              ),
              OsmeaComponents.sizedBox(height: context.spacing16),
              OsmeaComponents.text(
                t.loading,
                variant: OsmeaTextVariant.bodyMedium,
                color: OsmeaColors.steel,
              ),
            ],
          ),
        ),
      );
    }

    final pages = state.pages;
    if (pages.isEmpty) {
      return OsmeaComponents.container(
        color: loadingBgColor,
        child: OsmeaComponents.center(
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OsmeaComponents.text(
                t.onboardingNoPages,
                variant: OsmeaTextVariant.bodyLarge,
                color: textColor,
                textAlign: TextAlign.center,
              ),
              OsmeaComponents.sizedBox(height: context.spacing16),
              GestureDetector(
                onTap: () => viewModel.loadFromUrl(),
                child: OsmeaComponents.text(
                  t.retry,
                  variant: OsmeaTextVariant.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final pageCount = pages.length;
    final currentIndex = state.currentPage;
    final progress = pageCount > 0 ? (currentIndex + 1) / pageCount : 0.0;

    return OsmeaComponents.container(
      color: loadingBgColor,
      child: SafeArea(
        child: OsmeaComponents.container(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing24,
            vertical: context.spacing16,
          ),
          child: OsmeaComponents.column(
            children: [
              _buildTopSection(context, textColor),
              _buildProgressIndicator(context, progress, pageCount, primaryColor, textColor),
              Expanded(child: _buildPageContent(context, pages, currentIndex, textColor, descriptionColor)),
              _buildBottomNavigation(context, currentIndex, pageCount, primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context, Color textColor) {
    final t = context.t;
    return OsmeaComponents.container(
      height: context.height40,
      margin: EdgeInsets.only(bottom: context.spacing16),
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => viewModel.finish(),
            child: OsmeaComponents.text(
              t.onboardingSkip,
              variant: OsmeaTextVariant.bodySmall,
              color: textColor.withValues(alpha: 0.6),
              fontWeight: context.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(
    BuildContext context,
    double progress,
    int pageCount,
    Color primaryColor,
    Color textColor,
  ) {
    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: context.height64),
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.progress(
            type: ProgressType.linearRounded,
            value: progress,
            size: ProgressSize.small,
            progressColor: primaryColor,
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),
          OsmeaComponents.text(
            '${state.currentPage + 1} of $pageCount',
            variant: OsmeaTextVariant.bodySmall,
            color: textColor.withValues(alpha: 0.5),
            fontWeight: context.medium,
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(
    BuildContext context,
    List<Map<String, dynamic>> pages,
    int currentIndex,
    Color textColor,
    Color descriptionColor,
  ) {
    return OsmeaComponents.container(
      child: PageView.builder(
        controller: viewModel.pageController,
        onPageChanged: viewModel.goToPage,
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final page = pages[index];
          final title = page['title'] as String? ?? '';
          final description = page['description'] as String? ?? '';
          return OsmeaComponents.container(
            padding: EdgeInsets.symmetric(horizontal: context.spacing16),
            child: OsmeaComponents.column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OsmeaComponents.text(
                  title,
                  variant: OsmeaTextVariant.headlineLarge,
                  color: textColor,
                  fontWeight: context.bold,
                  textAlign: TextAlign.center,
                  lineHeight: context.lineHeightTight,
                ),
                OsmeaComponents.sizedBox(height: context.spacing32),
                OsmeaComponents.text(
                  description,
                  variant: OsmeaTextVariant.bodyLarge,
                  color: descriptionColor,
                  textAlign: TextAlign.justify,
                  lineHeight: context.lineHeightRelaxed,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigation(
    BuildContext context,
    int currentIndex,
    int pageCount,
    Color primaryColor,
  ) {
    final t = context.t;
    final isLast = currentIndex >= pageCount - 1;
    return OsmeaComponents.container(
      margin: EdgeInsets.only(top: context.height40),
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          isLast
              ? OsmeaComponents.button(
                  text: t.onboardingGetStarted,
                  onPressed: () => viewModel.finish(),
                  variant: ButtonVariant.ghost,
                  size: ButtonSize.medium,
                  backgroundColor: primaryColor,
                  textColor: primaryColor,
                )
              : OsmeaComponents.button(
                  text: t.onboardingNext,
                  onPressed: () => viewModel.nextPage(context),
                  variant: ButtonVariant.ghost,
                  size: ButtonSize.medium,
                  backgroundColor: primaryColor,
                  textColor: primaryColor,
                ),
        ],
      ),
    );
  }
}
