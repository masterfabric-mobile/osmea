import 'package:flutter/foundation.dart';
import 'package:core/src/base/base_view_model_cubit.dart';
import 'package:core/src/views/faq/cubit/faq_state.dart';
import 'package:core/src/models/faq_models.dart';
import 'package:injectable/injectable.dart';

/// ❓ **OSMEA FAQ View Cubit**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Cubit that manages FAQ view operations
/// Handles loading and displaying FAQ content
///
/// {@category ViewModels}
/// {@subCategory FAQViewCubit}

@injectable
class FAQViewCubit extends BaseViewModelCubit<FAQViewState> {
  FAQViewCubit() : super(const FAQViewState());

  /// 📄 Load FAQ content
  void loadFAQ(FAQPageModel model) {
    debugPrint('❓ Loading FAQ: ${model.title}');
    
    // Initialize expanded indices for items with expandedByDefault
    final expandedIndices = <int>{};
    for (int i = 0; i < model.items.length; i++) {
      if (model.items[i].expandedByDefault) {
        expandedIndices.add(i);
      }
    }

    stateChanger(state.copyWith(
      status: FAQViewStatus.loading,
      model: model,
      errorMessage: null,
      expandedIndices: expandedIndices,
    ));

    // Simulate loading delay for smooth transition
    Future.delayed(const Duration(milliseconds: 300), () {
      stateChanger(state.copyWith(
        status: FAQViewStatus.loaded,
        model: model,
        expandedIndices: expandedIndices,
      ));
      debugPrint('✅ FAQ loaded successfully');
    });
  }

  /// Toggle item expansion
  void toggleItem(int index) {
    final currentExpanded = Set<int>.from(state.expandedIndices);
    
    if (currentExpanded.contains(index)) {
      currentExpanded.remove(index);
    } else {
      if (!state.model!.allowMultipleExpanded) {
        currentExpanded.clear();
      }
      currentExpanded.add(index);
    }

    stateChanger(state.copyWith(expandedIndices: currentExpanded));
  }

  /// Set search query
  void setSearchQuery(String query) {
    stateChanger(state.copyWith(searchQuery: query));
  }

  /// Set selected category
  void setSelectedCategory(String? category) {
    stateChanger(state.copyWith(selectedCategory: category));
  }

  /// ❌ Set error state
  void setError(String errorMessage) {
    debugPrint('❌ FAQ error: $errorMessage');
    stateChanger(state.copyWith(
      status: FAQViewStatus.error,
      errorMessage: errorMessage,
    ));
  }

  /// 🔄 Reset FAQ state
  void reset() {
    debugPrint('🔄 FAQ reset');
    stateChanger(const FAQViewState());
  }
}
