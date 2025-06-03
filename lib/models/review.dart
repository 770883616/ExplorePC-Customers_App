class Review {
  final int reviewId;
  final int productId;
  final int userId;
  final double rating;
  final String comment;
  final String userName;
  final String? userImage;
  final DateTime date;

  Review({
    required this.reviewId,
    required this.productId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.userName,
    this.userImage,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['reviewId'],
      productId: json['productId'],
      userId: json['UserId'],
      rating: double.parse(json['rating'].toString()),
      comment: json['comment'] ?? '',
      userName: json['user']['UserName'] ?? 'مستخدم',
      userImage: json['user']['Image'],
      date: DateTime.parse(json['date']),
    );
  }
}
