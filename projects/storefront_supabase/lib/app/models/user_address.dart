class UserAddress {
  final String id;
  final String userId;
  final String? label;
  final String? address;
  final String? city;
  final String? postalCode;
  final String? country;
  final String? phone;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserAddress({
    required this.id,
    required this.userId,
    this.label,
    this.address,
    this.city,
    this.postalCode,
    this.country,
    this.phone,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      label: json['label'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      postalCode: json['postal_code'] as String?,
      country: json['country'] as String?,
      phone: json['phone'] as String?,
      isDefault: (json['is_default'] as bool?) ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'label': label,
      'address': address,
      'city': city,
      'postal_code': postalCode,
      'country': country,
      'phone': phone,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Convert to Map for checkout (billing/shipping address format)
  Map<String, dynamic> toCheckoutMap() {
    return {
      'address': address ?? '',
      'city': city ?? '',
      'postal_code': postalCode ?? '',
      'country': country ?? '',
      'phone': phone ?? '',
    };
  }

  /// Get display name for the address
  String get displayName {
    if (label != null && label!.isNotEmpty) return label!;
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    return parts.isEmpty ? 'Address' : parts.join(', ');
  }

  UserAddress copyWith({
    String? id,
    String? userId,
    String? label,
    String? address,
    String? city,
    String? postalCode,
    String? country,
    String? phone,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserAddress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
