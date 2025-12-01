import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/base/master_view_cubit/master_view_cubit.dart';
import 'package:core/src/views/loading/cubit/loading_cubit.dart';
import 'package:core/src/views/loading/cubit/loading_state.dart';
import 'package:core/src/models/loading_models.dart';
import 'package:core/src/views/loading/widgets/loading_startup_widget.dart';
import 'package:core/src/views/loading/widgets/loading_space_widget.dart';
import 'package:core/src/views/loading/widgets/loading_enterprise_widget.dart';
import 'package:core/src/helper/asset_config_helper.dart';

/// 🔄 **OSMEA Loading View**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Main loading view - Shows loading progress with customizable messages and styles
/// Uses MasterViewCubit for lifecycle management and LoadingModels for configuration
///
/// Features:
/// - 🎨 Three distinct loading styles: startup, space, enterprise
/// - ⚙️ Configurable loading models from loading_models.dart
/// - 📊 Multiple loading types with progress indicators
/// - 🛡️ Error handling and completion callbacks
/// - 🔧 Fallback configurations for flexibility
/// - 📱 Asset-free design (no external dependencies)
/// - 🚀 Config file support via AssetConfigHelper
///
/// Style Options:
/// - **Startup**: Clean, minimal design with circular progress
/// - **Space**: Futuristic cosmic theme with gradient backgrounds
/// - **Enterprise**: Professional corporate styling with linear progress
///
/// Usage Examples:
/// ```dart
/// // Simple usage with fallback properties
/// LoadingView(
///   goRoute: goRoute,
///   loadingSteps: ['Step 1', 'Step 2', 'Step 3'],
///   showProgress: true,
/// )
///
/// // With custom model
/// LoadingView(
///   goRoute: goRoute,
///   loadingPageModel: customLoadingModel,
///   onCompleted: () => print('Done!'),
/// )
///
/// // With configuration and style selection
/// LoadingView(
///   goRoute: goRoute,
///   loadingConfig: loadingConfig,
///   loadingType: LoadingModelType.initialization,
/// )
/// ```
///
/// {@category Views}
/// {@subCategory LoadingView}

class LoadingView extends MasterViewCubit<LoadingViewCubit, LoadingViewState> {
  /// Loading page configuration model
  final LoadingPageModel? loadingPageModel;

  /// Loading configuration
  final LoadingConfigModel? loadingConfig;

  /// Loading type for config lookup
  final LoadingModelType? loadingType;

  /// Callback to be called when loading is completed
  final VoidCallback? onCompleted;

  /// Callback to be called when loading fails
  final Function(String error)? onError;

  /// Custom loading steps for simulation (fallback if no model)
  final List<String>? loadingSteps;

  /// Duration for each loading step (fallback if no model)
  final Duration stepDuration;

  /// Whether to show progress percentage (fallback if no model)
  final bool showProgress;

  /// Whether to show cancel button (fallback if no model)
  final bool showCancelButton;

  LoadingView({
    super.key,
    required Function(String path) goRoute,
    Map<String, dynamic> arguments = const {'loading': true},
    this.loadingPageModel,
    this.loadingConfig,
    this.loadingType,
    this.onCompleted,
    this.onError,
    this.loadingSteps,
    this.stepDuration = const Duration(milliseconds: 800),
    this.showProgress = true,
    this.showCancelButton = false,
  }) : super(
          goRoute: goRoute,
          arguments: arguments,
        );

  @override
  Future<void> initialContent(viewModel, BuildContext context) async {
    debugPrint('🔄 Loading View Started!');

    // Get effective loading configuration
    final effectiveModel = _getEffectiveLoadingModel();

    // Start loading simulation based on model or fallback
    final steps = effectiveModel.loadingSteps ?? loadingSteps;
    if (steps != null && steps.isNotEmpty) {
      viewModel.simulateLoading(
        steps: steps,
        stepDuration: effectiveModel.stepDurationObject,
        onComplete: onCompleted,
        onError: onError,
      );
    } else {
      // Start basic loading
      viewModel.startLoading(message: effectiveModel.description);
    }
  }

