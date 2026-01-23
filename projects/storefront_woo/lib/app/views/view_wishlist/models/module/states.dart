/// Simple wishlist item model for states
class WishlistItem {
  final int id; // product_id
  final int? itemId; // wishlist item_id (for DELETE by ID)
  final String? name;
  final String? imageUrl;
  final String? regularPrice;
  final String? salePrice;
  final String? currencyCode;
  final String? currencyDecimalSeparator;
  final String? currencyThousandSeparator;
  final int? currencyMinorUnit;
  final bool onSale;

  WishlistItem({
    required this.id,
    this.itemId,
    this.name,
    this.imageUrl,
    this.regularPrice,
    this.salePrice,
    this.currencyCode,
    this.currencyDecimalSeparator,
    this.currencyThousandSeparator,
    this.currencyMinorUnit,
    this.onSale = false,
  });
}

/// Simple wishlist group model for states
class WishlistGroup {
  final String id;
  final String name;
  final String? description;
  final bool isDefault;
  final int? itemCount;
  final String? createdAt;
  final String? updatedAt;
  final int? userId;

  WishlistGroup({
    required this.id,
    required this.name,
    this.description,
    this.isDefault = false,
    this.itemCount,
    this.createdAt,
    this.updatedAt,
    this.userId,
  });
}

/// Saved/Wishlist states - mirrors Home states structure
abstract class WishlistState {}

class WishlistInitialState extends WishlistState {}

class WishlistLoadingState extends WishlistState {}

class WishlistLoadedState extends WishlistState {
  final List<WishlistItem> items;
  final List<WishlistGroup> groups;

  WishlistLoadedState({
    required this.items,
    this.groups = const [],
  });

  WishlistLoadedState copyWith({
    List<WishlistItem>? items,
    List<WishlistGroup>? groups,
  }) =>
      WishlistLoadedState(
        items: items ?? this.items,
        groups: groups ?? this.groups,
      );
}

class WishlistErrorState extends WishlistState {
  final String message;
  WishlistErrorState({required this.message});
}

class WishlistSuccessState extends WishlistState {
  final String message;
  final WishlistLoadedState previousState;

  WishlistSuccessState({required this.message, required this.previousState});
}

class WishlistActionPromptState extends WishlistState {
  final WishlistLoadedState previousState;
  final WishlistItem item;

  WishlistActionPromptState({required this.previousState, required this.item});
}
