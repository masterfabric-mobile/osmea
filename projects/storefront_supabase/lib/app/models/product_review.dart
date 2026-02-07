class ProductReview {
  final String id;
  final int rating;
  final String? title;
  final String? comment;
  final DateTime createdAt;
  final String authorName;
  final int? deliveryRating;
  final String? deliveryComment;

  ProductReview({
    required this.id,
    required this.rating,
    this.title,
    this.comment,
    required this.createdAt,
    required this.authorName,
    this.deliveryRating,
    this.deliveryComment,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    // Handle nested user data if available
    String author = 'Anonymous';
    if (json['users'] != null && json['users']['full_name'] != null) {
      author = json['users']['full_name'] as String;
    }

    return ProductReview(
      id: json['id'] as String,
      rating: json['rating'] as int,
      title: json['title'] as String?,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      authorName: author,
      deliveryRating: json['delivery_rating'] as int?,
      deliveryComment: json['delivery_comment'] as String?,
    );
  }
}
