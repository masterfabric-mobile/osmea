import 'package:flutter_bloc/flutter_bloc.dart';
import 'location_picker_state.dart';
import '../models/location_model.dart';
import 'dart:async';

/// 📍 **Location Picker Cubit**
class LocationPickerCubit extends Cubit<LocationPickerState> {
  final String apiKey;
  Timer? _debounce;
  bool _autofocusUsed = false; // Autofocus'u sadece bir kez kullan

  LocationPickerCubit(this.apiKey) : super(const LocationPickerState());

  /// Called when the search query changes.
  void onSearchChanged(String query) {
    final clearSelection = query.isEmpty;
    emit(state.copyWith(
      searchQuery: query,
      isLoading: true,
      error: null,
      clearSelectedLocation: clearSelection,
    ));

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        emit(state.copyWith(suggestions: [], isLoading: false));
        return;
      }
      _fetchSuggestions(query);
    });
  }

  /// Fetches location suggestions based on the query.
  Future<void> _fetchSuggestions(String query) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final results = [
        const LocationData(
            latitude: 41.0082,
            longitude: 28.9784,
            address: 'Istanbul, Turkey',
            name: 'Istanbul'),
        const LocationData(
            latitude: 39.9334,
            longitude: 32.8597,
            address: 'Ankara, Turkey',
            name: 'Ankara'),
        const LocationData(
            latitude: 38.4237,
            longitude: 27.1428,
            address: 'Izmir, Turkey',
            name: 'Izmir'),
      ]
          .where((loc) =>
              loc.address.toLowerCase().contains(query.toLowerCase()))
          .toList();

      emit(state.copyWith(suggestions: results, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
          error: 'Failed to fetch suggestions.', isLoading: false));
    }
  }

  /// Selects a location and updates the state.
  void selectLocation(LocationData location) {
    emit(state.copyWith(
      selectedLocation: location,
      searchQuery: location.address,
      suggestions: [],
      isMapVisible: false,
      locationChanged: true,
    ));
  }

  /// Clears the currently selected location.
  void clearLocation() {
    emit(state.copyWith(
      selectedLocation: null,
      searchQuery: '',
      suggestions: [],
      isMapVisible: false,
      clearSelectedLocation: true,
      locationChanged: false,
    ));
  }

  /// Toggles the visibility of the map view.
  void toggleMapVisibility() {
    emit(state.copyWith(isMapVisible: !state.isMapVisible));
  }

  /// Called when the show map button in search bar is pressed.
  void onShowMapPressed() {
    emit(state.copyWith(showMapButtonInSearch: true));
    emit(state.copyWith(showMapButtonInSearch: false));
  }

  /// Açılır haritayı aç (Her seferinde çalışmalı - Current Location butonu için)
  void openMapForCurrentLocation() {
    emit(state.copyWith(openMapForLocation: true));
    emit(state.copyWith(openMapForLocation: false));
  }

  /// Fetches the user's current location (sadece ilk kez çalışır - autofocus için).
  Future<void> getCurrentLocation() async {
    // Autofocus zaten kullanıldıysa tekrar çalışmasın
    if (_autofocusUsed) {
      return;
    }
    
    _autofocusUsed = true;
    
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await Future.delayed(const Duration(seconds: 1));
      const location = LocationData(
          latitude: 41.0082,
          longitude: 28.9784,
          address: 'Istanbul, Turkey',
          name: 'Istanbul');
      emit(state.copyWith(
        selectedLocation: location,
        searchQuery: location.address,
        suggestions: [],
        isMapVisible: false,
        locationChanged: true,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
          error: 'Failed to get current location.', isLoading: false));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}