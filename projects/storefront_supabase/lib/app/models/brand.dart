class Brand {
  final int id;
  final String name;
  final String slug;
  final String? logoUrl;
  final String? description;

  Brand({
    required this.id,
    required this.name,
    required this.slug,
    this.logoUrl,
    this.description,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      logoUrl: json['logo_url'] as String?,
      description: json['description'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Brand && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
