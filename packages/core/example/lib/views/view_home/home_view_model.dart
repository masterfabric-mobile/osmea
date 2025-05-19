// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:math';
import 'package:core/core.dart';
import 'package:example/views/view_home/models/product_model.dart';
import 'package:example/views/view_home/module/events.dart';
import 'package:example/views/view_home/module/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
// ignore: implementation_imports

@injectable
class HomeViewModel extends BaseViewModelBloc<HomeViewEvent, HomeViewState> {
  // Local storage helper instance
  final LocalStorageHelper _localStorage = LocalStorageHelper();

  // Storage keys - using constant names to ensure consistency
  static const String PRODUCT_LIST_KEY = 'product_list_key';
  static const String ENCRYPTED_PRODUCT_PREFIX = 'product_data_';
  static const String INIT_DONE_KEY = 'storage_init_done';

  HomeViewModel() : super(HomeViewInitialState()) {
    on<HomeViewInitialEvent>(_onInitialEvent);
    on<HomeViewLoadProductsEvent>(_onLoadProducts);
    on<HomeViewAddProductEvent>(_onAddProduct);
    on<HomeViewDeleteProductEvent>(_onDeleteProduct);

    // Initialize storage as soon as the ViewModel is created
    _initStorage();
  }

  // Initialize storage properly
  Future<void> _initStorage() async {
    try {
      debugPrint("🔄 Ensuring storage is initialized...");
      await _localStorage.init();

      // Mark initialization as complete
      await _localStorage.setItem(INIT_DONE_KEY, "true");
      debugPrint("✅ Storage initialized successfully");
    } catch (e) {
      debugPrint("❌ Error initializing storage: $e");
    }
  }

  // Initial event handler
  void _onInitialEvent(
      HomeViewInitialEvent event, Emitter<HomeViewState> emit) {
    // Load products when initialized
    add(HomeViewLoadProductsEvent());
  }

  // Load products event handler
  Future<void> _onLoadProducts(
      HomeViewLoadProductsEvent event, Emitter<HomeViewState> emit) async {
    try {
      emit(HomeViewLoadingState());

      // Make sure storage is initialized first
      await _initStorage();

      // Get product list
      final products = await _loadAllProducts();

      emit(HomeViewContentState(products: products));
      debugPrint("📋 Loaded ${products.length} products successfully");
    } catch (e) {
      debugPrint("❌ Error loading products: $e");
      emit(HomeViewErrorState(message: 'Failed to load products: $e'));
    }
  }

  // Add product event handler
  Future<void> _onAddProduct(
      HomeViewAddProductEvent event, Emitter<HomeViewState> emit) async {
    try {
      emit(HomeViewLoadingState());

      // Make sure storage is initialized
      await _initStorage();

      // Create new product
      final product = Product(
        id: _generateId(),
        name: event.name,
        price: event.price,
        description: event.description,
      );

      // Save product
      await _saveProduct(product);

      // Load updated product list
      final products = await _loadAllProducts();

      emit(HomeViewContentState(products: products));
      debugPrint("✅ Added product: ${product.name}");
    } catch (e) {
      debugPrint("❌ Error adding product: $e");
      emit(HomeViewErrorState(message: 'Failed to add product: $e'));
    }
  }

  // Delete product event handler
  Future<void> _onDeleteProduct(
      HomeViewDeleteProductEvent event, Emitter<HomeViewState> emit) async {
    try {
      emit(HomeViewLoadingState());

      // Make sure storage is initialized
      await _initStorage();

      // Delete the product
      await _deleteProduct(event.productId);

      // Load updated product list
      final products = await _loadAllProducts();

      emit(HomeViewContentState(products: products));
      debugPrint("🗑️ Deleted product: ${event.productId}");
    } catch (e) {
      debugPrint("❌ Error deleting product: $e");
      emit(HomeViewErrorState(message: 'Failed to delete product: $e'));
    }
  }

