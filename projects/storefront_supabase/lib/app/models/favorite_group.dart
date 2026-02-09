class FavoriteGroup {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;

  FavoriteGroup({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
  });

  factory FavoriteGroup.fromJson(Map<String, dynamic> json) {
    return FavoriteGroup(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
