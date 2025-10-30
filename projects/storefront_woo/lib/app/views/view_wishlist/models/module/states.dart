import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart'
    show WishlistItem;

/// Saved/Wishlist states - mirrors Home states structure
abstract class WishlistState {}

class WishlistInitialState extends WishlistState {}

class WishlistLoadingState extends WishlistState {}

class WishlistLoadedState extends WishlistState {
  final List<WishlistItem> items;

  WishlistLoadedState({required this.items});

  WishlistLoadedState copyWith({List<WishlistItem>? items}) =>
      WishlistLoadedState(items: items ?? this.items);

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
  };

  factory WishlistLoadedState.fromJson(Map<String, dynamic> json) {
    final raw = json['items'] as List<dynamic>? ?? [];
    return WishlistLoadedState(
      items: raw
          .whereType<Map<String, dynamic>>()
          .map(WishlistItem.fromJson)
          .toList(),
    );
  }
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
