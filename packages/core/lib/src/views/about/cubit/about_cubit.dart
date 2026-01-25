import 'package:flutter/foundation.dart';
import 'package:core/src/base/base_view_model_cubit.dart';
import 'package:core/src/views/about/cubit/about_state.dart';
import 'package:core/src/models/about_models.dart';
import 'package:injectable/injectable.dart';

/// 📄 **OSMEA About View Cubit**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Cubit that manages about view operations
/// Handles loading and displaying about content
///
/// {@category ViewModels}
/// {@subCategory AboutViewCubit}

@injectable
class AboutViewCubit extends BaseViewModelCubit<AboutViewState> {
  AboutViewCubit() : super(const AboutViewState());

  /// 📄 Load about content
  void loadAbout(AboutPageModel model) {
    debugPrint('📄 Loading about: ${model.title}');
    stateChanger(state.copyWith(
      status: AboutViewStatus.loading,
      model: model,
      errorMessage: null,
    ));

    // Simulate loading delay for smooth transition
    Future.delayed(const Duration(milliseconds: 300), () {
      stateChanger(state.copyWith(
        status: AboutViewStatus.loaded,
        model: model,
      ));
      debugPrint('✅ About loaded successfully');
    });
  }

  /// ❌ Set error state
  void setError(String errorMessage) {
    debugPrint('❌ About error: $errorMessage');
    stateChanger(state.copyWith(
      status: AboutViewStatus.error,
      errorMessage: errorMessage,
    ));
  }

  /// 🔄 Reset about state
  void reset() {
    debugPrint('🔄 About reset');
    stateChanger(const AboutViewState());
  }
}
