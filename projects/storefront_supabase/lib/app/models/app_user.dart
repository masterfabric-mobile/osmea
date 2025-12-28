class AppUser {
  final String id;
  final String? email;
  final String? fullName;
  final DateTime createdAt;
  final String? avatarUrl;
  final String? role;

  AppUser({
    required this.id,
    this.email,
    this.fullName,
    required this.createdAt,
    this.avatarUrl,
    this.role,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String?,
      fullName: json['full_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String?,
    );
  }
}
