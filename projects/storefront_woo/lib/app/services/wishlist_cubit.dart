import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

/// Lightweight DTO persisted for wishlist items
class WishlistItem {
  final int id;
  final String? name;
  final String? imageUrl;
  final String? regularPrice;
  final String? salePrice;
  final String? currencyCode;
  final bool onSale;

  const WishlistItem({
    required this.id,
    this.name,
    this.imageUrl,
    this.regularPrice,
    this.salePrice,
    this.currencyCode,
    this.onSale = false,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
        id: json['id'] as int,
        name: json['name'] as String?,
        imageUrl: json['imageUrl'] as String?,
        regularPrice: json['regularPrice'] as String?,
        salePrice: json['salePrice'] as String?,
        currencyCode: json['currencyCode'] as String?,
        onSale: (json['onSale'] as bool?) ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'regularPrice': regularPrice,
        'salePrice': salePrice,
        'currencyCode': currencyCode,
        'onSale': onSale,
      };
}

class WishlistState {
  final List<WishlistItem> items;
  const WishlistState({this.items = const []});

  WishlistState copyWith({List<WishlistItem>? items}) =>
      WishlistState(items: items ?? this.items);

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
      };

  factory WishlistState.fromJson(Map<String, dynamic> json) {
    final raw = json['items'] as List<dynamic>? ?? [];
    return WishlistState(
      items: raw
          .whereType<Map<String, dynamic>>()
          .map(WishlistItem.fromJson)
          .toList(),
    );
  }
}

/// Hydrated wishlist cubit available app-wide
class WishlistCubit extends BaseViewModelHydratedCubit<WishlistState> {
  WishlistCubit() : super(const WishlistState());

  // Ensure a stable storage key for hydration to avoid collisions and allow
  // versioning/migrations in the future.
  @override
  String get id => 'wishlist_cubit_v1';

  bool isSaved(int productId) =>
      state.items.any((element) => element.id == productId);

  int get count => state.items.length;

  void toggle(WishlistItem item) {
    try {
      final exists = isSaved(item.id);
      final updated = exists
          ? state.items.where((e) => e.id != item.id).toList()
          : [...state.items, item];
      emit(WishlistState(items: updated));
    } catch (e) {
      debugPrint('❌ Wishlist toggle error: $e');
    }
  }

  void remove(int productId) {
    final updated = state.items.where((e) => e.id != productId).toList();
    emit(WishlistState(items: updated));
  }

  @override
  WishlistState? fromJson(Map<String, dynamic> json) =>
      WishlistState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(WishlistState state) => state.toJson();
}


