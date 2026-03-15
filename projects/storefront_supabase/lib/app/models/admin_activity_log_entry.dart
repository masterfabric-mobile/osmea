class AdminActivityLogEntry {
  final String id;
  final String action;
  final String? adminId;
  final String? adminEmail;
  final String? targetTable;
  final String? targetId;
  final Map<String, dynamic>? details;
  final DateTime createdAt;

  AdminActivityLogEntry({
    required this.id,
    required this.action,
    this.adminId,
    this.adminEmail,
    this.targetTable,
    this.targetId,
    this.details,
    required this.createdAt,
  });

  factory AdminActivityLogEntry.fromJson(Map<String, dynamic> json) {
    final admin = json['admin_users'];
    final details = json['details'];
    return AdminActivityLogEntry(
      id: json['id'] as String,
      action: json['action'] as String? ?? '',
      adminId: json['admin_id'] as String?,
      adminEmail: admin is Map<String, dynamic> ? admin['email'] as String? : null,
      targetTable: json['target_table'] as String?,
      targetId: json['target_id']?.toString(),
      details: details is Map<String, dynamic> ? details : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
