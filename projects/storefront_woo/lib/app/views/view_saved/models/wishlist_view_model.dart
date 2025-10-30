import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/wishlist/abstract/woo_wishlist_service.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/request/add_wishlist_item_request.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/request/delete_wishlist_item_request.dart';

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

/// Hydrated wishlist view model that also syncs with Woo Wishlist API
@lazySingleton
class WishlistViewModel extends BaseViewModelHydratedCubit<WishlistState> {
  WishlistViewModel() : super(const WishlistState());

  final WooWishlistService _wishlistService = GetIt.I<WooWishlistService>();
  final AssetConfigHelper _config = AssetConfigHelper();

  @override
  String get id => 'wishlist_view_model_v1';

  List<int> get savedIds => state.items.map((e) => e.id).toList(growable: false);

  bool isSaved(int productId) => state.items.any((e) => e.id == productId);

  int get count => state.items.length;

  /// Load wishlist items from API and cache via hydration
  Future<void> syncFromServer({int? groupId}) async {
    try {
      final apiVersion = _config.getString('woocommerce_configuration.version', 'v1');
      final paged = await _wishlistService.getWishlistItems(
        apiVersion: apiVersion,
        groupId: groupId,
        page: 1,
        perPage: 100,
      );

      final mapped = (paged.data ?? [])
          .map((w) => WishlistItem(
                id: w.productId ?? 0,
                name: w.productName,
                imageUrl: w.productImage,
                regularPrice: w.productPrice,
                salePrice: null,
                currencyCode: null,
                onSale: false,
              ))
          .toList();

      emit(WishlistState(items: mapped));
    } catch (e, s) {
      debugPrint('❌ Wishlist sync error: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  /// Toggle locally and call API
  Future<void> toggle(WishlistItem item, {int? groupId}) async {
    final exists = isSaved(item.id);
    if (exists) {
      await remove(item.id, groupId: groupId);
    } else {
      await add(item, groupId: groupId);
    }
  }

  Future<void> add(WishlistItem item, {int? groupId}) async {
    try {
      final updated = [...state.items, item];
      emit(WishlistState(items: updated));

      final apiVersion = _config.getString('woocommerce_configuration.version', 'v1');
      await _wishlistService.addItemToWishlist(
        apiVersion: apiVersion,
        request: AddWishlistItemRequest(productId: item.id, groupId: groupId ?? 0),
      );
    } catch (e, s) {
      debugPrint('❌ Wishlist add error: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  Future<void> remove(int productId, {int? groupId}) async {
    try {
      final updated = state.items.where((e) => e.id != productId).toList();
      emit(WishlistState(items: updated));

      final apiVersion = _config.getString('woocommerce_configuration.version', 'v1');
      await _wishlistService.deleteItemByProduct(
        apiVersion: apiVersion,
        request: DeleteWishlistItemRequest(productId: productId, groupId: groupId ?? 0),
      );
    } catch (e, s) {
      debugPrint('❌ Wishlist remove error: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  @override
  WishlistState? fromJson(Map<String, dynamic> json) =>
      WishlistState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(WishlistState state) => state.toJson();
}


