/// Simple wishlist item model for states
class WishlistItem {
  final int id; // product_id
  final int? itemId; // wishlist item_id (for DELETE by ID)
  final String? name;
  final String? imageUrl;
  final String? regularPrice;
  final String? salePrice;
  final String? currencyCode;
  final bool onSale;

  WishlistItem({
    required this.id,
    this.itemId,
    this.name,
    this.imageUrl,
    this.regularPrice,
    this.salePrice,
    this.currencyCode,
    this.onSale = false,
  });
}

/// Saved/Wishlist states - mirrors Home states structure
abstract class WishlistState {}

class WishlistInitialState extends WishlistState {}

class WishlistLoadingState extends WishlistState {}

class WishlistLoadedState extends WishlistState {
  final List<WishlistItem> items;

  WishlistLoadedState({required this.items});

  WishlistLoadedState copyWith({List<WishlistItem>? items}) =>
      WishlistLoadedState(items: items ?? this.items);
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
