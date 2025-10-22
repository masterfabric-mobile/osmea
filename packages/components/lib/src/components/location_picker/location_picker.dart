import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/core/container_widget.dart';
import 'package:osmea_components/src/enums/location_picker_enums.dart';
import 'package:osmea_components/src/utils/location_picker_extensions.dart';
import 'cubit/location_picker_cubit.dart';
import 'cubit/location_picker_state.dart';
import 'models/location_model.dart';

/// 📍 **OSMEA Location Picker**
class OsmeaLocationPicker extends CoreContainer {
  final LocationData? location;
  final LocationData? initialLocation;
  final ValueChanged<LocationData?> onLocationChanged;
  final VoidCallback? onShowMapPressed;
  final VoidCallback? onCurrentLocationPressed;
  final LocationPickerVariant variant;
  final LocationPickerSize size;
  final LocationPickerStyle style;
  final String? label;
  final String? hintText;
  final bool isRequired;
  final String apiKey;
  final bool showCurrentLocation;
  final bool autofocusCurrentLocation;
  final bool showMapButtonInSearch;

  const OsmeaLocationPicker({
    super.key,
    this.location,
    this.initialLocation,
    required this.onLocationChanged,
    this.onShowMapPressed,
    this.onCurrentLocationPressed,
    required this.apiKey,
    this.variant = LocationPickerVariant.combined,
    this.size = LocationPickerSize.medium,
    this.style = LocationPickerStyle.outlined,
    this.label,
    this.hintText,
    this.isRequired = false,
    this.showCurrentLocation = true,
    this.autofocusCurrentLocation = false,
    this.showMapButtonInSearch = false,
  });

  @override
  Widget buildWidget(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationPickerCubit(apiKey),
      child: _LocationPickerView(
        picker: this,
      ),
    );
  }
}

class _LocationPickerView extends StatefulWidget {
  final OsmeaLocationPicker picker;

  const _LocationPickerView({required this.picker});

  @override
  State<_LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<_LocationPickerView> {
  final TextEditingController _searchController = TextEditingController();
  late final LocationPickerCubit _cubit;
  LocationData? _lastNotifiedLocation;
  bool _autofocusInitialized = false;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<LocationPickerCubit>();
    
    if (widget.picker.initialLocation != null) {
      _cubit.selectLocation(widget.picker.initialLocation!);
      _lastNotifiedLocation = widget.picker.initialLocation;
      _autofocusInitialized = true;
    } 
    else if (widget.picker.autofocusCurrentLocation && !_autofocusInitialized) {
      _autofocusInitialized = true;
      _cubit.getCurrentLocation();
    }
  }

  @override
  void didUpdateWidget(covariant _LocationPickerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.picker.initialLocation != oldWidget.picker.initialLocation) {
      if (widget.picker.initialLocation != null) {
        _cubit.selectLocation(widget.picker.initialLocation!);
        _lastNotifiedLocation = widget.picker.initialLocation;
        _autofocusInitialized = true;
      } else {
        _cubit.clearLocation();
        _lastNotifiedLocation = null;
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeConfig = widget.picker.size.getConfig(context);

    return BlocConsumer<LocationPickerCubit, LocationPickerState>(
      listener: (context, state) {
        if (state.locationChanged &&
            state.selectedLocation != _lastNotifiedLocation) {
          _lastNotifiedLocation = state.selectedLocation;
          widget.picker.onLocationChanged(state.selectedLocation);
        }

        if (_searchController.text != state.searchQuery) {
          _searchController.text = state.searchQuery;
        }

        if (state.showMapButtonInSearch &&
            widget.picker.onShowMapPressed != null) {
          widget.picker.onShowMapPressed!.call();
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.picker.label != null) ...[
              Text(
                widget.picker.label!,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
            ],
            if (widget.picker.variant != LocationPickerVariant.map)
              _buildSearchField(context, state, sizeConfig),
            if ((state.suggestions.isNotEmpty && !state.isMapVisible) ||
                (widget.picker.variant != LocationPickerVariant.input &&
                    state.isMapVisible)) ...[
              const SizedBox(height: 4),
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.suggestions.isNotEmpty && !state.isMapVisible)
                      _buildSuggestionsListView(context, state),
                    if (widget.picker.variant != LocationPickerVariant.input &&
                        state.isMapVisible) ...[
                      _buildMapView(context, state, sizeConfig),
                    ]
                  ],
                ),
              ),
            ]
          ],
        );
      },
    );
  }

  Widget _buildSearchField(BuildContext context, LocationPickerState state,
      LocationPickerSizeConfig sizeConfig) {
    return OsmeaComponents.textField(
      controller: _searchController,
      hint: widget.picker.hintText ?? 'Search for a location...',
      onChanged: (query) {
        if (query != state.searchQuery) {
          _cubit.onSearchChanged(query);
        }
      },
      size: _mapToTextFieldSize(widget.picker.size),
      variant: _mapToTextFieldVariant(widget.picker.style),
      prefixIcon: const Icon(Icons.search),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (widget.picker.showCurrentLocation)
            IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: () {
                if (widget.picker.onCurrentLocationPressed != null) {
                  // Use Current Location - Konum seç (Google Maps aç)
                  widget.picker.onCurrentLocationPressed!.call();
                } else {
                  // Fallback: sadece konum al
                  _cubit.getCurrentLocation();
                }
              },
              tooltip: 'Use current location',
            ),
          if (widget.picker.showMapButtonInSearch &&
              state.selectedLocation != null)
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: () {
                if (widget.picker.onShowMapPressed != null) {
                  widget.picker.onShowMapPressed!.call();
                }
              },
              tooltip: 'Show on map',
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsListView(
      BuildContext context, LocationPickerState state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.suggestions.length,
      itemBuilder: (context, index) {
        final location = state.suggestions[index];
        return ListTile(
          title: Text(location.name ?? location.address),
          subtitle: location.name != null ? Text(location.address) : null,
          onTap: () {
            context.read<LocationPickerCubit>().selectLocation(location);
          },
        );
      },
    );
  }

  Widget _buildMapView(BuildContext context, LocationPickerState state,
      LocationPickerSizeConfig sizeConfig) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Text(
                state.selectedLocation?.address ?? 'Map View Placeholder',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFieldSize _mapToTextFieldSize(LocationPickerSize size) {
    switch (size) {
      case LocationPickerSize.small:
        return TextFieldSize.small;
      case LocationPickerSize.medium:
        return TextFieldSize.medium;
      case LocationPickerSize.large:
        return TextFieldSize.large;
    }
  }

  TextFieldVariant _mapToTextFieldVariant(LocationPickerStyle style) {
    switch (style) {
      case LocationPickerStyle.filled:
        return TextFieldVariant.filled;
      case LocationPickerStyle.outlined:
        return TextFieldVariant.outlined;
    }
  }
}