  /// Get effective loading model based on priority: loadingPageModel > config lookup > fallback
  LoadingPageModel _getEffectiveLoadingModel() {
    // Priority 1: Direct model provided
    if (loadingPageModel != null) {
      return loadingPageModel!;
    }

    // Priority 2: From config with type
    if (loadingConfig != null && loadingType != null) {
      final configModel = loadingConfig!.getLoadingPage(loadingType!);
      if (configModel != null) {
        return configModel;
      }
    }

    // Priority 3: Fallback model with config colors if available
    return _createFallbackModelWithConfigColors();
  }

  /// Create fallback model with config colors
  LoadingPageModel _createFallbackModelWithConfigColors() {
    // Get colors from config based on style
    String? backgroundColor;
    String? textColor;
    String? progressColor;

    final modelType = loadingType ?? LoadingModelType.general;
    final style = _convertModelTypeToStyle(modelType);

    // Load config colors based on style
    try {
      // This is synchronous access to already loaded config
      final configHelper = AssetConfigHelper();
      final styleConfig =
          configHelper.getObject('loading_configuration.styles.${style.name}');

      if (styleConfig != null) {
        backgroundColor = styleConfig['background_color'] as String?;
        textColor = styleConfig['text_color'] as String?;
        progressColor = styleConfig['primary_color'] as String?;
      }
    } catch (e) {
      debugPrint('⚠️ Could not load style colors from config: $e');
    }

    return LoadingPageModel(
      title: 'Loading',
      description: 'Please wait...',
      loadingType: modelType,
      loadingSteps: loadingSteps ?? ['Loading...', 'Almost done...'],
      stepDuration: stepDuration.inMilliseconds,
      showProgress: showProgress,
      showCancelButton: showCancelButton,
      autoNavigateOnComplete: true,
      backgroundColor: backgroundColor,
      textColor: textColor,
      progressColor: progressColor,
    );
  }

