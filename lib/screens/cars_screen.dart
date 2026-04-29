import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/car.dart';
import '../services/api_service.dart';
import 'booking_form_screen.dart';

class CarsScreen extends StatefulWidget {
  @override
  _CarsScreenState createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  final ApiService _api = ApiService();
  List<Car> _cars = [];
  bool _isLoading = true;

  String _searchText = '';
  String _filterType = 'all';
  String _filterLocation = 'all';
  bool _filterPromotion = false;
  String _sortBy = 'default';

  @override
  void initState() {
    super.initState();
    _fetchCars();
  }

  Future<void> _fetchCars() async {
    setState(() => _isLoading = true);
    try {
      final response = await _api.get('/cars');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() => _cars = data.map((json) => Car.fromJson(json)).toList());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load cars')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Car> get _filteredCars {
    List<Car> result = _cars.where((car) {
      final matchesSearch = car.brand.toLowerCase().contains(_searchText.toLowerCase()) ||
          car.model.toLowerCase().contains(_searchText.toLowerCase());
      final matchesType = _filterType == 'all' || car.type == _filterType;
      final matchesLocation = _filterLocation == 'all' || car.location == _filterLocation;
      final matchesPromotion = !_filterPromotion || car.isPromotion;
      return matchesSearch && matchesType && matchesLocation && matchesPromotion;
    }).toList();

    if (_sortBy == 'low-to-high') {
      result.sort((a, b) => a.pricePerDay.compareTo(b.pricePerDay));
    } else if (_sortBy == 'high-to-low') {
      result.sort((a, b) => b.pricePerDay.compareTo(a.pricePerDay));
    }
    return result;
  }

  Set<String> get _locations => _cars.map((c) => c.location).toSet();

