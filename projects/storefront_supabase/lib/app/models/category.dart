class Category {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? imageUrl;
  final String? parentId;
  final int? count;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.imageUrl,
    this.parentId,
    this.count,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    int? parsedCount;
    if (json['products'] != null && json['products'] is List && (json['products'] as List).isNotEmpty) {
       final firstItem = (json['products'] as List).first;
       if (firstItem is Map && firstItem.containsKey('count')) {
         parsedCount = firstItem['count'] as int?;
       }
    }

    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      parentId: json['parent_id'] as String?,
      count: parsedCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