  // Save a product with encryption
  Future<void> _saveProduct(Product product) async {
    try {
      // Get current list of product IDs
      final List<String> productIds = await _getProductIds();

      // Add new product ID if not already in the list
      if (!productIds.contains(product.id)) {
        productIds.add(product.id);
        await _saveProductIds(productIds);
      }

      // Convert product to JSON string
      final String productJson = jsonEncode(product.toJson());

      // Save product with encryption
      debugPrint(
          "🔒 Encrypting and saving product: ${product.name} (ID: ${product.id})");
      await _localStorage.setEncryptedItem(
          '$ENCRYPTED_PRODUCT_PREFIX${product.id}', productJson);

      // Verify the product was saved correctly
      final String? savedData = await _localStorage
          .getEncryptedItem('$ENCRYPTED_PRODUCT_PREFIX${product.id}');
      if (savedData != null) {
        debugPrint("✅ Product saved and verified successfully");
      } else {
        debugPrint("⚠️ Product saved but verification failed");
      }
    } catch (e) {
      debugPrint("❌ Error saving product: $e");
      rethrow;
    }
  }

  // Load all products
  Future<List<Product>> _loadAllProducts() async {
    try {
      // Get product IDs
      final List<String> productIds = await _getProductIds();
      final List<Product> products = [];

      debugPrint("🔄 Loading ${productIds.length} products...");

      // Load each product by ID
      for (final id in productIds) {
        try {
          final product = await _loadProduct(id);
          if (product != null) {
            products.add(product);
            debugPrint("✅ Loaded product: ${product.name}");
          }
        } catch (e) {
          debugPrint("⚠️ Error loading product $id: $e");
        }
      }

      return products;
    } catch (e) {
      debugPrint("❌ Error loading all products: $e");
      return [];
    }
  }

  // Load a single product by ID
  Future<Product?> _loadProduct(String id) async {
    try {
      // Get encrypted product data
      final String? productJson =
          await _localStorage.getEncryptedItem('$ENCRYPTED_PRODUCT_PREFIX$id');
      if (productJson == null || productJson.isEmpty) {
        debugPrint("⚠️ No data found for product $id");
        return null;
      }

      // Decode JSON
      final Map<String, dynamic> productMap = jsonDecode(productJson);

      // Create product from JSON
      final product = Product.fromJson(productMap);
      return product;
    } catch (e) {
      debugPrint("❌ Error loading product $id: $e");
      return null;
    }
  }

  // Delete a product - enhanced to ensure persistence
  Future<void> _deleteProduct(String productId) async {
    try {
      // Get current product IDs
      final List<String> productIds = await _getProductIds();

      // Log the IDs before deletion
      debugPrint("🔍 Product IDs before deletion: $productIds");

      // Check if the product ID exists
      if (!productIds.contains(productId)) {
        debugPrint(
            "⚠️ Attempted to delete non-existent product ID: $productId");
        return;
      }

      // Remove product ID from list
      productIds.remove(productId);

      // Log the IDs after deletion
      debugPrint("🔍 Product IDs after deletion: $productIds");

      // Save updated product IDs list - CRITICAL for persistence
      await _saveProductIds(productIds);

      // Remove product data from encrypted storage
      await _localStorage.removeItem('$ENCRYPTED_PRODUCT_PREFIX$productId');

      // Verify the product list was updated
      final updatedIds = await _getProductIds();
      if (!updatedIds.contains(productId)) {
        debugPrint("✅ Product ID successfully removed from list: $productId");
      } else {
        debugPrint("⚠️ Product ID still in list after deletion: $productId");
        // Force another attempt to remove from list
        updatedIds.remove(productId);
        await _saveProductIds(updatedIds);
      }

      // Verify the product data was deleted
      final deletedData =
          await _localStorage.getItem('$ENCRYPTED_PRODUCT_PREFIX$productId');
      if (deletedData == null) {
        debugPrint("✅ Product data successfully deleted for ID: $productId");
      } else {
        debugPrint(
            "⚠️ Product data still exists after deletion for ID: $productId");
        // Force another removal attempt
        await _localStorage.removeItem('$ENCRYPTED_PRODUCT_PREFIX$productId');
      }

      debugPrint("🗑️ Product deletion complete: $productId");
    } catch (e) {
      debugPrint("❌ Error deleting product: $e");
      rethrow;
    }
  }