  // Reviews modal
  Future<void> _viewReviews(int carId) async {
    showDialog(
      context: context,
      builder: (ctx) => _ReviewsDialog(api: _api, carId: carId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCars;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Available Cars', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Select a car and choose your rental dates',
                      style: TextStyle(color: Color(0xFFA3A3A3))),
                ],
              ),
            ),
            SizedBox(height: 12),

            // Filter Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Search
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by brand or model...',
                          prefixIcon: Icon(Icons.search, color: Color(0xFFA3A3A3)),
                        ),
                        onChanged: (val) => setState(() => _searchText = val),
                      ),
                      SizedBox(height: 12),

                      // Type filter chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...['all', 'sedan', 'suv', 'van'].map((type) {
                              final isSelected = _filterType == type;
                              return Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: () => setState(() => _filterType = type),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Color(0xFFFAFAFA) : Colors.transparent,
                                      border: Border.all(color: isSelected ? Color(0xFFFAFAFA) : Color(0xFF262626)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      type == 'all' ? 'All' : type.toUpperCase(),
                                      style: TextStyle(
                                        color: isSelected ? Color(0xFF0A0A0A) : Color(0xFFFAFAFA),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                            // Promotion filter
                            GestureDetector(
                              onTap: () => setState(() => _filterPromotion = !_filterPromotion),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _filterPromotion ? Color(0xFFFAFAFA) : Colors.transparent,
                                  border: Border.all(color: _filterPromotion ? Color(0xFFFAFAFA) : Color(0xFF262626)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '🏷️ Promotion',
                                  style: TextStyle(
                                    color: _filterPromotion ? Color(0xFF0A0A0A) : Color(0xFFFAFAFA),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),

                      // Location and Sort
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Location', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFF262626)),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0xFF0A0A0A),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _filterLocation,
                                      isExpanded: true,
                                      dropdownColor: Color(0xFF161616),
                                      items: [
                                        DropdownMenuItem(value: 'all', child: Text('All Locations')),
                                        ..._locations.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))),
                                      ],
                                      onChanged: (val) => setState(() => _filterLocation = val ?? 'all'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sort by Price', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFF262626)),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0xFF0A0A0A),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _sortBy,
                                      isExpanded: true,
                                      dropdownColor: Color(0xFF161616),
                                      items: [
                                        DropdownMenuItem(value: 'default', child: Text('Default')),
                                        DropdownMenuItem(value: 'low-to-high', child: Text('Low to High')),
                                        DropdownMenuItem(value: 'high-to-low', child: Text('High to Low')),
                                      ],
                                      onChanged: (val) => setState(() => _sortBy = val ?? 'default'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('Showing ${filtered.length} car${filtered.length != 1 ? 's' : ''}',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),

            // Car grid
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(strokeWidth: 2))
                  : filtered.isEmpty
                      ? Center(child: Text('No cars found matching your criteria',
                          style: TextStyle(color: Color(0xFFA3A3A3))))
                      : RefreshIndicator(
                          onRefresh: _fetchCars,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final width = constraints.maxWidth;
                              final cols = width > 900 ? 4 : width > 600 ? 3 : 2;
                              final rows = <List<Car>>[];
                              for (var i = 0; i < filtered.length; i += cols) {
                                rows.add(filtered.sublist(i, i + cols > filtered.length ? filtered.length : i + cols));
                              }
                              return ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                itemCount: rows.length,
                                itemBuilder: (context, index) {
                                  final row = rows[index];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          for (var i = 0; i < row.length; i++) ...[
                                            if (i > 0) SizedBox(width: 10),
                                            Expanded(child: _buildCarCard(row[i])),
                                          ],
                                          // Fill remaining space if row is incomplete
                                          for (var i = row.length; i < cols; i++) ...[
                                            SizedBox(width: 10),
                                            Expanded(child: SizedBox()),
                                          ],
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarCard(Car car) {
    final hasPromo = car.isPromotion && car.discountPercent > 0;
    final discountedPrice = hasPromo
        ? (car.pricePerDay * (1 - car.discountPercent / 100)).round()
        : car.pricePerDay.round();

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: hasPromo ? Color(0xFF22C55E) : Color(0xFF262626),
          width: hasPromo ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car image placeholder
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF262626),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Stack(
              children: [
                Center(child: Text('🚗', style: TextStyle(fontSize: 32))),
                if (hasPromo)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('🏷️ SALE',
                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text('${car.brand} ${car.model}',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      maxLines: 1, overflow: TextOverflow.ellipsis),

                  if (car.reviewCount > 0)
                    Text('⭐ ${car.avgRating} (${car.reviewCount})',
                        style: TextStyle(color: Color(0xFFCA8A04), fontSize: 11)),

                  SizedBox(height: 4),
                  Text('${car.type} • ${car.location}',
                      style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 11),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4),

                  // Price
                  if (hasPromo)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('฿${car.pricePerDay.round()}',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Color(0xFFA3A3A3),
                                fontSize: 11)),
                        Text('฿$discountedPrice/day',
                            style: TextStyle(color: Color(0xFF22C55E), fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    )
                  else
                    Text('฿${car.pricePerDay.round()}/day',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),

                  SizedBox(height: 8),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => BookingFormScreen(car: car)),
                        );
                        if (result == true) _fetchCars();
                      },
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, textStyle: TextStyle(fontSize: 12)),
                      child: Text('Book Now'),
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: OutlinedButton(
                      onPressed: () => _viewReviews(car.id),
                      style: OutlinedButton.styleFrom(padding: EdgeInsets.zero, textStyle: TextStyle(fontSize: 12)),
                      child: Text('Reviews'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Reviews dialog matching the web modal
class _ReviewsDialog extends StatefulWidget {
  final ApiService api;
  final int carId;
  const _ReviewsDialog({required this.api, required this.carId});

  @override
  _ReviewsDialogState createState() => _ReviewsDialogState();
}

class _ReviewsDialogState extends State<_ReviewsDialog> {
  List<dynamic> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    try {
      final response = await widget.api.get('/reviews/car/${widget.carId}');
      if (response.statusCode == 200) {
        setState(() => _reviews = jsonDecode(response.body));
      }
    } catch (e) {
      // ignore
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF161616),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Color(0xFF262626)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Customer Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text('✕', style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 18)),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Flexible(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator(strokeWidth: 2))
                    : _reviews.isEmpty
                        ? Center(child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text('No reviews for this car yet.',
                                style: TextStyle(color: Color(0xFFA3A3A3))),
                          ))
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: _reviews.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final r = _reviews[index];
                              return Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Color(0xFF262626),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Color(0xFF262626)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(r['user_name'] ?? '',
                                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                        Text('⭐' * (r['rating'] ?? 0),
                                            style: TextStyle(color: Color(0xFFEAB308), fontSize: 14)),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(r['comment'] ?? 'No comment provided',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontStyle: (r['comment'] == null || r['comment'].isEmpty)
                                              ? FontStyle.italic
                                              : FontStyle.normal,
                                          color: (r['comment'] == null || r['comment'].isEmpty)
                                              ? Color(0xFFA3A3A3)
                                              : null,
                                        )),
                                    SizedBox(height: 8),
                                    Text(r['created_at']?.toString().split('T')[0] ?? '',
                                        style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 12)),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
