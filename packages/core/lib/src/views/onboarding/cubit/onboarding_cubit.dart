import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:core/src/base/base_view_model_cubit.dart';
import 'package:core/src/models/onboarding_models.dart';
import 'package:core/src/helper/onboarding_helper.dart';
import 'package:core/src/helper/asset_config_helper.dart';
import 'package:core/src/views/onboarding/cubit/onboarding_state.dart';
import 'package:injectable/injectable.dart';

/// 🎯 **OSMEA Onboarding Cubit**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Cubit that manages onboarding operations with MVVM pattern
///
/// {@category ViewModels}
/// {@subCategory OnboardingCubit}

@injectable
class OnboardingCubit extends BaseViewModelCubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  final OnboardingStorageHelper _storageHelper = OnboardingStorageHelper();
  final AssetConfigHelper _configHelper = AssetConfigHelper();

  PageController? _pageController;

  /// 🎮 Initialize PageController
  void initializePageController(PageController pageController) {
    _pageController = pageController;
  }

  /// 🎮 Dispose PageController
  void disposePageController() {
    _pageController?.dispose();
    _pageController = null;
  }

  /// 📱 Load onboarding data
  Future<void> loadOnboardingData() async {
    try {
      stateChanger(state.copyWith(status: OnboardingStatus.loading));

      // Load app config (project-specific first, then core fallback)
      final configLoaded =
          await _configHelper.loadConfig('assets/app_config.json') ||
              await _configHelper.loadConfig();

      if (!configLoaded) {
        // Use default config if no config file found
        final defaultConfig = _getDefaultOnboardingConfig();
        stateChanger(state.copyWith(
          status: OnboardingStatus.ready,
          config: defaultConfig,
          currentPageIndex: 0,
          totalPages: defaultConfig.pages.length,
          hasSeenOnboarding: false,
        ));
        return;
      }

      // Get onboarding data from app config
      final configData = _configHelper.getAllConfig();
      final onboardingData = configData?['onboarding_configuration'];

      if (onboardingData == null) {
        // Use default config if onboarding section not found
        final defaultConfig = _getDefaultOnboardingConfig();
        stateChanger(state.copyWith(
          status: OnboardingStatus.ready,
          config: defaultConfig,
          currentPageIndex: 0,
          totalPages: defaultConfig.pages.length,
          hasSeenOnboarding: false,
        ));
        return;
      }

      final onboardingConfig = OnboardingConfigModel.fromJson(onboardingData);

      // Use defaults if no pages found
      if (onboardingConfig.pages.isEmpty) {
        final defaultConfig = _getDefaultOnboardingConfig();
        stateChanger(state.copyWith(
          status: OnboardingStatus.ready,
          config: defaultConfig,
          currentPageIndex: 0,
          totalPages: defaultConfig.pages.length,
          hasSeenOnboarding: false,
        ));
        return;
      }

      // Get campaign images and merge with onboarding pages
      final campaignImages = _getCampaignImages(configData);
      final mergedConfig = _mergeCampaignImagesWithOnboarding(
        onboardingConfig,
        campaignImages,
      );

      // Check onboarding seen status
      final hasSeenOnboarding = await _storageHelper.hasSeenOnboarding();

      stateChanger(state.copyWith(
        status: OnboardingStatus.ready,
        config: mergedConfig,
        currentPageIndex: 0,
        hasSeenOnboarding: hasSeenOnboarding,
        totalPages: mergedConfig.pages.length,
      ));
    } catch (e) {
      debugPrint("❌ Error occurred while loading onboarding data: $e");
      stateChanger(state.copyWith(
        status: OnboardingStatus.error,
        errorMessage: "Failed to load data: ${e.toString()}",
      ));
    }
  }

  /// ➡️ Go to next page
  void nextPage() {
    if (state.config == null) return;

    final nextIndex = state.currentPageIndex + 1;

    if (nextIndex < state.config!.pages.length) {
      debugPrint("➡️ Moving to next page: $nextIndex");
      stateChanger(state.copyWith(currentPageIndex: nextIndex));
    } else {
      debugPrint("✅ Last page, finishing onboarding");
      finishOnboarding();
    }
  }

  /// ⬅️ Go to previous page
  void previousPage() {
    if (state.currentPageIndex > 0) {
      final prevIndex = state.currentPageIndex - 1;
      debugPrint("⬅️ Moving to previous page: $prevIndex");
      stateChanger(state.copyWith(currentPageIndex: prevIndex));
    }
  }

  /// 🎯 Go to specific page
  void goToPage(int pageIndex) {
    if (state.config == null) return;

    if (pageIndex >= 0 && pageIndex < state.config!.pages.length) {
      debugPrint("🎯 Going to page $pageIndex");
      stateChanger(state.copyWith(currentPageIndex: pageIndex));

      // Animate PageController if available
      if (_pageController != null && _pageController!.hasClients) {
        _pageController!.animateToPage(
          pageIndex,
          duration:
              Duration(milliseconds: state.config?.animationDuration ?? 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  /// ⏭️ Skip onboarding
  void skipOnboarding() {
    debugPrint("⏭️ Skipping onboarding");
    // Mark as skipped in state
    stateChanger(state.copyWith(
      status: OnboardingStatus.skipped,
    ));
    // Also finish the onboarding process
    finishOnboarding();
  }

  /// ✅ Finish onboarding
  Future<void> finishOnboarding() async {
    try {
      debugPrint("✅ Finishing onboarding...");

      // Mark onboarding as seen
      await _storageHelper.markOnboardingSeen();

      stateChanger(state.copyWith(
        status: OnboardingStatus.completed,
        hasSeenOnboarding: true,
      ));

      debugPrint("🎉 Onboarding completed successfully!");
    } catch (e) {
      debugPrint("❌ Error while finishing onboarding: $e");
      stateChanger(state.copyWith(
        status: OnboardingStatus.error,
        errorMessage: "Could not complete onboarding: ${e.toString()}",
      ));
    }
  }

  /// 🔄 Reset onboarding (Developer mode)
  Future<void> resetOnboarding() async {
    if (kDebugMode) {
      try {
        debugPrint("🔄 Resetting onboarding (DEV)...");

        await _storageHelper.resetOnboardingStatus();

        stateChanger(state.copyWith(
          status: OnboardingStatus.ready,
          currentPageIndex: 0,
          hasSeenOnboarding: false,
        ));

        debugPrint("✅ Onboarding reset successfully!");
      } catch (e) {
        debugPrint("❌ Error while resetting onboarding: $e");
      }
    }
  }

  /// 📊 Check onboarding status
  Future<void> checkOnboardingStatus() async {
    try {
      final hasSeenOnboarding = await _storageHelper.hasSeenOnboarding();

      stateChanger(state.copyWith(hasSeenOnboarding: hasSeenOnboarding));

      debugPrint("📊 Onboarding status checked: $hasSeenOnboarding");
    } catch (e) {
      debugPrint("❌ Error while checking onboarding status: $e");
    }
  }

  /// 🎮 Start auto advance
  void startAutoAdvance() {
    if (state.config?.autoAdvanceSeconds != null &&
        state.config!.autoAdvanceSeconds! > 0) {
      debugPrint(
          "🎮 Starting auto advance: ${state.config!.autoAdvanceSeconds} seconds");

      Future.delayed(Duration(seconds: state.config!.autoAdvanceSeconds!), () {
        if (!isClosed && state.status == OnboardingStatus.ready) {
          nextPage();
        }
      });
    }
  }

  /// 📱 Get current page information
  OnboardingPageModel? get currentPage {
    if (state.config == null) return null;
    if (state.currentPageIndex >= state.config!.pages.length) return null;

    return state.config!.pages[state.currentPageIndex];
  }

  /// 🏁 Check if last page
  bool get isLastPage {
    if (state.config == null) return false;
    return state.currentPageIndex >= state.config!.pages.length - 1;
  }

  /// 🏠 Check if first page
  bool get isFirstPage {
    return state.currentPageIndex <= 0;
  }

  /// 📊 Calculate progress percentage
  double get progress {
    if (state.config == null || state.config!.pages.isEmpty) return 0.0;
    return (state.currentPageIndex + 1) / state.config!.pages.length;
  }

  /// 🐛 Get debug information
  Future<Map<String, dynamic>> getDebugInfo() async {
    if (kDebugMode) {
      final storageDebug = await _storageHelper.getOnboardingDebugInfo();

      return {
        'cubit_state': {
          'status': state.status.toString(),
          'current_page_index': state.currentPageIndex,
          'total_pages': state.totalPages,
          'has_seen_onboarding': state.hasSeenOnboarding,
          'config_loaded': state.config != null,
          'error_message': state.errorMessage,
        },
        'storage_info': storageDebug,
        'current_page': currentPage?.toString(),
        'is_last_page': isLastPage,
        'is_first_page': isFirstPage,
        'progress': progress,
      };
    }
    return {};
  }

  /// 🖼️ Get campaign images from config
  List<String> _getCampaignImages(Map<String, dynamic>? configData) {
    try {
      final homeView = configData?['home_view'] as Map<String, dynamic>?;
      if (homeView == null) return [];

      final campaignCards = homeView['campaign_cards'] as Map<String, dynamic>?;
      if (campaignCards == null) return [];

      final items = campaignCards['items'] as List<dynamic>?;
      if (items == null || items.isEmpty) return [];

      final imageUrls = <String>[];
      for (final item in items) {
        final map = item as Map<String, dynamic>;
        final imageUrl = map['imageUrl'] as String?;
        if (imageUrl != null && imageUrl.isNotEmpty) {
          imageUrls.add(imageUrl);
        }
      }

      debugPrint('🖼️ Found ${imageUrls.length} campaign images');
      return imageUrls;
    } catch (e) {
      debugPrint('⚠️ Failed to load campaign images: $e');
      return [];
    }
  }

  /// 🔄 Merge campaign images with onboarding pages
  OnboardingConfigModel _mergeCampaignImagesWithOnboarding(
    OnboardingConfigModel onboardingConfig,
    List<String> campaignImages,
  ) {
    if (campaignImages.isEmpty) {
      return onboardingConfig;
    }

    final mergedPages = <OnboardingPageModel>[];
    int campaignIndex = 0;

    for (int i = 0; i < onboardingConfig.pages.length; i++) {
      final page = onboardingConfig.pages[i];
      
      // If page has no image_url, use campaign image
      if ((page.imageUrl == null || page.imageUrl!.isEmpty) &&
          (page.imagePath == null || page.imagePath!.isEmpty) &&
          (page.iconUrl == null || page.iconUrl!.isEmpty) &&
          (page.iconPath == null || page.iconPath!.isEmpty)) {
        
        // Use campaign image if available
        if (campaignIndex < campaignImages.length) {
          final campaignImageUrl = campaignImages[campaignIndex];
          debugPrint('🖼️ Using campaign image for page $i: $campaignImageUrl');
          
          mergedPages.add(
            page.copyWith(imageUrl: campaignImageUrl),
          );
          campaignIndex++;
        } else {
          // Reuse campaign images if we run out
          final reuseIndex = campaignIndex % campaignImages.length;
          final campaignImageUrl = campaignImages[reuseIndex];
          debugPrint('🖼️ Reusing campaign image for page $i: $campaignImageUrl');
          
          mergedPages.add(
            page.copyWith(imageUrl: campaignImageUrl),
          );
          campaignIndex++;
        }
      } else {
        // Keep original page with its image
        mergedPages.add(page);
      }
    }

    return onboardingConfig.copyWith(pages: mergedPages);
  }

  /// 🎮 Get default onboarding config for fallback
  OnboardingConfigModel _getDefaultOnboardingConfig() {
    debugPrint("🎮 Using default onboarding configuration");

    // Create a simple default onboarding config
    return OnboardingConfigModel(
      style: OnboardingStyle.basic,
      animationDuration: 300,
      autoAdvanceSeconds: 0,
      showSkipButton: true,
      showPageIndicator: true,
      primaryColor: "#FFFFFF",
      secondaryColor: "#000000",
      pages: [
        OnboardingPageModel(
          title: "Welcome to the App",
          description:
              "This is a default onboarding page created when configuration could not be loaded.",
          imagePath: "",
          backgroundColor: "#FFFFFF",
          textColor: "#000000",
          buttonText: "Next",
          skipText: "Skip",
          nextText: "Next",
        ),
        OnboardingPageModel(
          title: "Start Using the App",
          description: "You can now start using the application.",
          imagePath: "",
          backgroundColor: "#FFFFFF",
          textColor: "#000000",
          buttonText: "Get Started",
          skipText: "Skip",
          nextText: "Next",
        ),
      ],
    );
  }
}
