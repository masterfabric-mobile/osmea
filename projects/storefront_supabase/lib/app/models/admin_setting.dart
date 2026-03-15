/// Key-value setting from admin_settings table.
class AdminSetting {
  final String id;
  final String key;
  final String? value;
  final DateTime updatedAt;

  AdminSetting({
    required this.id,
    required this.key,
    this.value,
    required this.updatedAt,
  });

  factory AdminSetting.fromJson(Map<String, dynamic> json) {
    return AdminSetting(
      id: json['id'] as String,
      key: json['key'] as String,
      value: json['value'] as String?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'value': value,
        'updated_at': updatedAt.toIso8601String(),
      };
}
