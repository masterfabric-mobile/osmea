import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:core/core.dart';
import 'package:core/src/models/error_handling_models.dart';
import 'package:core/src/helper/asset_config_helper.dart';
import 'package:core/src/views/error_handling/cubit/error_handling_state.dart';
import 'package:injectable/injectable.dart';

/// 🎯 **OSMEA Error Handling Cubit**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Cubit that manages error handling operations with MVVM pattern
///
/// {@category ViewModels}
/// {@subCategory ErrorHandlingCubit}

@injectable
class ErrorHandlingCubit extends BaseViewModelCubit<ErrorHandlingState> {
  ErrorHandlingCubit() : super(const ErrorHandlingState());

  final AssetConfigHelper _configHelper = AssetConfigHelper();
  Timer? _autoRetryTimer;
  Timer? _countdownTimer;

  @override
  Future<void> close() {
    _autoRetryTimer?.cancel();
    _countdownTimer?.cancel();
    return super.close();
  }

  /// 📱 Load error handling configuration with dynamic style support
  Future<void> loadErrorHandlingConfig() async {
    try {
      emit(state.copyWith(status: ErrorHandlingStatus.loading));

      debugPrint("📱 Loading error handling configuration...");

      // Load app config (project-specific first, then core fallback)
      final configLoaded =
          await _configHelper.loadConfig('assets/app_config.json');
      if (!configLoaded) {
        debugPrint("❌ Failed to load configuration file, using default config");
        _useDefaultConfig();
        return;
      }

      // Get error handling data from app config
      final configData = _configHelper.getAllConfig();

      if (configData == null) {
        debugPrint("❌ Configuration data not found, using default config");
        _useDefaultConfig();
        return;
      }

      // Parse error handling config
      final errorHandlingData = configData['error_handling_configuration'];
      if (errorHandlingData == null) {
        debugPrint(
            "❌ Error handling configuration not found, using default config");
        _useDefaultConfig();
        return;
      }

      final errorHandlingConfig =
          ErrorHandlingConfigModel.fromJson(errorHandlingData);

      debugPrint(
          "✅ Error handling configuration loaded successfully. Style: ${errorHandlingConfig.style.name}, Error pages: ${errorHandlingConfig.errorPages.length}");

      // Log basic configuration
      debugPrint("🎨 Error handling style: ${errorHandlingConfig.style.name}");
      debugPrint("⚙️ Configuration details:");
      debugPrint(
          "   - Animation duration: ${errorHandlingConfig.animationDuration}ms");
      debugPrint(
          "   - Show retry button: ${errorHandlingConfig.showRetryButton}");
      debugPrint(
          "   - Primary color: ${errorHandlingConfig.primaryColor ?? 'default'}");

      emit(state.copyWith(
        status: ErrorHandlingStatus.initial,
        config: errorHandlingConfig,
      ));
    } catch (e) {
      debugPrint(
          "❌ Error occurred while loading error handling configuration: $e");
      _useDefaultConfig();
    }
  }

  /// 🚨 Show error with specific type and details
  Future<void> showError({
    required ErrorType errorType,
    String? errorMessage,
    String? errorCode,
    String? stackTrace,
    Exception? originalException,
  }) async {
    try {
      debugPrint(
          "🚨 Showing error: $errorType, message: $errorMessage, code: $errorCode");

      // Load config if not loaded
      if (!state.hasConfig) {
        await loadErrorHandlingConfig();
      }

      // Get error page for this error type
      final errorPage = state.config?.errorPages[errorType];

      emit(state.copyWith(
        status: ErrorHandlingStatus.showingError,
        currentErrorType: errorType,
        currentErrorPage: errorPage,
        errorMessage: errorMessage,
        errorCode: errorCode,
        stackTrace: stackTrace,
        originalException: originalException,
        retryCount: 0, // Reset retry count for new error
      ));

      // Start auto retry if configured
      _startAutoRetryIfConfigured();
    } catch (e) {
      debugPrint("❌ Error occurred while showing error: $e");
      // Fallback to basic error display
      emit(state.copyWith(
        status: ErrorHandlingStatus.showingError,
        currentErrorType: errorType,
        errorMessage: errorMessage ?? 'Unknown error occurred',
        errorCode: errorCode,
      ));
    }
  }

  /// 🔄 Retry the failed operation
  Future<void> retry() async {
    if (!state.canRetry) {
      debugPrint("❌ Cannot retry: Max retry count reached");
      return;
    }

    debugPrint("🔄 Retrying operation. Retry count: ${state.retryCount + 1}");

    _cancelTimers();

    emit(state.copyWith(
      status: ErrorHandlingStatus.retrying,
      retryCount: state.retryCount + 1,
      isAutoRetryActive: false,
      autoRetryCountdown: 0,
    ));

    // Emit retry event - parent widget should listen to this
    // The actual retry logic should be implemented by the caller
  }

  /// 🏠 Go to home/main screen
  void goHome() {
    debugPrint("🏠 Going to home screen");

    _cancelTimers();

    emit(state.copyWith(
      status: ErrorHandlingStatus.resolved,
      isAutoRetryActive: false,
      autoRetryCountdown: 0,
    ));
  }

  /// 📞 Contact support
  void contactSupport() {
    debugPrint("📞 Contacting support");

    // This will be handled by the UI layer
    // Email or phone call will be initiated
  }

  /// ❌ Dismiss error
  void dismissError() {
    debugPrint("❌ Dismissing error");

    _cancelTimers();

    emit(state.copyWith(
      status: ErrorHandlingStatus.resolved,
      isAutoRetryActive: false,
      autoRetryCountdown: 0,
    ));
  }

