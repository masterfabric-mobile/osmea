import 'package:equatable/equatable.dart';

/// 📍 **Location Data Model**
///
/// Represents a geographical location with coordinates and an address.
class LocationData extends Equatable {
  /// The latitude of the location.
  final double latitude;

  /// The longitude of the location.
  final double longitude;

  /// The formatted address string.
  final String address;

  /// An optional name for the location (e.g., "Home", "Work").
  final String? name;

  const LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.name,
  });

  @override
  List<Object?> get props => [latitude, longitude, address, name];
}
