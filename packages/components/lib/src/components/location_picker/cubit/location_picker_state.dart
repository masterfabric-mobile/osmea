import 'package:equatable/equatable.dart';
import '../models/location_model.dart';

/// 📍 **Location Picker State**
class LocationPickerState extends Equatable {
  /// The currently selected location.
  final LocationData? selectedLocation;
  /// The current text in the search query input.
  final String searchQuery;
  /// A list of location suggestions based on the search query.
  final List<LocationData> suggestions;
  /// Indicates if the component is in a loading state (e.g., fetching suggestions).
  final bool isLoading;
  /// Holds an error message if an operation fails.
  final String? error;
  /// Controls the visibility of the map view in the `combined` variant.
  final bool isMapVisible;
  /// Indicates if the selected location has changed (used for callbacks).
  final bool locationChanged;
  /// Indicates if the show map button in search bar was pressed.
  final bool showMapButtonInSearch;
  /// Haritayı aç (Current Location butonu için - her seferinde çalışmalı)
  final bool openMapForLocation;

  const LocationPickerState({
    this.selectedLocation,
    this.searchQuery = '',
    this.suggestions = const [],
    this.isLoading = false,
    this.error,
    this.isMapVisible = false,
    this.locationChanged = false,
    this.showMapButtonInSearch = false,
    this.openMapForLocation = false,
  });

  /// Creates a copy of the state with updated values.
  LocationPickerState copyWith({
    LocationData? selectedLocation,
    bool? clearSelectedLocation,
    String? searchQuery,
    List<LocationData>? suggestions,
    bool? isLoading,
    String? error,
    bool? isMapVisible,
    bool? locationChanged,
    bool? showMapButtonInSearch,
    bool? openMapForLocation,
  }) {
    return LocationPickerState(
      selectedLocation: (clearSelectedLocation ?? false)
          ? null
          : selectedLocation ?? this.selectedLocation,
      searchQuery: searchQuery ?? this.searchQuery,
      suggestions: suggestions ?? this.suggestions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isMapVisible: isMapVisible ?? this.isMapVisible,
      locationChanged: locationChanged ?? false,
      showMapButtonInSearch: showMapButtonInSearch ?? false,
      openMapForLocation: openMapForLocation ?? false,
    );
  }

  @override
  List<Object?> get props => [
        selectedLocation,
        searchQuery,
        suggestions,
        isLoading,
        error,
        isMapVisible,
        locationChanged,
        showMapButtonInSearch,
        openMapForLocation,
      ];
}