  /// ⬅️ Go back
  void goBack() {
    debugPrint("⬅️ Going back");

    _cancelTimers();

    emit(state.copyWith(
      status: ErrorHandlingStatus.resolved,
      isAutoRetryActive: false,
      autoRetryCountdown: 0,
    ));
  }

  /// 🔄 Mark operation as successful (after retry)
  void markResolved() {
    debugPrint("✅ Error resolved successfully");

    _cancelTimers();

    emit(state.copyWith(
      status: ErrorHandlingStatus.resolved,
      isAutoRetryActive: false,
      autoRetryCountdown: 0,
    ));
  }

  /// 🕐 Start auto retry timer if configured
  void _startAutoRetryIfConfigured() {
    final autoRetrySeconds = state.config?.autoRetrySeconds;

    if (autoRetrySeconds != null && autoRetrySeconds > 0 && state.canRetry) {
      debugPrint("🕐 Starting auto retry timer: $autoRetrySeconds seconds");

      emit(state.copyWith(
        isAutoRetryActive: true,
        autoRetryCountdown: autoRetrySeconds,
      ));

      // Start countdown timer
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final newCountdown = state.autoRetryCountdown - 1;

        if (newCountdown <= 0) {
          timer.cancel();
          if (!isClosed && state.canRetry) {
            retry();
          }
        } else {
          emit(state.copyWith(autoRetryCountdown: newCountdown));
        }
      });
    }
  }

  /// ⏹️ Cancel all timers
  void _cancelTimers() {
    _autoRetryTimer?.cancel();
    _countdownTimer?.cancel();
    _autoRetryTimer = null;
    _countdownTimer = null;
  }

  /// 🛠️ Use default configuration (simple like loading and onboarding)
  void _useDefaultConfig() {
    debugPrint("🔧 Creating default error handling configuration");

    final defaultConfig = ErrorHandlingConfigModel(
      errorPages: {
        ErrorType.general: const ErrorPageModel(
          title: 'An Error Occurred',
          description: 'An unexpected error occurred. Please try again.',
          errorType: ErrorType.general,
          retryButtonText: 'Try Again',
          homeButtonText: 'Home',
        ),
        ErrorType.network: const ErrorPageModel(
          title: 'Connection Error',
          description: 'Check your internet connection and try again.',
          errorType: ErrorType.network,
          retryButtonText: 'Try Again',
          homeButtonText: 'Home',
        ),
        ErrorType.server: const ErrorPageModel(
          title: 'Server Error',
          description: 'A server problem occurred. Please try again later.',
          errorType: ErrorType.server,
          retryButtonText: 'Try Again',
          homeButtonText: 'Home',
        ),
      },
      style: ErrorHandlingStyle.startup,
      animationDuration: 400,
      primaryColor: '#EF4444',
      secondaryColor: '#F59E0B',
    );

    emit(state.copyWith(
      status: ErrorHandlingStatus.initial,
      config: defaultConfig,
    ));

    debugPrint("✅ Default error handling configuration loaded");
  }

  /// 🐛 Get debug information
  Map<String, dynamic> getDebugInfo() {
    if (kDebugMode) {
      return {
        'cubit_state': {
          'status': state.status.toString(),
          'current_error_type': state.currentErrorType.toString(),
          'error_message': state.errorMessage,
          'error_code': state.errorCode,
          'retry_count': state.retryCount,
          'max_retry_count': state.maxRetryCount,
          'can_retry': state.canRetry,
          'config_loaded': state.hasConfig,
          'error_page_loaded': state.hasErrorPage,
          'is_auto_retry_active': state.isAutoRetryActive,
          'auto_retry_countdown': state.autoRetryCountdown,
        },
        'config_info': state.config != null
            ? {
                'error_pages_count': state.config!.errorPages.length,
                'style': state.config!.style.toString(),
                'auto_retry_seconds': state.config!.autoRetrySeconds,
                'show_retry_button': state.config!.showRetryButton,
                'show_home_button': state.config!.showHomeButton,
                'show_support_button': state.config!.showSupportButton,
              }
            : null,
        'current_error_page': state.currentErrorPage?.toString(),
        'original_exception': state.originalException?.toString(),
        'stack_trace': state.stackTrace,
      };
    }
    return {};
  }

  /// 🎯 Quick error methods for common error types

  Future<void> showNetworkError([String? message]) async {
    await showError(
      errorType: ErrorType.network,
      errorMessage: message,
    );
  }

  Future<void> showServerError([String? message, String? errorCode]) async {
    await showError(
      errorType: ErrorType.server,
      errorMessage: message,
      errorCode: errorCode,
    );
  }

  Future<void> showAuthenticationError([String? message]) async {
    await showError(
      errorType: ErrorType.authentication,
      errorMessage: message,
    );
  }

  Future<void> showNotFoundError([String? message]) async {
    await showError(
      errorType: ErrorType.notFound,
      errorMessage: message,
    );
  }

  Future<void> showTimeoutError([String? message]) async {
    await showError(
      errorType: ErrorType.timeout,
      errorMessage: message,
    );
  }

  Future<void> showMaintenanceError([String? message]) async {
    await showError(
      errorType: ErrorType.maintenance,
      errorMessage: message,
    );
  }

  Future<void> showPermissionError([String? message]) async {
    await showError(
      errorType: ErrorType.permission,
      errorMessage: message,
    );
  }

  Future<void> showGeneralError([String? message, Exception? exception]) async {
    await showError(
      errorType: ErrorType.general,
      errorMessage: message,
      originalException: exception,
    );
  }
}
