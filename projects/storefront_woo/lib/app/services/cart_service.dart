/*
 * CartService
 * ----------
 * Service for managing cart state following OSMEA architecture.
 * Uses ChangeNotifier for reactive state management.
 */

import 'package:flutter/foundation.dart';

/// Cart item model
class CartItem {
  final int productId;
  final String productName;
  final double price;
  int quantity;
  final String? imageUrl;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  /// Total price for this item
  double get totalPrice => price * quantity;
}

/// Cart service for managing cart state
class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  /// Get all cart items
  List<CartItem> get items => List.unmodifiable(_items);

  /// Get total number of items in cart
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Get total price of all items in cart
  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Add item to cart
  void addItem(CartItem newItem) {
    final existingIndex = _items.indexWhere(
      (item) => item.productId == newItem.productId,
    );

    if (existingIndex != -1) {
      // Update existing item quantity
      _items[existingIndex].quantity += newItem.quantity;
    } else {
      // Add new item
      _items.add(newItem);
    }

    notifyListeners();
  }

  /// Remove item from cart
  void removeItem(int productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  /// Update item quantity
  void updateQuantity(int productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }

    final existingIndex = _items.indexWhere(
      (item) => item.productId == productId,
    );

    if (existingIndex != -1) {
      _items[existingIndex].quantity = newQuantity;
      notifyListeners();
    }
  }

  /// Clear all items from cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// Check if product is in cart
  bool isInCart(int productId) {
    return _items.any((item) => item.productId == productId);
  }

  /// Get item by product ID
  CartItem? getItem(int productId) {
    try {
      return _items.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }
}