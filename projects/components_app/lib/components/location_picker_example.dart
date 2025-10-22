import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/common_appbar.dart';

class LocationPickerExample extends StatefulWidget {
  const LocationPickerExample({super.key});

  @override
  State<LocationPickerExample> createState() => _LocationPickerExampleState();
}

class _LocationPickerExampleState extends State<LocationPickerExample> {
  final _locationController = TextEditingController();
  final String? _apiKey = dotenv.env['API_KEY'];

  LocationData? _combinedLocation;
  LocationData? _inputOnlyLocation;
  LocationData? _noCurrentLocation;
  LocationData? _mapOnlyLocation;
  LocationData? _autofocusLocation;
  LocationData? _smallSizeLocation;
  LocationData? _mediumSizeLocation;
  LocationData? _largeSizeLocation;
  LocationData? _outlinedStyleLocation;
  LocationData? _filledStyleLocation;
  LocationData? _searchOnlyLocation;

  final Map<String, bool> _isPickerOpen = {};
  bool _autofocusInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAutofocus();
    });
  }

  Future<void> _initializeAutofocus() async {
    if (_autofocusInitialized) return;
    
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        _autofocusInitialized = true;
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String address = '';
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          address = "${place.street}, ${place.locality}, ${place.country}";
        }
      } catch (e) {
        address = 'Lat: ${position.latitude}, Lng: ${position.longitude}';
      }

      final locationData = LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );

      if (mounted) {
        setState(() {
          _autofocusLocation = locationData;
          _combinedLocation = locationData;
          _autofocusInitialized = true;
        });
        _updateSelectedLocationText(locationData);
      }
    } catch (e) {
      if (mounted) {
        _autofocusInitialized = true;
      }
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _updateSelectedLocationText(LocationData? location) {
    if (location != null) {
      _locationController.text = location.address;
    } else {
      _locationController.text = '';
    }
  }

  void _handleCurrentLocationPressed(String pickerId) async {
    if (_isPickerOpen[pickerId] == true) {
      return;
    }

    _isPickerOpen[pickerId] = true;

    final selected = await _openMapPicker();

    if (mounted) {
      _isPickerOpen[pickerId] = false;

      if (selected != null) {
        setState(() {
          switch (pickerId) {
            case 'combined':
              _combinedLocation = selected;
              break;
            case 'autofocus':
              _autofocusLocation = selected;
              _combinedLocation = selected;
              break;
            case 'map':
              _mapOnlyLocation = selected;
              break;
            case 'small':
              _smallSizeLocation = selected;
              break;
            case 'medium':
              _mediumSizeLocation = selected;
              break;
            case 'large':
              _largeSizeLocation = selected;
              break;
            case 'outlined':
              _outlinedStyleLocation = selected;
              break;
            case 'filled':
              _filledStyleLocation = selected;
              break;
          }
        });
        if (pickerId == 'combined' || pickerId == 'autofocus') {
          _updateSelectedLocationText(selected);
        }
      }
    } else {
      _isPickerOpen[pickerId] = false;
    }
  }

  void _handleLocationChanged(LocationData? location, String pickerId) async {
    if (_isPickerOpen[pickerId] == true) {
      return;
    }

    _isPickerOpen[pickerId] = true;

    final selected = await _openMapPicker(initialLocation: location);

    if (mounted) {
      _isPickerOpen[pickerId] = false;

      if (selected != null) {
        setState(() {
          switch (pickerId) {
            case 'combined':
              _combinedLocation = selected;
              break;
            case 'autofocus':
              _autofocusLocation = selected;
              _combinedLocation = selected;
              break;
            case 'map':
              _mapOnlyLocation = selected;
              break;
            case 'small':
              _smallSizeLocation = selected;
              break;
            case 'medium':
              _mediumSizeLocation = selected;
              break;
            case 'large':
              _largeSizeLocation = selected;
              break;
            case 'outlined':
              _outlinedStyleLocation = selected;
              break;
            case 'filled':
              _filledStyleLocation = selected;
              break;
          }
        });
        if (pickerId == 'combined' || pickerId == 'autofocus') {
          _updateSelectedLocationText(selected);
        }
      } else {
        setState(() {
          switch (pickerId) {
            case 'combined':
              _combinedLocation = null;
              break;
            case 'autofocus':
              _autofocusLocation = null;
              _combinedLocation = null;
              break;
            case 'map':
              _mapOnlyLocation = null;
              break;
            case 'small':
              _smallSizeLocation = null;
              break;
            case 'medium':
              _mediumSizeLocation = null;
              break;
            case 'large':
              _largeSizeLocation = null;
              break;
            case 'outlined':
              _outlinedStyleLocation = null;
              break;
            case 'filled':
              _filledStyleLocation = null;
              break;
          }
        });
        if (pickerId == 'combined' || pickerId == 'autofocus') {
          _updateSelectedLocationText(null);
        }
      }
    } else {
      _isPickerOpen[pickerId] = false;
    }
  }

  void _handleInputOnlyLocationChange(LocationData? location, String pickerId) {
    setState(() {
      switch (pickerId) {
        case 'input':
          _inputOnlyLocation = location;
          break;
        case 'no_current':
          _noCurrentLocation = location;
          break;
      }
    });
  }

  void _handleSearchOnlyLocationChange(LocationData? location) {
    setState(() {
      _searchOnlyLocation = location;
    });
  }

  Future<LocationData?> _openMapPicker({LocationData? initialLocation}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _GoogleMapPickerScreen(
          // Her zaman İstanbul'u başlangıç noktası olarak kullan
          initialPosition: const LatLng(41.0082, 28.9784),
        ),
      ),
    );

    return result as LocationData?;
  }

  void _showLocationMap(LocationData location) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _LocationMapViewScreen(location: location),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_apiKey == null || _apiKey!.isEmpty) {
      return OsmeaComponents.scaffold(
        backgroundColor: OsmeaColors.white,
        appBar: const OsmeaComponentsAppBar(
          screenKey: 'location_picker_example',
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.text(
              'API_KEY not found in your .env file. Please add your Google Maps API key and restart the app.',
              variant: OsmeaTextVariant.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'location_picker_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.text(
              '📍 Location Picker Examples',
              variant: OsmeaTextVariant.headlineSmall,
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.textField(
              controller: _locationController,
              label: 'Selected Location',
              readOnly: true,
              maxLines: 3,
            ),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('Variants'),
            _buildVariantExamples(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('Sizes'),
            _buildSizeExamples(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('Styles'),
            _buildStyleExamples(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return OsmeaComponents.text(
      title,
      variant: OsmeaTextVariant.titleMedium,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildVariantExamples() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text('Combined (Input + Map)',
            variant: OsmeaTextVariant.bodyMedium),
        OsmeaComponents.sizedBox(height: 8),
        LocationPickerWithSuggestions(
          apiKey: _apiKey!,
          onLocationChanged: (location) =>
              _handleLocationChanged(location, 'combined'),
          onShowMapPressed: () {
            if (_combinedLocation != null) {
              _showLocationMap(_combinedLocation!);
            }
          },
          onCurrentLocationPressed: () {
            _handleCurrentLocationPressed('combined');
          },
          variant: LocationPickerVariant.combined,
          initialLocation: _combinedLocation,
          showCurrentLocation: true,
          showMapButtonInSearch: true,
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.text('Input Only', variant: OsmeaTextVariant.bodyMedium),
        OsmeaComponents.sizedBox(height: 8),
        LocationPickerWithSuggestions(
          apiKey: _apiKey!,
          onLocationChanged: (location) =>
              _handleInputOnlyLocationChange(location, 'input'),
          variant: LocationPickerVariant.input,
          initialLocation: _inputOnlyLocation,
          showCurrentLocation: false,
          showMapButtonInSearch: false,
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.text('Without Current Location Button',
            variant: OsmeaTextVariant.bodyMedium),
        OsmeaComponents.sizedBox(height: 8),
        LocationPickerWithSuggestions(
          apiKey: _apiKey!,
          onLocationChanged: (location) =>
              _handleInputOnlyLocationChange(location, 'no_current'),
          label: 'Search Location',
          variant: LocationPickerVariant.input,
          initialLocation: _noCurrentLocation,
          showCurrentLocation: false,
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.text('Autofocus Current Location',
            variant: OsmeaTextVariant.bodyMedium),
        OsmeaComponents.sizedBox(height: 8),
        LocationPickerWithSuggestions(
          apiKey: _apiKey!,
          onLocationChanged: (location) =>
              _handleLocationChanged(location, 'autofocus'),
          onShowMapPressed: () {
            if (_autofocusLocation != null) {
              _showLocationMap(_autofocusLocation!);
            }
          },
          onCurrentLocationPressed: () =>
              _handleCurrentLocationPressed('autofocus'),
          label: 'Autofocus Location',
          variant: LocationPickerVariant.combined,
          initialLocation: _autofocusLocation,
          showCurrentLocation: true,
          autofocusCurrentLocation: true,
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.text('Map Only', variant: OsmeaTextVariant.bodyMedium),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.locationPicker(
          apiKey: _apiKey!,
          onLocationChanged: (location) =>
              _handleLocationChanged(location, 'map'),
          onShowMapPressed: () {
            if (_mapOnlyLocation != null) {
              _showLocationMap(_mapOnlyLocation!);
            }
          },
          onCurrentLocationPressed: () =>
              _handleCurrentLocationPressed('map'),
          variant: LocationPickerVariant.map,
          initialLocation: _mapOnlyLocation,
          showCurrentLocation: true,
          autofocusCurrentLocation: true,
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.text('Search Only (No Suggestions)',
            variant: OsmeaTextVariant.bodyMedium),
        OsmeaComponents.sizedBox(height: 8),
        LocationPickerSearchOnly(
          onLocationChanged: _handleSearchOnlyLocationChange,
          initialLocation: _searchOnlyLocation,
        ),
      ],
    );
  }

  Widget _buildSizeExamples() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text('Small', variant: OsmeaTextVariant.bodyMedium),
        OsmeaComponents.sizedBox(height: 8),
        LocationPickerWithSuggestions(
          apiKey: _apiKey!,
          onLocationChanged: (location) =>
              _handleLocationChanged(location, 'small'),
          onShowMapPressed: () {
            if (_smallSizeLocation != null) {
              _showLocationMap(_smallSizeLocation!);
            }
          },
          onCurrentLocationPressed: () =>
              _handleCurrentLocationPressed('small'),
          size: LocationPickerSize.small,
          hintText: 'Small size picker',
          initialLocation: _smallSizeLocation,
          showMapButtonInSearch: true,
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.text('Medium (Default)',
            variant: OsmeaTextVariant.bodyMedium),
        OsmeaComponents.sizedBox(height: 8),
        LocationPickerWithSuggestions(
          apiKey: _apiKey!,
          onLocationChanged: (location) =>
              _handleLocationChanged(location, 'medium'),
          onShowMapPressed: () {
            if (_mediumSizeLocation != null) {
              _showLocationMap(_mediumSizeLocation!);
            }
          },
          onCurrentLocationPressed: () =>
              _handleCurrentLocationPressed('medium'),
          size: LocationPickerSize.medium,
          hintText: 'Medium size picker',
          initialLocation: _mediumSizeLocation,
          showMapButtonInSearch: true,
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.text('Large', variant: OsmeaTextVariant.bodyMedium),
        OsmeaComponents.sizedBox(height: 8),
        LocationPickerWithSuggestions(
          apiKey: _apiKey!,
          onLocationChanged: (location) =>
              _handleLocationChanged(location, 'large'),
          onShowMapPressed: () {
            if (_largeSizeLocation != null) {
              _showLocationMap(_largeSizeLocation!);
            }
          },
          onCurrentLocationPressed: () =>
              _handleCurrentLocationPressed('large'),
          size: LocationPickerSize.large,
          hintText: 'Large size picker',
          initialLocation: _largeSizeLocation,
          showMapButtonInSearch: true,
        ),
      ],
    );
  }

  Widget _buildStyleExamples() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text('Outlined (Default)',
            variant: OsmeaTextVariant.bodyMedium),
        OsmeaComponents.sizedBox(height: 8),
        LocationPickerWithSuggestions(
          apiKey: _apiKey!,
          onLocationChanged: (location) =>
              _handleLocationChanged(location, 'outlined'),
          onShowMapPressed: () {
            if (_outlinedStyleLocation != null) {
              _showLocationMap(_outlinedStyleLocation!);
            }
          },
          onCurrentLocationPressed: () =>
              _handleCurrentLocationPressed('outlined'),
          style: LocationPickerStyle.outlined,
          label: 'Outlined Style',
          initialLocation: _outlinedStyleLocation,
          showMapButtonInSearch: true,
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.text('Filled', variant: OsmeaTextVariant.bodyMedium),
        OsmeaComponents.sizedBox(height: 8),
        LocationPickerWithSuggestions(
          apiKey: _apiKey!,
          onLocationChanged: (location) =>
              _handleLocationChanged(location, 'filled'),
          onShowMapPressed: () {
            if (_filledStyleLocation != null) {
              _showLocationMap(_filledStyleLocation!);
            }
          },
          onCurrentLocationPressed: () =>
              _handleCurrentLocationPressed('filled'),
          style: LocationPickerStyle.filled,
          label: 'Filled Style',
          initialLocation: _filledStyleLocation,
          showMapButtonInSearch: true,
        ),
      ],
    );
  }
}

/// Location Picker with Suggestions Widget
class LocationPickerWithSuggestions extends StatefulWidget {
  final String apiKey;
  final Function(LocationData?) onLocationChanged;
  final Function()? onShowMapPressed;
  final Function()? onCurrentLocationPressed;
  final LocationData? initialLocation;
  final String? label;
  final String? hintText;
  final bool showCurrentLocation;
  final bool showMapButtonInSearch;
  final LocationPickerVariant variant;
  final LocationPickerSize? size;
  final LocationPickerStyle? style;
  final bool autofocusCurrentLocation;

  const LocationPickerWithSuggestions({
    required this.apiKey,
    required this.onLocationChanged,
    this.onShowMapPressed,
    this.onCurrentLocationPressed,
    this.initialLocation,
    this.label,
    this.hintText,
    this.showCurrentLocation = true,
    this.showMapButtonInSearch = false,
    this.variant = LocationPickerVariant.combined,
    this.size,
    this.style,
    this.autofocusCurrentLocation = false,
    Key? key,
  }) : super(key: key);

  @override
  State<LocationPickerWithSuggestions> createState() =>
      _LocationPickerWithSuggestionsState();
}

class _LocationPickerWithSuggestionsState
    extends State<LocationPickerWithSuggestions> {
  final TextEditingController _searchController = TextEditingController();
  List<PlaceSuggestion> _predictions = [];
  bool _showSuggestions = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialLocation != null) {
      _searchController.text = widget.initialLocation!.address;
    }

    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _onSearchChanged() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _predictions = [];
        _showSuggestions = false;
      });
      return;
    }

    if (query.length < 2) return;

    setState(() => _isSearching = true);

    try {
      final suggestions = await _getPlacePredictions(query);

      if (mounted) {
        setState(() {
          _predictions = suggestions;
          _showSuggestions = _predictions.isNotEmpty;
          _isSearching = false;
        });
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  Future<List<PlaceSuggestion>> _getPlacePredictions(String input) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=$input'
          '&components=country:tr'
          '&key=${widget.apiKey}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final predictions = json['predictions'] as List;

        return predictions
            .map((p) => PlaceSuggestion(
                  placeId: p['place_id'],
                  description: p['description'],
                  mainText: p['main_text'] ?? p['description'],
                  secondaryText: p['secondary_text'] ?? '',
                ))
            .toList();
      }
    } catch (e) {
      print('Error: $e');
    }
    return [];
  }

  Future<void> _onSuggestionSelected(PlaceSuggestion suggestion) async {
    _searchController.text = suggestion.description;

    setState(() {
      _showSuggestions = false;
      _isSearching = true;
    });

    try {
      final locationData = await _getPlaceDetails(suggestion.placeId);

      if (locationData != null && mounted) {
        setState(() => _isSearching = false);
        widget.onLocationChanged(locationData);
      }

      if (mounted) {
        setState(() => _isSearching = false);
      }
    } catch (e) {
      print('Error fetching place details: $e');
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  Future<LocationData?> _getPlaceDetails(String placeId) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId'
          '&key=${widget.apiKey}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final result = json['result'];
        final geometry = result['geometry'];
        final location = geometry['location'];

        return LocationData(
          latitude: location['lat'],
          longitude: location['lng'],
          address: result['formatted_address'] ?? '',
        );
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.locationPicker(
          apiKey: widget.apiKey,
          onLocationChanged: widget.onLocationChanged,
          onShowMapPressed: widget.onShowMapPressed,
          onCurrentLocationPressed: widget.onCurrentLocationPressed,
          initialLocation: widget.initialLocation,
          label: widget.label,
          hintText: widget.hintText,
          showCurrentLocation: widget.showCurrentLocation,
          showMapButtonInSearch: widget.showMapButtonInSearch,
          variant: widget.variant,
          size: LocationPickerSize.medium,
          style: LocationPickerStyle.outlined,
          autofocusCurrentLocation: widget.autofocusCurrentLocation,
        ),
        if (_showSuggestions && _predictions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              constraints: const BoxConstraints(maxHeight: 250),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _predictions.length,
                itemBuilder: (context, index) {
                  final prediction = _predictions[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined, size: 20),
                    title: Text(
                      prediction.mainText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: prediction.secondaryText.isNotEmpty
                        ? Text(
                            prediction.secondaryText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          )
                        : null,
                    onTap: () => _onSuggestionSelected(prediction),
                    dense: true,
                  );
                },
              ),
            ),
          ),
        if (_isSearching)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
      ],
    );
  }
}

