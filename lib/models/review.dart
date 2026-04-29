class Review {
  final int id;
  final int carId;
  final String userName;
  final int rating;
  final String comment;
  final String createdAt;

  Review({
    required this.id,
    required this.carId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      carId: json['car_id'] ?? 0,
      userName: json['user_name'] ?? 'Unknown',
      rating: json['rating'] ?? 5,
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
