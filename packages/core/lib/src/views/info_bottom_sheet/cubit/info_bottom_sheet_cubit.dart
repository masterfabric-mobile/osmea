import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/models/info_models.dart';
import 'package:core/src/views/info_bottom_sheet/cubit/info_bottom_sheet_state.dart';
import 'package:core/src/helper/asset_config_helper.dart';
import 'package:injectable/injectable.dart';

/// 🎯 **OSMEA Info Bottom Sheet Cubit**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Business logic for info bottom sheet system
///
/// {@category Cubit}
/// {@subCategory InfoBottomSheetCubit}

@injectable
class InfoBottomSheetCubit extends Cubit<InfoBottomSheetState> {
  final AssetConfigHelper _configHelper = AssetConfigHelper();
  Timer? _autoDismissTimer;

  InfoBottomSheetCubit() : super(const InfoBottomSheetState());

  @override
  Future<void> close() {
    _cancelTimers();
    return super.close();
  }

  /// 📱 Load info bottom sheet configuration
  Future<void> loadInfoBottomSheetConfig() async {
    try {
      emit(state.copyWith(status: InfoBottomSheetStatus.loading));

      debugPrint("📱 Loading info bottom sheet configuration...");

      // Load app config
      final configLoaded = await _configHelper.loadConfig('assets/app_config.json');
      if (!configLoaded) {
        debugPrint("❌ Failed to load configuration file, using default config");
        _useDefaultConfig();
        return;
      }

      // Get info bottom sheet data from app config
      final configData = _configHelper.getAllConfig();
      
      if (configData == null) {
        debugPrint("❌ Configuration data not found, using default config");
        _useDefaultConfig();
        return;
      }

      // Parse info bottom sheet config
      final infoBottomSheetData = configData['info_bottom_sheet_configuration'];
      if (infoBottomSheetData == null) {
        debugPrint("❌ Info bottom sheet configuration not found, using default config");
        _useDefaultConfig();
        return;
      }

      final infoBottomSheetConfig = InfoBottomSheetConfigModel.fromJson(infoBottomSheetData);

      debugPrint("✅ Info bottom sheet configuration loaded successfully");

      emit(state.copyWith(
        status: InfoBottomSheetStatus.initial,
        config: infoBottomSheetConfig,
        infoItems: const [],
      ));

    } catch (e) {
      debugPrint("❌ Error occurred while loading info bottom sheet configuration: $e");
      _useDefaultConfig();
    }
  }

  /// 📋 Show info bottom sheet with items
  Future<void> showInfoBottomSheet({
    required List<InfoItemModel> infoItems,
    InfoType? filterType,
    InfoPriority? filterPriority,
  }) async {
    try {
      debugPrint("📋 Showing info bottom sheet with ${infoItems.length} items");

      // Load config if not loaded
      if (!state.hasConfig) {
        await loadInfoBottomSheetConfig();
      }

      emit(state.copyWith(
        status: InfoBottomSheetStatus.showing,
        infoItems: List<InfoItemModel>.from(infoItems),
        filterType: filterType,
        filterPriority: filterPriority,
      ));

      // Start auto dismiss timer if configured
      _startAutoDismissIfConfigured();

    } catch (e) {
      debugPrint("❌ Error occurred while showing info bottom sheet: $e");
      emit(state.copyWith(
        status: InfoBottomSheetStatus.initial,
        infoItems: const [],
      ));
    }
  }

  /// 🔍 Filter info items by type
  void filterByType(InfoType? type) {
    debugPrint("🔍 Filtering by type: $type");
    
    emit(state.copyWith(
      filterType: type,
      infoItems: List<InfoItemModel>.from(state.infoItems),
    ));
  }

  /// 🔥 Filter info items by priority
  void filterByPriority(InfoPriority? priority) {
    debugPrint("🔥 Filtering by priority: $priority");
    
    emit(state.copyWith(
      filterPriority: priority,
      infoItems: List<InfoItemModel>.from(state.infoItems),
    ));
  }

  /// 📌 Select info item
  void selectInfoItem(InfoItemModel item) {
    debugPrint("📌 Selecting info item: ${item.title}");
    
    emit(state.copyWith(
      selectedItem: item,
      infoItems: List<InfoItemModel>.from(state.infoItems),
    ));
  }

  /// 🚫 Dismiss bottom sheet
  void dismiss() {
    debugPrint("🚫 Dismissing info bottom sheet");
    
    _cancelTimers();
    
    emit(state.copyWith(
      status: InfoBottomSheetStatus.dismissed,
      selectedItem: null,
      infoItems: const [],
    ));
  }

  /// 🔄 Clear filters
  void clearFilters() {
    debugPrint("🔄 Clearing all filters");
    
    emit(state.copyWith(
      filterType: null,
      filterPriority: null,
      infoItems: const [],
    ));
  }

  /// ⏰ Start auto dismiss timer if configured
  void _startAutoDismissIfConfigured() {
    final autoDismissSeconds = state.config?.autoDismissSeconds;
    if (autoDismissSeconds == null || autoDismissSeconds <= 0) return;

    debugPrint("⏰ Starting auto dismiss timer: ${autoDismissSeconds}s");

    emit(state.copyWith(
      autoDismissCountdown: autoDismissSeconds,
      infoItems: List<InfoItemModel>.from(state.infoItems),
    ));

    _autoDismissTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newCountdown = state.autoDismissCountdown - 1;
      
      if (newCountdown <= 0) {
        timer.cancel();
        dismiss();
      } else {
        emit(state.copyWith(
          autoDismissCountdown: newCountdown,
          infoItems: List<InfoItemModel>.from(state.infoItems),
        ));
      }
    });
  }

  /// ⏹️ Cancel all timers
  void _cancelTimers() {
    _autoDismissTimer?.cancel();
    _autoDismissTimer = null;
  }

  /// 🛠️ Use default configuration
  void _useDefaultConfig() {
    const defaultConfig = InfoBottomSheetConfigModel();
    
    emit(state.copyWith(
      status: InfoBottomSheetStatus.initial,
      config: defaultConfig,
      infoItems: const [],
    ));

    debugPrint("🛠️ Using default info bottom sheet configuration");
  }

  /// 🎯 Quick methods for common info types

  /// Show process information
  Future<void> showProcessInfo(List<InfoItemModel> items) async {
    await showInfoBottomSheet(
      infoItems: items,
      filterType: InfoType.process,
    );
  }

  /// Show warning information
  Future<void> showWarningInfo(List<InfoItemModel> items) async {
    await showInfoBottomSheet(
      infoItems: items,
      filterType: InfoType.warning,
    );
  }

  /// Show success information
  Future<void> showSuccessInfo(List<InfoItemModel> items) async {
    await showInfoBottomSheet(
      infoItems: items,
      filterType: InfoType.success,
    );
  }

  /// Show feature information
  Future<void> showFeatureInfo(List<InfoItemModel> items) async {
    await showInfoBottomSheet(
      infoItems: items,
      filterType: InfoType.feature,
    );
  }

  /// Show tips
  Future<void> showTips(List<InfoItemModel> items) async {
    await showInfoBottomSheet(
      infoItems: items,
      filterType: InfoType.tips,
    );
  }
}
