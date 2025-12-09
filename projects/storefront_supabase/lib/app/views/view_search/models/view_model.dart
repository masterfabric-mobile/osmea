import 'package:core/core.dart' hide SearchState;
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'states.dart';

@injectable
class SearchViewModel extends BaseViewModelCubit<SearchState> {
  late final TextEditingController searchController;
  final SupabaseClient _supabaseClient;

  SearchViewModel(this._supabaseClient) : super(SearchInitialState()) {
    searchController = TextEditingController();
  }

  Future<void> initial() async {
    stateChanger(SearchLoadedState(searchResults: []));
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      stateChanger(SearchLoadedState(searchResults: []));
      return;
    }

    stateChanger(SearchLoadingState());
    try {
      final response = await _supabaseClient
          .from('products')
          .select('*, product_images(image_url, is_primary)')
          .ilike('name', '%$query%');

      final products =
          response.map((data) => Product.fromJson(data)).toList();
      stateChanger(SearchLoadedState(searchResults: products));
    } catch (e) {
      stateChanger(SearchErrorState('Failed to perform search: $e'));
    }
  }

  void dispose() {
    searchController.dispose();
  }
}
