import 'package:flutter/foundation.dart';
import 'package:core/src/base/base_view_model_cubit.dart';
import 'package:core/src/views/contact_us/cubit/contact_us_state.dart';
import 'package:core/src/models/contact_us_models.dart';
import 'package:injectable/injectable.dart';

/// 📧 **OSMEA Contact Us View Cubit**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Cubit that manages contact us view operations
/// Handles loading and displaying contact content, form submission
///
/// {@category ViewModels}
/// {@subCategory ContactUsViewCubit}

@injectable
class ContactUsViewCubit extends BaseViewModelCubit<ContactUsViewState> {
  ContactUsViewCubit() : super(const ContactUsViewState());

  /// 📧 Load contact us content
  void loadContactUs(ContactUsPageModel model) {
    debugPrint('📧 Loading contact us: ${model.title}');
    stateChanger(state.copyWith(
      status: ContactUsViewStatus.loading,
      model: model,
      errorMessage: null,
    ));

    // Simulate loading delay for smooth transition
    Future.delayed(const Duration(milliseconds: 300), () {
      stateChanger(state.copyWith(
        status: ContactUsViewStatus.loaded,
        model: model,
      ));
      debugPrint('✅ Contact us loaded successfully');
    });
  }

  /// 📤 Submit contact form
  Future<void> submitForm({
    required String name,
    required String email,
    String? phone,
    String? subject,
    required String message,
    String? company,
  }) async {
    debugPrint('📤 Submitting contact form...');
    stateChanger(state.copyWith(
      status: ContactUsViewStatus.submitting,
      errorMessage: null,
    ));

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // In real implementation, this would call an API
      // await contactUsService.submitForm(...);

      stateChanger(state.copyWith(
        status: ContactUsViewStatus.submitted,
      ));
      debugPrint('✅ Contact form submitted successfully');
    } catch (e) {
      stateChanger(state.copyWith(
        status: ContactUsViewStatus.error,
        errorMessage: e.toString(),
      ));
      debugPrint('❌ Contact form submission error: $e');
    }
  }

  /// ❌ Set error state
  void setError(String errorMessage) {
    debugPrint('❌ Contact us error: $errorMessage');
    stateChanger(state.copyWith(
      status: ContactUsViewStatus.error,
      errorMessage: errorMessage,
    ));
  }

  /// 🔄 Reset contact us state
  void reset() {
    debugPrint('🔄 Contact us reset');
    stateChanger(const ContactUsViewState());
  }
}
