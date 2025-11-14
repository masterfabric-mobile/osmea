import 'package:flutter/foundation.dart';
import 'package:core/core.dart';
import 'package:core/src/models/empty_view_models.dart';
import 'package:core/src/helper/asset_config_helper.dart';
import 'package:core/src/views/empty_view/cubit/empty_view_state.dart';

/// 🎯 **OSMEA Empty View Cubit**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Cubit that manages empty view operations with MVVM pattern
///
/// {@category ViewModels}
/// {@subCategory EmptyViewCubit}

class EmptyViewCubit extends BaseViewModelCubit<EmptyViewState> {
  EmptyViewCubit() : super(const EmptyViewState());

  final AssetConfigHelper _configHelper = AssetConfigHelper();

  /// 📱 Load empty view configuration
  Future<void> loadEmptyViewConfig() async {
    try {
      emit(state.copyWith(status: EmptyViewStatus.loading));

      debugPrint("📱 Loading empty view configuration...");

      // Load app config (project-specific first, then core fallback)
      final configLoaded =
          await _configHelper.loadConfig('assets/app_config.json');
      if (!configLoaded) {
        debugPrint("❌ Failed to load configuration file, using default config");
        _useDefaultConfig();
        return;
      }

      // Get empty view data from app config
      final configData = _configHelper.getAllConfig();

      if (configData == null) {
        debugPrint("❌ Configuration data not found, using default config");
        _useDefaultConfig();
        return;
      }

      // Parse empty view config
      final emptyViewData = configData['empty_view_configuration'];
      if (emptyViewData == null) {
        debugPrint(
            "❌ Empty view configuration not found, using default config");
        _useDefaultConfig();
        return;
      }

      final emptyViewConfig =
          EmptyViewConfigModel.fromJson(emptyViewData);

      debugPrint(
          "✅ Empty view configuration loaded successfully. Style: ${emptyViewConfig.style.name}, Empty pages: ${emptyViewConfig.emptyPages.length}");

      // Log basic configuration
      debugPrint("🎨 Empty view style: ${emptyViewConfig.style.name}");
      debugPrint("⚙️ Configuration details:");
      debugPrint(
          "   - Animation duration: ${emptyViewConfig.animationDuration}ms");
      debugPrint(
          "   - Primary color: ${emptyViewConfig.primaryColor ?? 'default'}");

      emit(state.copyWith(
        status: EmptyViewStatus.initial,
        config: emptyViewConfig,
      ));
    } catch (e) {
      debugPrint(
          "❌ Error occurred while loading empty view configuration: $e");
      _useDefaultConfig();
    }
  }

  /// 📭 Show empty view with specific type
  Future<void> showEmpty({
    required EmptyType emptyType,
    String? customTitle,
    String? customDescription,
    String? customImagePath,
    String? customIconPath,
  }) async {
    try {
      debugPrint("📭 Showing empty view: $emptyType");

      // Load config if not loaded
      if (!state.hasConfig) {
        await loadEmptyViewConfig();
      }

      // Get empty page for this empty type
      final emptyPage = state.config?.emptyPages[emptyType];

      emit(state.copyWith(
        status: EmptyViewStatus.showingEmpty,
        currentEmptyType: emptyType,
        currentEmptyPage: emptyPage,
        customTitle: customTitle,
        customDescription: customDescription,
        customImagePath: customImagePath,
        customIconPath: customIconPath,
      ));
    } catch (e) {
      debugPrint("❌ Error occurred while showing empty view: $e");
      // Fallback to basic empty display
      emit(state.copyWith(
        status: EmptyViewStatus.showingEmpty,
        currentEmptyType: emptyType,
        customTitle: customTitle ?? 'No items found',
        customDescription: customDescription ?? 'There are no items to display.',
      ));
    }
  }

  /// 👁️ Hide empty view
  void hideEmpty() {
    debugPrint("👁️ Hiding empty view");

    emit(state.copyWith(
      status: EmptyViewStatus.hidden,
    ));
  }

  /// 🛠️ Use default configuration
  void _useDefaultConfig() {
    debugPrint("🔧 Creating default empty view configuration");

    final defaultConfig = EmptyViewConfigModel(
      emptyPages: {
        EmptyType.general: const EmptyPageModel(
          title: 'No items found',
          description: 'There are no items to display at the moment.',
          emptyType: EmptyType.general,
        ),
        EmptyType.cart: const EmptyPageModel(
          title: 'Your cart is empty',
          description: 'Add items to your cart to see them here.',
          emptyType: EmptyType.cart,
        ),
        EmptyType.search: const EmptyPageModel(
          title: 'No results found',
          description: 'Try adjusting your search terms.',
          emptyType: EmptyType.search,
        ),
      },
      style: EmptyViewStyle.startup,
      animationDuration: 400,
      primaryColor: '#2196F3',
      secondaryColor: '#FFC107',
    );

    emit(state.copyWith(
      status: EmptyViewStatus.initial,
      config: defaultConfig,
    ));

    debugPrint("✅ Default empty view configuration loaded");
  }

  /// 🎯 Quick empty methods for common empty types

  Future<void> showCartEmpty({
    String? customTitle,
    String? customDescription,
    String? customImagePath,
    String? customIconPath,
  }) async {
    await showEmpty(
      emptyType: EmptyType.cart,
      customTitle: customTitle,
      customDescription: customDescription,
      customImagePath: customImagePath,
      customIconPath: customIconPath,
    );
  }

  Future<void> showSearchEmpty({
    String? customTitle,
    String? customDescription,
    String? customImagePath,
    String? customIconPath,
  }) async {
    await showEmpty(
      emptyType: EmptyType.search,
      customTitle: customTitle,
      customDescription: customDescription,
      customImagePath: customImagePath,
      customIconPath: customIconPath,
    );
  }

  Future<void> showFavoritesEmpty({
    String? customTitle,
    String? customDescription,
    String? customImagePath,
    String? customIconPath,
  }) async {
    await showEmpty(
      emptyType: EmptyType.favorites,
      customTitle: customTitle,
      customDescription: customDescription,
      customImagePath: customImagePath,
      customIconPath: customIconPath,
    );
  }

  Future<void> showWishlistEmpty({
    String? customTitle,
    String? customDescription,
    String? customImagePath,
    String? customIconPath,
  }) async {
    await showEmpty(
      emptyType: EmptyType.wishlist,
      customTitle: customTitle,
      customDescription: customDescription,
      customImagePath: customImagePath,
      customIconPath: customIconPath,
    );
  }

  Future<void> showProductsEmpty({
    String? customTitle,
    String? customDescription,
    String? customImagePath,
    String? customIconPath,
  }) async {
    await showEmpty(
      emptyType: EmptyType.products,
      customTitle: customTitle,
      customDescription: customDescription,
      customImagePath: customImagePath,
      customIconPath: customIconPath,
    );
  }

  Future<void> showOrdersEmpty({
    String? customTitle,
    String? customDescription,
    String? customImagePath,
    String? customIconPath,
  }) async {
    await showEmpty(
      emptyType: EmptyType.orders,
      customTitle: customTitle,
      customDescription: customDescription,
      customImagePath: customImagePath,
      customIconPath: customIconPath,
    );
  }
}