class PlaceSuggestion {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  PlaceSuggestion({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });
}

/// Location Picker Search Only Widget (No Suggestions)
class LocationPickerSearchOnly extends StatefulWidget {
  final Function(LocationData?) onLocationChanged;
  final LocationData? initialLocation;

  const LocationPickerSearchOnly({
    required this.onLocationChanged,
    this.initialLocation,
    Key? key,
  }) : super(key: key);

  @override
  State<LocationPickerSearchOnly> createState() =>
      _LocationPickerSearchOnlyState();
}

class _LocationPickerSearchOnlyState extends State<LocationPickerSearchOnly> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _searchController.text = widget.initialLocation!.address;
    }
  }

  void _handleTextChange(String value) {
    final locationData = LocationData(
      latitude: 0.0,
      longitude: 0.0,
      address: value,
    );
    widget.onLocationChanged(locationData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.textField(
      controller: _searchController,
      label: 'Search Location',
      hint: 'Enter location manually...',
      onChanged: _handleTextChange,
    );
  }
}

/// Google Map Picker Screen
class _GoogleMapPickerScreen extends StatefulWidget {
  final LatLng initialPosition;
  const _GoogleMapPickerScreen({required this.initialPosition});

  @override
  State<_GoogleMapPickerScreen> createState() => _GoogleMapPickerScreenState();
}

