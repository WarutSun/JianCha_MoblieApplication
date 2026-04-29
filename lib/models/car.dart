class Car {
  final int id;
  final String brand;
  final String model;
  final String type;
  final String licensePlate;
  final double pricePerDay;
  final String location;
  final bool isAvailable;
  final int discountPercent;
  final bool isPromotion;
  final double avgRating;
  final int reviewCount;
  final double discountedPrice;

  Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.type,
    required this.licensePlate,
    required this.pricePerDay,
    required this.location,
    required this.isAvailable,
    required this.discountPercent,
    required this.isPromotion,
    this.avgRating = 0,
    this.reviewCount = 0,
    this.discountedPrice = 0,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    final price = double.parse((json['price_per_day'] ?? 0).toString());
    final discPercent = json['discount_percent'] ?? 0;
    final isPromo = json['is_promotion'] == 1 || json['is_promotion'] == true;
    final discounted = json['discounted_price'] != null
        ? double.parse(json['discounted_price'].toString())
        : (isPromo ? price * (1 - discPercent / 100) : price);

    return Car(
      id: json['id'],
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      type: json['type'] ?? '',
      licensePlate: json['license_plate'] ?? '',
      pricePerDay: price,
      location: json['location'] ?? '',
      isAvailable: json['is_available'] == 1 || json['is_available'] == true,
      discountPercent: discPercent,
      isPromotion: isPromo,
      avgRating: json['avg_rating'] != null ? double.parse(json['avg_rating'].toString()) : 0,
      reviewCount: json['review_count'] ?? 0,
      discountedPrice: discounted,
    );
  }
}