  // Save product IDs - enhanced to ensure persistence
  Future<void> _saveProductIds(List<String> ids) async {
    try {
      final String idsJson = jsonEncode(ids);
      debugPrint("💾 Saving product ID list: $idsJson");

      // Save to storage
      await _localStorage.setItem(PRODUCT_LIST_KEY, idsJson);

      // Verify the save was successful
      final savedIdsJson = await _localStorage.getItem(PRODUCT_LIST_KEY);
      if (savedIdsJson != null) {
        final savedIds = jsonDecode(savedIdsJson) as List<dynamic>;
        debugPrint("✅ Verified saved product IDs: $savedIds");

        // Check if all ids were saved correctly
        final List<String> stringIds = savedIds.cast<String>();
        if (stringIds.length != ids.length) {
          debugPrint(
              "⚠️ Saved product IDs count mismatch! Expected: ${ids.length}, Got: ${stringIds.length}");
          // Retry the save operation
          await _localStorage.setItem(PRODUCT_LIST_KEY, idsJson);
        }
      } else {
        debugPrint("⚠️ Failed to verify product IDs save");
        // Retry the save operation
        await _localStorage.setItem(PRODUCT_LIST_KEY, idsJson);
      }
    } catch (e) {
      debugPrint("❌ Error saving product IDs: $e");
      rethrow;
    }
  }

  // Get product IDs - enhanced with better error handling
  Future<List<String>> _getProductIds() async {
    try {
      final String? idsJson = await _localStorage.getItem(PRODUCT_LIST_KEY);

      if (idsJson == null || idsJson.isEmpty) {
        debugPrint("ℹ️ No product IDs found in storage, returning empty list");
        return [];
      }

      debugPrint("🔍 Retrieved product IDs JSON: $idsJson");

      // Parse the JSON and handle potential errors
      try {
        final dynamic decoded = jsonDecode(idsJson);
        if (decoded is List) {
          final List<String> productIds = List<String>.from(decoded);
          debugPrint("✅ Successfully parsed product IDs: $productIds");
          return productIds;
        } else {
          debugPrint("⚠️ Product IDs not in expected format: $decoded");
          return [];
        }
      } catch (e) {
        debugPrint("⚠️ Error parsing product ID list: $e");
        // If JSON parsing fails, try to reset the product list
        await _localStorage.setItem(PRODUCT_LIST_KEY, '[]');
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error getting product IDs: $e");
      return [];
    }
  }

  // Clear all products (useful for testing)
  Future<void> clearAllProducts() async {
    try {
      debugPrint("🧹 Clearing all products...");

      // Get all product IDs
      final productIds = await _getProductIds();

      // Delete each product's data
      for (final id in productIds) {
        await _localStorage.removeItem('$ENCRYPTED_PRODUCT_PREFIX$id');
      }

      // Clear the product IDs list
      await _localStorage.setItem(PRODUCT_LIST_KEY, '[]');

      // Verify the product list is empty
      final updatedIds = await _getProductIds();
      if (updatedIds.isEmpty) {
        debugPrint("✅ All products cleared successfully");
      } else {
        debugPrint(
            "⚠️ Failed to clear all products, ${updatedIds.length} remain");
      }

      // Update state to reflect empty product list
    } catch (e) {
      debugPrint("❌ Error clearing products: $e");
    }
  }

  // Generate unique ID
  String _generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final buffer = StringBuffer();

    for (int i = 0; i < 10; i++) {
      buffer.write(chars[random.nextInt(chars.length)]);
    }

    final id = buffer.toString();
    debugPrint("🆔 Generated ID: $id");
    return id;
  }

  // Public methods
  void loadProducts() {
    add(HomeViewLoadProductsEvent());
  }

  void addProduct(String name, double price, String description) {
    add(HomeViewAddProductEvent(
      name: name,
      price: price,
      description: description,
    ));
  }

  void deleteProduct(String productId) {
    add(HomeViewDeleteProductEvent(productId: productId));
  }

  // Add a public method to clear all products
  void clearAll() {
    clearAllProducts();
  }
}