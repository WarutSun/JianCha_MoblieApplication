import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/car.dart';
import 'payment_simulation_screen.dart';

class BookingFormScreen extends StatefulWidget {
  final Car car;

  const BookingFormScreen({required this.car});

  @override
  _BookingFormScreenState createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  DateTime? _pickupDate;
  DateTime? _returnDate;
  String _promoCode = '';
  String _promoMessage = '';
  String? _dropoffLocation;

  final List<String> _validPromoCodes = ['ONLYTRAVELNAJA', 'GUBONUS', 'MEGA'];
  final int _discountPercent = 30;

  final Map<String, Map<String, int>> _fees = {
    'bangkok': {'pattaya': 400, 'hua hin': 500, 'chiang mai': 1500, 'phuket': 2500},
    'chiang mai': {'bangkok': 1500, 'pattaya': 1800, 'hua hin': 2000, 'phuket': 3500},
    'phuket': {'bangkok': 2500, 'hua hin': 2200, 'pattaya': 2800, 'chiang mai': 3500},
    'pattaya': {'bangkok': 400, 'hua hin': 800, 'chiang mai': 1800, 'phuket': 2800},
    'hua hin': {'bangkok': 500, 'pattaya': 800, 'chiang mai': 2000, 'phuket': 2200},
  };

  final List<String> _allLocations = ['Bangkok', 'Chiang Mai', 'Phuket', 'Pattaya', 'Hua Hin'];

  int get _days {
    if (_pickupDate == null || _returnDate == null) return 0;
    return _returnDate!.difference(_pickupDate!).inDays;
  }

  int _getDropoffFee() {
    if (_dropoffLocation == null || _dropoffLocation!.toLowerCase() == widget.car.location.toLowerCase()) return 0;
    final p = widget.car.location.toLowerCase();
    final d = _dropoffLocation!.toLowerCase();
    return _fees[p]?[d] ?? 300;
  }

  double get _pricePerDay {
    if (widget.car.isPromotion && widget.car.discountPercent > 0) {
      return (widget.car.pricePerDay * (1 - widget.car.discountPercent / 100));
    }
    return widget.car.pricePerDay;
  }

  double get _subtotal => _days > 0 ? _days * _pricePerDay : 0;
  double get _totalBeforePromo => _subtotal + _getDropoffFee();

  double get _totalPrice {
    double total = _totalBeforePromo;
    if (_validPromoCodes.contains(_promoCode.toUpperCase())) {
      total = (_subtotal * (1 - _discountPercent / 100)) + _getDropoffFee();
    }
    return total;
  }

  bool get _hasPromoDiscount => _validPromoCodes.contains(_promoCode.toUpperCase());

  void _validatePromo(String code) {
    setState(() {
      _promoCode = code;
      if (code.isEmpty) {
        _promoMessage = '';
      } else if (_validPromoCodes.contains(code.toUpperCase())) {
        _promoMessage = '✅ Promo applied! 30% discount';
      } else {
        _promoMessage = '❌ Invalid promo code';
      }
    });
  }

