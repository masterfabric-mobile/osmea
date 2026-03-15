class AdminStaffUser {
  final String id;
  final String email;
  final String? fullName;
  final String role;
  final bool isActive;
  final DateTime? lastLogin;
  final DateTime createdAt;

  AdminStaffUser({
    required this.id,
    required this.email,
    this.fullName,
    required this.role,
    required this.isActive,
    this.lastLogin,
    required this.createdAt,
  });

  factory AdminStaffUser.fromJson(Map<String, dynamic> json) {
    return AdminStaffUser(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String?,
      role: json['role'] as String? ?? 'staff',
      isActive: json['is_active'] as bool? ?? true,
      lastLogin: json['last_login'] != null
          ? DateTime.tryParse(json['last_login'].toString())
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
