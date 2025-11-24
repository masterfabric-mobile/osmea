/// 🧭 **OSMEA Navbar Cubit**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// State management for Navbar component using Cubit pattern.
/// Handles item selection, animation triggers, and item states.
///
/// {@category State Management}
/// {@subCategory Navbar}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/src/components/navbar/cubit/navbar_state.dart';
import 'package:osmea_components/src/enums/navbar_enums.dart';

/// 🧭 **Navbar Cubit**
///
/// Manages the state of a navbar component including:
/// - Current selected index
/// - Animation triggers for items
/// - Item states (active, inactive, disabled, etc.)
class NavbarCubit extends Cubit<NavbarState> {
  NavbarCubit({
    int initialIndex = 0,
  }) : super(NavbarState.initial(currentIndex: initialIndex));

  /// Select an item by index
  void selectItem(int index) {
    if (index != state.currentIndex) {
      emit(state.copyWith(currentIndex: index));
    }
  }

  /// Update animation trigger for a specific item
  void updateItemAnimation(int index, dynamic trigger) {
    emit(state.updateItemAnimation(index, trigger));
  }

  /// Update state for a specific item
  void updateItemState(int index, NavbarItemState itemState) {
    emit(state.updateItemState(index, itemState));
  }

  /// Reset all item states to inactive
  void resetItemStates() {
    emit(state.copyWith(itemStates: {}));
  }

  /// Reset animation states
  void resetAnimations() {
    emit(state.copyWith(itemAnimationStates: {}));
  }

  /// Reset all states to initial
  void reset() {
    emit(NavbarState.initial(currentIndex: state.currentIndex));
  }
}


