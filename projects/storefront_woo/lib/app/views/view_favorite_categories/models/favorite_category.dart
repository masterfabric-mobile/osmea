/*
 * FavoriteCategory
 * ----------------
 * Model representing a favorite category.
 */

class FavoriteCategory {
  final int id;
  final String name;
  final String? imageUrl;
  final DateTime addedAt;

  FavoriteCategory({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory FavoriteCategory.fromJson(Map<String, dynamic> json) {
    return FavoriteCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }
}