  Future<void> _selectDate(BuildContext context, bool isPickup) async {
    final initialDate = isPickup ? DateTime.now() : (_pickupDate ?? DateTime.now()).add(Duration(days: 1));
    final firstDate = isPickup ? DateTime.now() : (_pickupDate ?? DateTime.now()).add(Duration(days: 1));
    final lastDate = DateTime.now().add(Duration(days: 365));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFFFAFAFA),
              onPrimary: Color(0xFF0A0A0A),
              surface: Color(0xFF161616),
              onSurface: Color(0xFFFAFAFA),
            ),
            dialogBackgroundColor: Color(0xFF161616),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isPickup) {
          _pickupDate = picked;
          if (_returnDate != null && _returnDate!.isBefore(picked.add(Duration(days: 1)))) {
            _returnDate = null;
          }
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  void _handleBook() {
    if (_days <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select valid dates')));
      return;
    }
    if (_days > 30) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rental period cannot exceed 30 days')));
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaymentSimulationScreen(
          car: widget.car,
          pickupDate: _pickupDate!,
          returnDate: _returnDate!,
          days: _days,
          promoCode: _hasPromoDiscount ? _promoCode : null,
          dropoffLocation: _dropoffLocation,
          dropoffFee: _getDropoffFee().toDouble(),
          totalPrice: _totalPrice,
          originalPrice: _totalBeforePromo,
          pricePerDay: _pricePerDay,
        ),
      ),
    ).then((result) {
      if (result == true) {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    final hasCarPromo = car.isPromotion && car.discountPercent > 0;
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back + Title
              Row(
                children: [
                  IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                  Text('Book ${car.brand} ${car.model}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 16),

              // Car Info Card (matching web car card top area)
              Card(
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFF262626),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      child: Center(child: Text('🚗', style: TextStyle(fontSize: 48))),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${car.brand} ${car.model}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('${car.type.toUpperCase()} • ${car.location}',
                              style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 14)),
                          SizedBox(height: 4),
                          if (hasCarPromo)
                            Row(
                              children: [
                                Text('฿${car.pricePerDay.round()}',
                                    style: TextStyle(decoration: TextDecoration.lineThrough, color: Color(0xFFA3A3A3))),
                                SizedBox(width: 8),
                                Text('฿${_pricePerDay.round()}/day',
                                    style: TextStyle(color: Color(0xFF22C55E), fontWeight: FontWeight.bold)),
                              ],
                            )
                          else
                            Text('฿${car.pricePerDay.round()}/day',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Pickup Date (matching web's popover button style)
              Text('Pickup Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context, true),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF262626)),
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFF0A0A0A),
                  ),
                  child: Text(
                    _pickupDate != null ? dateFormat.format(_pickupDate!) : 'Pickup date',
                    style: TextStyle(color: _pickupDate != null ? Color(0xFFFAFAFA) : Color(0xFFA3A3A3)),
                  ),
                ),
              ),

              SizedBox(height: 12),

              // Return Date
              Text('Return Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context, false),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF262626)),
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFF0A0A0A),
                  ),
                  child: Text(
                    _returnDate != null ? dateFormat.format(_returnDate!) : 'Return date',
                    style: TextStyle(color: _returnDate != null ? Color(0xFFFAFAFA) : Color(0xFFA3A3A3)),
                  ),
                ),
              ),

              // Duration display (matching web's bg-muted area)
              if (_days > 0) ...[
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF262626),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('$_days day${_days != 1 ? 's' : ''}', style: TextStyle(fontWeight: FontWeight.w600)),
                      if (_days > 30)
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFFEF4444).withValues(alpha: 0.1),
                            border: Border.all(color: Color(0xFFEF4444)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('⚠️ Rental period cannot exceed 30 days',
                              style: TextStyle(color: Color(0xFFEF4444), fontSize: 12)),
                        ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 16),

              // Promo Code (matching web's input)
              Text('Promo Code', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(hintText: 'Enter promo code'),
                textCapitalization: TextCapitalization.characters,
                onChanged: _validatePromo,
              ),
              if (_promoMessage.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(_promoMessage,
                      style: TextStyle(
                        color: _promoMessage.contains('✅') ? Color(0xFF22C55E) : Color(0xFFEF4444),
                        fontSize: 12,
                      )),
                ),

              SizedBox(height: 16),

              // Drop-off Location (matching web's select dropdown)
              Text('Drop-off Location', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF262626)),
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFF0A0A0A),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _dropoffLocation ?? car.location,
                    isExpanded: true,
                    dropdownColor: Color(0xFF161616),
                    items: _allLocations.map((loc) {
                      final isSame = loc.toLowerCase() == car.location.toLowerCase();
                      return DropdownMenuItem(
                        value: loc,
                        child: Text(isSame ? '$loc (Same as pick-up)' : loc),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _dropoffLocation = val),
                  ),
                ),
              ),
              if (_getDropoffFee() > 0)
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text('+฿${_getDropoffFee()} drop-off fee will be applied',
                      style: TextStyle(color: Color(0xFFEA580C), fontSize: 12, fontWeight: FontWeight.w500)),
                ),

              SizedBox(height: 20),

              // Price Summary (matching web's bg-muted price area)
              if (_days > 0) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF262626),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _priceLine('Price per day', '฿${_pricePerDay.round()}'),
                      _priceLine('Subtotal ($_days days)', '฿${_subtotal.round()}'),
                      if (_getDropoffFee() > 0)
                        _priceLine('Drop-off fee', '+฿${_getDropoffFee()}', color: Color(0xFFEA580C)),
                      if (_hasPromoDiscount)
                        _priceLine('Promo discount (-30%)',
                            '-฿${(_subtotal * _discountPercent / 100).round()}',
                            color: Color(0xFF22C55E)),
                      Divider(color: Color(0xFF3A3A3A)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('฿${_totalPrice.round()}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],

              // Action Buttons (matching web's Book + Cancel)
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: _days > 0 && _days <= 30 ? _handleBook : null,
                  child: Text(
                    _days > 30 ? 'Exceeds 30 day limit' : 'Proceed to Payment',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceLine(String label, String value, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Color(0xFFA3A3A3))),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500, color: color)),
        ],
      ),
    );
  }
}
