import 'package:core/core.dart';

/// Stores user's product search history on-device (hydrated).
///
/// - Persisted automatically via Hydrated storage (enabled in `starter.dart`)
/// - Used by both Product List (All Products) and Search views
class ProductSearchHistoryCubit extends BaseViewModelHydratedCubit<List<String>> {
  ProductSearchHistoryCubit({
    this.maxItems = 20,
  }) : super(const []);

  final int maxItems;

  @override
  String get id => 'product_search_history_v1';

  List<String> get history => List.unmodifiable(state);

  void addQuery(String query) {
    final normalized = query.trim();
    if (normalized.isEmpty) return;

    final next = List<String>.from(state);

    // De-dupe case-insensitively while keeping the latest casing.
    final existingIndex = next.indexWhere(
      (item) => item.trim().toLowerCase() == normalized.toLowerCase(),
    );
    if (existingIndex != -1) {
      next.removeAt(existingIndex);
    }

    next.insert(0, normalized);

    if (next.length > maxItems) {
      next.removeRange(maxItems, next.length);
    }

    emit(next);
  }

  void removeQuery(String query) {
    final normalized = query.trim();
    if (normalized.isEmpty) return;

    final next = List<String>.from(state)
      ..removeWhere((item) => item.trim().toLowerCase() == normalized.toLowerCase());
    emit(next);
  }

  void clearAll() {
    emit(const []);
  }

  @override
  Map<String, dynamic>? toJson(List<String> state) {
    return {'history': state};
  }

  @override
  List<String>? fromJson(Map<String, dynamic> json) {
    final raw = json['history'];
    if (raw is List) {
      return raw.whereType<String>().map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    return const [];
  }
}

