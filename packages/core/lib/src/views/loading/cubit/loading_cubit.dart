import 'package:flutter/foundation.dart';
import 'package:core/src/base/base_view_model_cubit.dart';
import 'package:core/src/views/loading/cubit/loading_state.dart';
import 'package:injectable/injectable.dart';

/// 🔄 **OSMEA Loading View Cubit**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Cubit that manages loading view operations
/// Handles progress tracking, messages, and completion states
///
/// {@category ViewModels}
/// {@subCategory LoadingViewCubit}

@injectable
class LoadingViewCubit extends BaseViewModelCubit<LoadingViewState> {
  LoadingViewCubit() : super(const LoadingViewState());

  /// 🚀 Start loading process
  void startLoading({String? message}) {
    debugPrint('🔄 Loading started: ${message ?? "Loading..."}');
    stateChanger(state.copyWith(
      status: LoadingViewStatus.loading,
      progress: 0.0,
      message: message ?? 'Loading...',
      errorMessage: null,
    ));
  }

  /// 📊 Update loading progress
  void updateProgress(double progress, {String? message}) {
    if (progress < 0.0) progress = 0.0;
    if (progress > 1.0) progress = 1.0;

    debugPrint('📊 Loading progress: ${(progress * 100).round()}%');
    stateChanger(state.copyWith(
      status: LoadingViewStatus.loading,
      progress: progress,
      message: message ?? state.message,
    ));
  }

  /// 💬 Update loading message
  void updateMessage(String message) {
    debugPrint('💬 Loading message: $message');
    stateChanger(state.copyWith(
      message: message,
    ));
  }

  /// ✅ Complete loading successfully
  void completeLoading({String? message, Map<String, dynamic>? data}) {
    debugPrint('✅ Loading completed: ${message ?? "Loading completed"}');
    stateChanger(state.copyWith(
      status: LoadingViewStatus.completed,
      progress: 1.0,
      message: message ?? 'Loading completed',
      errorMessage: null,
      data: data,
    ));
  }

  /// ❌ Fail loading with error
  void failLoading(String errorMessage, {String? message}) {
    debugPrint('❌ Loading failed: $errorMessage');
    stateChanger(state.copyWith(
      status: LoadingViewStatus.error,
      errorMessage: errorMessage,
      message: message ?? 'Loading failed',
    ));
  }

  /// 🔄 Reset loading state
  void resetLoading() {
    debugPrint('🔄 Loading reset');
    stateChanger(const LoadingViewState());
  }

  /// 🎮 Simulate loading process with steps
  Future<void> simulateLoading({
    List<String>? steps,
    Duration stepDuration = const Duration(milliseconds: 500),
    Function()? onComplete,
    Function(String)? onError,
  }) async {
    try {
      final loadingSteps = steps ??
          [
            'Initializing...',
            'Loading configuration...',
            'Preparing resources...',
            'Finalizing...',
          ];

      startLoading(message: loadingSteps.first);

      for (int i = 0; i < loadingSteps.length; i++) {
        if (isClosed) return;

        final progress = (i + 1) / loadingSteps.length;
        updateProgress(progress, message: loadingSteps[i]);

        await Future.delayed(stepDuration);
      }

      if (!isClosed) {
        completeLoading(message: 'Loading completed successfully');
        onComplete?.call();
      }
    } catch (e) {
      if (!isClosed) {
        failLoading(e.toString());
        onError?.call(e.toString());
      }
    }
  }

  /// 📊 Get current progress as percentage string
  String get progressText => '${state.progressPercentage}%';

  /// 🎯 Check if loading can be cancelled
  bool get canCancel => state.status == LoadingViewStatus.loading;

  /// 🛑 Cancel loading (if supported)
  void cancelLoading() {
    if (canCancel) {
      debugPrint('🛑 Loading cancelled');
      stateChanger(state.copyWith(
        status: LoadingViewStatus.error,
        errorMessage: 'Loading was cancelled',
        message: 'Cancelled',
      ));
    }
  }

  /// 🔍 Get debug information
  Map<String, dynamic> getDebugInfo() {
    if (kDebugMode) {
      return {
        'status': state.status.toString(),
        'progress': state.progress,
        'progress_percentage': state.progressPercentage,
        'message': state.message,
        'error_message': state.errorMessage,
        'is_loading': state.isLoading,
        'is_completed': state.isCompleted,
        'has_error': state.hasError,
        'data_keys': state.data?.keys.toList(),
      };
    }
    return {};
  }
}
