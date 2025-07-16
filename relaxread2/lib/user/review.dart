class Review {
  final String reviewId;
  final String ebookId;
  final String reviewerName;
  final String reviewText;
  final double rating; // 1.0 to 5.0
  final DateTime reviewDate;

  Review({
    required this.reviewId,
    required this.ebookId,
    required this.reviewerName,
    required this.reviewText,
    required this.rating,
    required this.reviewDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'ebookId': ebookId,
      'reviewerName': reviewerName,
      'reviewText': reviewText,
      'rating': rating,
      'reviewDate': reviewDate.toIso8601String(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      reviewId: map['reviewId'] as String,
      ebookId: map['ebookId'] as String,
      reviewerName: map['reviewerName'] as String,
      reviewText: map['reviewText'] as String,
      rating: (map['rating'] as num).toDouble(),
      reviewDate: DateTime.parse(map['reviewDate'] as String),
    );
  }
}
