import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'payment_simulation_screen.dart';
import '../models/car.dart';

class MyBookingsScreen extends StatefulWidget {
  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final ApiService _api = ApiService();
  List<dynamic> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() => _isLoading = true);
    try {
      final response = await _api.get('/bookings');
      if (response.statusCode == 200) {
        setState(() => _bookings = jsonDecode(response.body));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load bookings')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _cancelBooking(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF161616),
        title: Text('Cancel Booking'),
        content: Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('No')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Cancel Booking', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final response = await _api.delete('/bookings/$id');
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking cancelled')));
          _fetchBookings();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error cancelling booking')));
      }
    }
  }

  Future<void> _payBooking(Map<String, dynamic> booking) async {
    final car = Car(
      id: booking['car_id'],
      brand: booking['brand'] ?? '',
      model: booking['model'] ?? '',
      type: booking['type'] ?? '',
      licensePlate: '',
      pricePerDay: 0,
      location: booking['location'] ?? '',
      isAvailable: false,
      discountPercent: 0,
      isPromotion: false,
    );

    final pickupDate = DateTime.parse(booking['pickup_date']);
    final returnDate = DateTime.parse(booking['return_date']);
    final days = returnDate.difference(pickupDate).inDays;
    final totalPrice = double.parse(booking['total_price'].toString());
    final dropoffFee = booking['dropoff_fee'] != null ? double.parse(booking['dropoff_fee'].toString()) : 0.0;
    final pricePerDay = days > 0 ? (totalPrice - dropoffFee) / days : 0.0;

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaymentSimulationScreen(
          car: car,
          pickupDate: pickupDate,
          returnDate: returnDate,
          days: days,
          promoCode: null,
          dropoffLocation: booking['dropoff_location'],
          dropoffFee: dropoffFee,
          totalPrice: totalPrice,
          originalPrice: totalPrice,
          pricePerDay: pricePerDay,
          existingBookingId: booking['id'],
        ),
      ),
    );
    if (result == true) _fetchBookings();
  }

  Future<void> _returnCar(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF161616),
        title: Text('Return Car'),
        content: Text('Are you sure you want to return this car? This will complete your booking.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('No')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Yes, Return')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final response = await _api.put('/bookings/$id/return');
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Car returned successfully')));
          _fetchBookings();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error returning car')));
      }
    }
  }

  Future<void> _leaveReview(Map<String, dynamic> booking) async {
    int rating = 5;
    final commentController = TextEditingController();

    final submitted = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: Color(0xFF161616),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Color(0xFF262626)),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Review ${booking['brand']} ${booking['model']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Text('Rating (1-5 stars)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                Row(
                  children: List.generate(5, (i) {
                    return GestureDetector(
                      onTap: () => setDialogState(() => rating = i + 1),
                      child: Text(
                        i < rating ? '★' : '★',
                        style: TextStyle(
                          fontSize: 28,
                          color: i < rating ? Color(0xFFEAB308) : Color(0xFF555555),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 16),
                Text('Comment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(hintText: 'How was the car and service?'),
                  maxLines: 4,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text('Submit Review'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (submitted == true) {
      try {
        final response = await _api.post('/reviews', {
          'booking_id': booking['id'],
          'car_id': booking['car_id'],
          'rating': rating,
          'comment': commentController.text,
        });
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Review submitted!')));
          _fetchBookings();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting review')));
      }
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed': return Color(0xFF3B82F6);
      case 'completed': return Color(0xFFA855F7);
      case 'cancelled': return Color(0xFFEF4444);
      default: return Color(0xFFEAB308);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Bookings', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('View and manage your car rental reservations',
                      style: TextStyle(color: Color(0xFFA3A3A3))),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(strokeWidth: 2))
                  : _bookings.isEmpty
                      ? Center(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: Text("You haven't made any bookings yet",
                                  style: TextStyle(color: Color(0xFFA3A3A3))),
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchBookings,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _bookings.length,
                            itemBuilder: (context, index) => _buildBookingRow(_bookings[index]),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingRow(Map<String, dynamic> b) {
    final status = b['status'] ?? 'pending';
    final hasReview = b['has_review'] == 1;
    final totalPrice = double.parse(b['total_price'].toString());
    final pickup = b['pickup_date']?.toString().split('T')[0] ?? '';
    final ret = b['return_date']?.toString().split('T')[0] ?? '';
    final pickupLoc = b['pickup_location'] ?? b['location'] ?? '';
    final dropoffLoc = b['dropoff_location'] ?? b['location'] ?? '';

    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Color(0xFF262626), width: 1),
      ),
      color: Color(0xFF121212),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Car Title & Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Color(0xFF262626),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text('🚗', style: TextStyle(fontSize: 24)),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      '${b['brand']} ${b['model']}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _statusColor(status).withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(color: _statusColor(status), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Body: Info Grid using Wrap
            Wrap(
              spacing: 32,
              runSpacing: 20,
              children: [
                // Location Info
                _buildInfoSection(
                  icon: Icons.location_on_outlined,
                  title: 'Location',
                  children: [
                    _buildInfoRow('Pick-up', pickupLoc),
                    SizedBox(height: 8),
                    _buildInfoRow('Drop-off', dropoffLoc),
                  ],
                ),
                // Date Info
                _buildInfoSection(
                  icon: Icons.calendar_today_outlined,
                  title: 'Rental Period',
                  children: [
                    _buildInfoRow('From', pickup),
                    SizedBox(height: 8),
                    _buildInfoRow('To', ret),
                  ],
                ),
                // Price Info
                _buildInfoSection(
                  icon: Icons.payments_outlined,
                  title: 'Total Price',
                  children: [
                    Text(
                      '฿${totalPrice.round()}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 24),
            Divider(color: Color(0xFF262626), height: 1),
            SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (status == 'pending' || status == 'confirmed')
                  Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: TextButton(
                      onPressed: () => _cancelBooking(b['id']),
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFFEF4444),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                if (status == 'completed' && !hasReview)
                  _actionButton('⭐ Leave Review', Color(0xFFEAB308), () => _leaveReview(b)),
                if (status == 'completed' && hasReview)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Reviewed ✓', style: TextStyle(color: Color(0xFFA3A3A3), fontWeight: FontWeight.w600)),
                  ),
                if (status == 'pending')
                  _actionButton('💳 Pay Now', Color(0xFF16A34A), () => _payBooking(b)),
                if (status == 'confirmed')
                  _actionButton('🚗 Return Car', Color(0xFF2563EB), () => _returnCar(b['id'])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({required IconData icon, required String title, required List<Widget> children}) {
    return Container(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Color(0xFFA3A3A3)),
              SizedBox(width: 8),
              Text(title, style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
            ],
          ),
          SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 65,
          child: Text(label, style: TextStyle(color: Color(0xFF737373), fontSize: 13)),
        ),
        Expanded(
          child: Text(value, style: TextStyle(color: Color(0xFFE5E5E5), fontSize: 13, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  Widget _actionButton(String text, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }
}
