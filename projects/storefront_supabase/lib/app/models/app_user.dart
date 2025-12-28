class AppUser {
  final String id;
  final String? email;
  final String? fullName;
  final String? username;
  final DateTime createdAt;
  final String? avatarUrl;
  final String? role;
  final String? gender;
  final int? age;
  final DateTime? birthdate;
  final String? phone;
  final String? address;
  final String? city;
  final String? postalCode;
  final String? country;

  AppUser({
    required this.id,
    this.email,
    this.fullName,
    this.username,
    required this.createdAt,
    this.avatarUrl,
    this.role,
    this.gender,
    this.age,
    this.birthdate,
    this.phone,
    this.address,
    this.city,
    this.postalCode,
    this.country,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String?,
      fullName: json['full_name'] as String?,
      username: json['username'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      birthdate: json['birthdate'] != null ? DateTime.parse(json['birthdate'] as String) : null,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      postalCode: json['postal_code'] as String?,
      country: json['country'] as String?,
    );
  }
}
