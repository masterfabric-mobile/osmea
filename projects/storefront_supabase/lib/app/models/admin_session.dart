class AdminSession {
  final String id;
  final String? adminId;
  final String? adminEmail;
  final String? ipAddress;
  final String? userAgent;
  final DateTime createdAt;

  AdminSession({
    required this.id,
    this.adminId,
    this.adminEmail,
    this.ipAddress,
    this.userAgent,
    required this.createdAt,
  });

  factory AdminSession.fromJson(Map<String, dynamic> json) {
    final admin = json['admin_users'];
    return AdminSession(
      id: json['id'] as String,
      adminId: json['admin_id'] as String?,
      adminEmail: admin is Map<String, dynamic> ? admin['email'] as String? : null,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