  @override
  Widget viewContent(BuildContext context, viewModel, state) {
    // Get effective loading configuration for listener
    final effectiveModel = _getEffectiveLoadingModel();

    return BlocListener<LoadingViewCubit, LoadingViewState>(
      listener: (context, state) {
        // Handle state changes with proper lifecycle management
        if (state.status == LoadingViewStatus.completed) {
          onCompleted?.call();
          if (effectiveModel.autoNavigateOnComplete &&
              effectiveModel.targetRoute != null) {
            // Use postFrameCallback to ensure navigation happens after frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                goRoute(effectiveModel.targetRoute!);
              }
            });
          }
        } else if (state.status == LoadingViewStatus.error) {
          final errorMsg = state.errorMessage ??
              effectiveModel.errorMessage ??
              'Unknown loading error';
          onError?.call(errorMsg);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder<LoadingStyle>(
            future: _getLoadingStyleFromConfig(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // Get effective loading model
              final effectiveModel = _getEffectiveLoadingModel();

              if (snapshot.hasData) {
                // Use the loading style from config or model
                return _getLoadingWidget(
                    snapshot.data!, effectiveModel, viewModel);
              } else {
                // Default to startup style if config not available
                debugPrint(
                    '⚠️ Could not get loading style from config, using default');
                return _getLoadingWidget(
                    LoadingStyle.startup, effectiveModel, viewModel);
              }
            },
          ),
        ),
      ),
    );
  }

  /// Get loading style from model type, with config fallback
  Future<LoadingStyle> _getLoadingStyleFromConfig() async {
    final effectiveModel = _getEffectiveLoadingModel();

    // Priority 1: Convert LoadingModelType directly to LoadingStyle
    // This ensures each LoadingModelType gets its appropriate visual style
    final styleFromModelType =
        _convertModelTypeToStyle(effectiveModel.loadingType);

    debugPrint(
        '🎨 Loading style from LoadingModelType.${effectiveModel.loadingType.name} -> $styleFromModelType');

    // Return the style based on LoadingModelType
    // Config is loaded for other settings but style is determined by LoadingModelType
    try {
      final configHelper = AssetConfigHelper();
      await configHelper.loadConfig('assets/app_config.json');
      debugPrint(
          '✅ Loading config loaded successfully for additional settings');
    } catch (e) {
      debugPrint('⚠️ Could not load config for additional settings: $e');
    }

    return styleFromModelType;
  }

  /// Convert LoadingModelType to LoadingStyle
  LoadingStyle _convertModelTypeToStyle(LoadingModelType modelType) {
    switch (modelType) {
      case LoadingModelType.initialization:
      case LoadingModelType.appStartup:
        return LoadingStyle.startup;
      case LoadingModelType.dataSync:
      case LoadingModelType.synchronization:
      case LoadingModelType.networkRequest:
        return LoadingStyle.space;
      case LoadingModelType.fileProcessing:
      case LoadingModelType.authentication:
      case LoadingModelType.databaseOperation:
        return LoadingStyle.enterprise;
      case LoadingModelType.general:
      case LoadingModelType.dataLoading:
      case LoadingModelType.fileTransfer:
      case LoadingModelType.cacheBuilding:
      case LoadingModelType.updating:
      case LoadingModelType.configuration:
      case LoadingModelType.imageProcessing:
        return LoadingStyle.startup; // Default to startup for general cases
    }
  }

  /// Get appropriate loading widget based on style
  Widget _getLoadingWidget(
      LoadingStyle style, LoadingPageModel model, LoadingViewCubit cubit) {
    switch (style) {
      case LoadingStyle.startup:
        return LoadingStartupWidget(
          model: model,
          onCancel: model.showCancelButton ? () => cubit.cancelLoading() : null,
        );
      case LoadingStyle.space:
        return LoadingSpaceWidget(
          model: model,
          onCancel: model.showCancelButton ? () => cubit.cancelLoading() : null,
        );
      case LoadingStyle.enterprise:
        return LoadingEnterpriseWidget(
          model: model,
          onCancel: model.showCancelButton ? () => cubit.cancelLoading() : null,
        );
    }
  }
}

/// 🚀 Ready-to-use widget for easy implementation
class LoadingScreen extends StatelessWidget {
  /// Navigation callback for routing to other pages
  final Function(String path) goRoute;

  /// Loading page model
  final LoadingPageModel? loadingPageModel;

  /// Loading configuration
  final LoadingConfigModel? loadingConfig;

  /// Loading type for config lookup
  final LoadingModelType? loadingType;

  /// Callback to be called when loading is completed
  final VoidCallback? onCompleted;

  /// Callback to be called when loading fails
  final Function(String error)? onError;

  /// Custom loading steps (fallback)
  final List<String>? loadingSteps;

  /// Duration for each step (fallback)
  final Duration stepDuration;

  /// Whether to show progress percentage (fallback)
  final bool showProgress;

  /// Whether to show cancel button (fallback)
  final bool showCancelButton;

  const LoadingScreen({
    super.key,
    required this.goRoute,
    this.loadingPageModel,
    this.loadingConfig,
    this.loadingType,
    this.onCompleted,
    this.onError,
    this.loadingSteps,
    this.stepDuration = const Duration(milliseconds: 800),
    this.showProgress = true,
    this.showCancelButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingView(
      goRoute: goRoute,
      loadingPageModel: loadingPageModel,
      loadingConfig: loadingConfig,
      loadingType: loadingType,
      onCompleted: onCompleted,
      onError: onError,
      loadingSteps: loadingSteps,
      stepDuration: stepDuration,
      showProgress: showProgress,
      showCancelButton: showCancelButton,
    );
  }
}
