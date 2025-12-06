class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final images = json['product_images'] as List<dynamic>?;
    String imageUrl = 'https://placehold.co/600x400'; // Default placeholder
    if (images != null && images.isNotEmpty) {
      // Find primary image or take the first one
      final primaryImage = images.firstWhere(
        (img) => img['is_primary'] == true,
        orElse: () => images.first,
      );
      if (primaryImage != null && primaryImage['image_url'] != null) {
        imageUrl = primaryImage['image_url'] as String;
      }
    }

    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
    };
  }
}
