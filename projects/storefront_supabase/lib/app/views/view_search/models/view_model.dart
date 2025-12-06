import 'package:core/core.dart' hide SearchState;
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart'; // Import for TextEditingController

import 'states.dart';

@injectable
class SearchViewModel extends BaseViewModelCubit<SearchState> {
  late final TextEditingController searchController;

  SearchViewModel() : super(SearchInitialState()) {
    searchController = TextEditingController();
  }

  Future<void> initial() async {
    // Optionally load some initial data or suggestions
    stateChanger(SearchLoadedState(searchResults: []));
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      stateChanger(SearchLoadedState(searchResults: []));
      return;
    }

    stateChanger(SearchLoadingState());
    try {
      // Simulate API call for search
      await Future.delayed(const Duration(milliseconds: 700));
      final results = _simulateSearchResults(query);
      stateChanger(SearchLoadedState(searchResults: results));
    } catch (e) {
      stateChanger(SearchErrorState('Failed to perform search: $e'));
    }
  }

  List<String> _simulateSearchResults(String query) {
    final allItems = [
      'Apple iPhone 15', 'Samsung Galaxy S24', 'Google Pixel 8',
      'MacBook Pro M3', 'Dell XPS 15', 'HP Spectre x360',
      'Sony WH-1000XM5 Headphones', 'Bose QuietComfort Earbuds II',
      'LG OLED TV', 'Samsung QLED TV', 'Hisense ULED TV',
      'Logitech MX Master 3S Mouse', 'Keychron K2 Keyboard',
      'Ergonomic Office Chair', 'Standing Desk',
      'Nintendo Switch', 'PlayStation 5', 'Xbox Series X',
      'The Lord of the Rings Book Set', 'Harry Potter Complete Collection',
      'Dune Paperback', 'Project Hail Mary',
      'Running Shoes', 'Smartwatch', 'Fitness Tracker',
      'Water Bottle', 'Yoga Mat', 'Resistance Bands',
      'Coffee Maker', 'Air Fryer', 'Instant Pot',
      'Blender', 'Toaster', 'Electric Kettle',
      'Smart Plug', 'Smart Bulb', 'Robot Vacuum',
      'Security Camera', 'Video Doorbell', 'Smart Thermostat',
    ];

    return allItems
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void dispose() {
    searchController.dispose();
  }
}
