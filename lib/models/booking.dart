class Booking {
  final int id;
  final int carId;
  final String carBrand;
  final String carModel;
  final String pickupDate;
  final String returnDate;
  final double totalPrice;
  final String status;
  final String pickupLocation;
  final String dropoffLocation;
  final double dropoffFee;

  Booking({
    required this.id,
    required this.carId,
    required this.carBrand,
    required this.carModel,
    required this.pickupDate,
    required this.returnDate,
    required this.totalPrice,
    required this.status,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.dropoffFee,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      carId: json['car_id'] ?? 0,
      carBrand: json['car_brand'] ?? '',
      carModel: json['car_model'] ?? '',
      pickupDate: json['pickup_date'] ?? '',
      returnDate: json['return_date'] ?? '',
      totalPrice: double.parse((json['total_price'] ?? 0).toString()),
      status: json['status'] ?? 'pending',
      pickupLocation: json['pickup_location'] ?? '',
      dropoffLocation: json['dropoff_location'] ?? '',
      dropoffFee: json['dropoff_fee'] != null ? double.parse(json['dropoff_fee'].toString()) : 0.0,
    );
  }
}
