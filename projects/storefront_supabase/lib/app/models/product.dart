class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? salePrice;
  final List<String> imageUrls;
  final String imageUrl; // Primary image for backward compatibility
  final String? targetAgeGroup;
  final bool isFeatured;
  final double? rating;
  final int reviewCount;
  final int? viewCount;
  final int? salesCount;
  final List<String>? tags;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.salePrice,
    required this.imageUrls,
    required this.imageUrl,
    this.targetAgeGroup,
    this.isFeatured = false,
    this.rating,
    this.reviewCount = 0,
    this.viewCount,
    this.salesCount,
    this.tags,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final images = json['product_images'] as List<dynamic>?;
    List<String> imageUrlsList = [];
    String primaryImageUrl =
        'https://placehold.co/600x400'; // Default placeholder

    if (images != null && images.isNotEmpty) {
      // Sort by sort_order and is_primary
      final sortedImages = List<Map<String, dynamic>>.from(images);
      sortedImages.sort((a, b) {
        final aPrimary = a['is_primary'] == true ? 0 : 1;
        final bPrimary = b['is_primary'] == true ? 0 : 1;
        if (aPrimary != bPrimary) return aPrimary.compareTo(bPrimary);
        final aOrder = a['sort_order'] as int? ?? 999;
        final bOrder = b['sort_order'] as int? ?? 999;
        return aOrder.compareTo(bOrder);
      });

      imageUrlsList = sortedImages
          .map((img) => img['image_url'] as String?)
          .whereType<String>()
          .toList();

      if (imageUrlsList.isNotEmpty) {
        primaryImageUrl = imageUrlsList.first;
      }
    }

    // Parse tags if available
    List<String>? tagsList;
    if (json['tags'] != null) {
      if (json['tags'] is List) {
        tagsList = List<String>.from(json['tags']);
      } else if (json['tags'] is String) {
        tagsList = (json['tags'] as String)
            .split(',')
            .map((e) => e.trim())
            .toList();
      }
    }

    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      salePrice: json['sale_price'] != null
          ? (json['sale_price'] as num).toDouble()
          : null,
      imageUrls: imageUrlsList.isNotEmpty ? imageUrlsList : [primaryImageUrl],
      imageUrl: primaryImageUrl,
      targetAgeGroup: json['target_age_group'] as String?,
      isFeatured: json['is_featured'] as bool? ?? false,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      reviewCount: json['review_count'] as int? ?? 0,
      viewCount: json['view_count'] as int?,
      salesCount: json['sales_count'] as int?,
      tags: tagsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'sale_price': salePrice,
      'image_url': imageUrl,
      'image_urls': imageUrls,
      'target_age_group': targetAgeGroup,
      'is_featured': isFeatured,
      'rating': rating,
      'review_count': reviewCount,
      'view_count': viewCount,
      'sales_count': salesCount,
      'tags': tags,
    };
  }

  // Helper getters
  bool get hasDiscount => salePrice != null && salePrice! < price;

  double get effectivePrice => salePrice ?? price;

  double? get discountPercentage {
    if (!hasDiscount) return null;
    return ((price - salePrice!) / price * 100);
  }
}
