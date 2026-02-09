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
    final idRaw = json['id'];
    final id = idRaw is int
        ? idRaw
        : (idRaw is num
            ? idRaw.toInt()
            : int.tryParse(idRaw?.toString() ?? '') ?? 0);
    final logoUrl = json['logo_url'] ?? json['logoUrl'];

    return Brand(
      id: id,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      logoUrl: logoUrl is String ? logoUrl : (logoUrl?.toString().isNotEmpty == true ? logoUrl.toString() : null),
      description: json['description'] as String?,
    );
  }

  Brand copyWith({
    int? id,
    String? name,
    String? slug,
    String? logoUrl,
    String? description,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      logoUrl: logoUrl ?? this.logoUrl,
      description: description ?? this.description,
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
