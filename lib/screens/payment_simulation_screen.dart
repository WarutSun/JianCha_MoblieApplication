import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/car.dart';
import '../services/api_service.dart';

class PaymentSimulationScreen extends StatefulWidget {
  final Car car;
  final DateTime pickupDate;
  final DateTime returnDate;
  final int days;
  final String? promoCode;
  final String? dropoffLocation;
  final double dropoffFee;
  final double totalPrice;
  final double originalPrice;
  final double pricePerDay;
  final int? existingBookingId;

  const PaymentSimulationScreen({
    required this.car,
    required this.pickupDate,
    required this.returnDate,
    required this.days,
    this.promoCode,
    this.dropoffLocation,
    required this.dropoffFee,
    required this.totalPrice,
    required this.originalPrice,
    required this.pricePerDay,
    this.existingBookingId,
  });

  @override
  _PaymentSimulationScreenState createState() => _PaymentSimulationScreenState();
}

class _PaymentSimulationScreenState extends State<PaymentSimulationScreen> {
  final ApiService _api = ApiService();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isProcessing = false;
  bool _isSuccess = false;

  bool get _formValid =>
      _cardNumberController.text.isNotEmpty &&
      _cardHolderController.text.isNotEmpty &&
      _expiryController.text.isNotEmpty &&
      _cvvController.text.isNotEmpty;

  Future<void> _handlePayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() { _isProcessing = false; _isSuccess = true; });

    await Future.delayed(Duration(seconds: 2));

    try {
      if (widget.existingBookingId != null) {
        await _api.put('/bookings/${widget.existingBookingId}/pay');
      } else {
        final dateFormat = DateFormat('yyyy-MM-dd');
        final body = <String, dynamic>{
          'car_id': widget.car.id,
          'pickup_date': dateFormat.format(widget.pickupDate),
          'return_date': dateFormat.format(widget.returnDate),
        };
        if (widget.promoCode != null) body['promo_code'] = widget.promoCode;
        if (widget.dropoffLocation != null) body['dropoff_location'] = widget.dropoffLocation;

        final response = await _api.post('/bookings', body);
        if (response.statusCode != 201) {
          final data = jsonDecode(response.body);
          throw Exception(data['message'] ?? 'Failed to create booking');
        }

        // After creating booking, confirm payment (pending → confirmed)
        final createData = jsonDecode(response.body);
        if (createData['booking_id'] != null) {
          await _api.put('/bookings/${createData['booking_id']}/pay');
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Booking confirmed!')));
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: ${e.toString()}')));
        setState(() => _isSuccess = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final hasDiscount = widget.totalPrice < widget.originalPrice;
    final safeDropoffFee = widget.dropoffFee;
    final subtotal = widget.days * widget.pricePerDay;

    // Success screen (matching web)
    if (_isSuccess) {
      return Scaffold(
        body: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('✅', style: TextStyle(fontSize: 64)),
                  SizedBox(height: 16),
                  Text('Payment Successful!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Booking confirmed. Redirecting...', style: TextStyle(color: Color(0xFFA3A3A3))),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title (matching web)
              Text('Payment & Booking Confirmation',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 24),

              // Responsive: 2 columns on wide, 1 on narrow (matching web)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  final summaryCard = _buildSummaryCard(dateFormat, hasDiscount, safeDropoffFee, subtotal);
                  final paymentCard = _buildPaymentCard();

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: summaryCard),
                        SizedBox(width: 16),
                        Expanded(child: paymentCard),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      summaryCard,
                      SizedBox(height: 16),
                      paymentCard,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(DateFormat dateFormat, bool hasDiscount, double safeDropoffFee, double subtotal) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Vehicle', style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 13)),
            Text('${widget.car.brand} ${widget.car.model}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text('${widget.car.type.toUpperCase()} • ${widget.car.location}',
                style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 13)),
            Divider(height: 32),
            _summaryRow('Pickup Date', dateFormat.format(widget.pickupDate)),
            _summaryRow('Return Date', dateFormat.format(widget.returnDate)),
            _summaryRow('Duration', '${widget.days} day${widget.days != 1 ? 's' : ''}'),
            Divider(height: 32),
            _summaryRow('Price per day', '฿${widget.pricePerDay.round()}'),
            _summaryRow('Subtotal (${widget.days} days)', '฿${subtotal.round()}'),
            if (safeDropoffFee > 0)
              _summaryRow('Drop-off Fee', '+฿${safeDropoffFee.round()}', valueColor: Color(0xFFEA580C)),
            if (hasDiscount)
              _summaryRow('Discount (${widget.promoCode}) -30%',
                  '-฿${(widget.originalPrice - widget.totalPrice).round()}', valueColor: Color(0xFF22C55E)),
            Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('฿${widget.totalPrice.round()}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            if (hasDiscount)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('✅ Promo code applied!', style: TextStyle(color: Color(0xFF22C55E), fontSize: 12)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('💳 Payment Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Card Number', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            SizedBox(height: 4),
            TextField(
              controller: _cardNumberController,
              decoration: InputDecoration(hintText: '1234 5678 9012 3456'),
              keyboardType: TextInputType.number,
              enabled: !_isProcessing,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 12),
            Text('Card Holder Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            SizedBox(height: 4),
            TextField(
              controller: _cardHolderController,
              decoration: InputDecoration(hintText: 'John Doe'),
              enabled: !_isProcessing,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Expiry (MM/YY)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      SizedBox(height: 4),
                      TextField(
                        controller: _expiryController,
                        decoration: InputDecoration(hintText: '12/25'),
                        enabled: !_isProcessing,
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CVV', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      SizedBox(height: 4),
                      TextField(
                        controller: _cvvController,
                        decoration: InputDecoration(hintText: '123'),
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        enabled: !_isProcessing,
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _formValid && !_isProcessing ? _handlePayment : null,
                child: _isProcessing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 16, height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0A0A0A))),
                          SizedBox(width: 8),
                          Text('Processing...'),
                        ],
                      )
                    : Text('💳 Simulate Payment & Confirm Booking'),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),
            Text('🔒 This is a simulation. No real payment will be processed.',
                style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Color(0xFFA3A3A3))),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500, color: valueColor)),
        ],
      ),
    );
  }
}