class _GoogleMapPickerScreenState extends State<_GoogleMapPickerScreen> {
  late GoogleMapController _controller;
  LatLng? _pickedLatLng;
  String _address = 'Select a location on the map';
  bool _isProcessing = false;
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    // Başlangıçta hiçbir konum seçili değil
    _pickedLatLng = null;
  }

  Future<void> _updateAddress(LatLng pos) async {
    if (!mounted) return;
    setState(() {
      _isProcessing = true;
    });

    try {
      final placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (mounted && placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _address = "${place.street}, ${place.locality}, ${place.country}";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _address = 'Lat: ${pos.latitude.toStringAsFixed(6)}, Lng: ${pos.longitude.toStringAsFixed(6)}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _confirmLocation() {
    if (_isConfirming || _pickedLatLng == null) {
      return;
    }

    _isConfirming = true;

    Navigator.pop(
      context,
      LocationData(
        latitude: _pickedLatLng!.latitude,
        longitude: _pickedLatLng!.longitude,
        address: _address,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: (_isProcessing || _isConfirming || _pickedLatLng == null) 
                ? null 
                : _confirmLocation,
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: widget.initialPosition, zoom: 12),
            onMapCreated: (controller) => _controller = controller,
            markers: _pickedLatLng != null
                ? {
                    Marker(
                      markerId: const MarkerId('picked'),
                      position: _pickedLatLng!,
                      draggable: true,
                      onDragEnd: (newPos) {
                        setState(() {
                          _pickedLatLng = newPos;
                        });
                        _updateAddress(newPos);
                      },
                    )
                  }
                : {},
            onTap: (pos) {
              setState(() {
                _pickedLatLng = pos;
              });
              _updateAddress(pos);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _address,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _pickedLatLng == null ? Colors.grey : Colors.black,
                    ),
                  ),
                  if (_pickedLatLng == null) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Tap on the map to select a location',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  if (_isProcessing) ...[
                    const SizedBox(height: 8),
                    const LinearProgressIndicator(),
                  ]
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// Location Map View Screen
class _LocationMapViewScreen extends StatefulWidget {
  final LocationData location;
  const _LocationMapViewScreen({required this.location});

  @override
  State<_LocationMapViewScreen> createState() => _LocationMapViewScreenState();
}

class _LocationMapViewScreenState extends State<_LocationMapViewScreen> {
  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 16,
        ),
        onMapCreated: (controller) => _controller = controller,
        markers: {
          Marker(
            markerId: const MarkerId('selected_location'),
            position:
                LatLng(widget.location.latitude, widget.location.longitude),
            infoWindow: InfoWindow(
              title: 'Selected Location',
              snippet: widget.location.address,
            ),
          )
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.location.address,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Latitude: ${widget.location.latitude.toStringAsFixed(6)}\nLongitude: ${widget.location.longitude.toStringAsFixed(6)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            )
          ],
        ),
      ),
    );
  }
}