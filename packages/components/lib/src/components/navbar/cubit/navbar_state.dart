/// 🧭 **OSMEA Navbar State**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// State definitions for Navbar Cubit.
///
/// {@category State Management}
/// {@subCategory Navbar}

import 'package:equatable/equatable.dart';
import 'package:osmea_components/src/enums/navbar_enums.dart';

/// 🧭 **Navbar State**
///
/// Immutable state class for Navbar component containing:
/// - Current selected index
/// - Animation states for items
/// - Item states
class NavbarState extends Equatable {
  const NavbarState({
    required this.currentIndex,
    this.itemAnimationStates = const {},
    this.itemStates = const {},
  });

  /// 📍 Currently selected item index
  final int currentIndex;

  /// 🎬 Animation states for each item (index -> animation trigger value)
  final Map<int, dynamic> itemAnimationStates;

  /// 🔄 States for each item (index -> NavbarItemState)
  final Map<int, NavbarItemState> itemStates;

  /// Create a copy with modified properties
  NavbarState copyWith({
    int? currentIndex,
    Map<int, dynamic>? itemAnimationStates,
    Map<int, NavbarItemState>? itemStates,
  }) {
    return NavbarState(
      currentIndex: currentIndex ?? this.currentIndex,
      itemAnimationStates: itemAnimationStates ?? this.itemAnimationStates,
      itemStates: itemStates ?? this.itemStates,
    );
  }

  /// Create initial state
  static NavbarState initial({int currentIndex = 0}) {
    return NavbarState(currentIndex: currentIndex);
  }

  /// Update animation trigger for a specific item
  NavbarState updateItemAnimation(int index, dynamic trigger) {
    final newStates = Map<int, dynamic>.from(itemAnimationStates);
    newStates[index] = trigger;
    return copyWith(itemAnimationStates: newStates);
  }

  /// Update state for a specific item
  NavbarState updateItemState(int index, NavbarItemState state) {
    final newStates = Map<int, NavbarItemState>.from(itemStates);
    newStates[index] = state;
    return copyWith(itemStates: newStates);
  }

  /// Get animation trigger for an item
  dynamic getItemAnimationTrigger(int index) {
    return itemAnimationStates[index];
  }

  /// Get state for an item
  NavbarItemState? getItemState(int index) {
    return itemStates[index];
  }

  @override
  List<Object?> get props => [
        currentIndex,
        itemAnimationStates,
        itemStates,
      ];

  @override
  String toString() {
    return 'NavbarState(currentIndex: $currentIndex, animationStates: $itemAnimationStates, itemStates: $itemStates)';
  }
}
