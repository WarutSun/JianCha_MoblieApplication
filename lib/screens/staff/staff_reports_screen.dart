import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class StaffReportsScreen extends StatefulWidget {
  @override
  _StaffReportsScreenState createState() => _StaffReportsScreenState();
}

class _StaffReportsScreenState extends State<StaffReportsScreen> {
  final ApiService _api = ApiService();
  List<dynamic> _rows = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() => _isLoading = true);
    try {
      final response = await _api.get('/staff/reports/reservations');
      if (response.statusCode == 200) {
        setState(() { _rows = jsonDecode(response.body); _error = ''; });
      } else {
        setState(() => _error = 'Failed to load reports');
      }
    } catch (e) {
      setState(() => _error = 'Failed to connect to server');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  double get _totalRevenue => _rows.fold(0.0, (sum, r) => sum + double.parse(r['total_price'].toString()));
  int _countByStatus(String status) => _rows.where((r) => r['status'] == status).length;

  Future<void> _returnCar(int bookingId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF161616),
        title: Text('Return Car'),
        content: Text('Mark this car as returned and complete the booking?'),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Yes, Return')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final response = await _api.put('/staff/return/$bookingId');
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Car returned successfully')));
          _fetchReports();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error returning car')));
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
        child: _isLoading
            ? Center(child: CircularProgressIndicator(strokeWidth: 2))
            : RefreshIndicator(
                onRefresh: _fetchReports,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with back button
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text('Reservation Reports',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 16),

                      if (_error.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Text(_error, style: TextStyle(color: Color(0xFFEF4444))),
                        ),

                      // Stats Summary (matching web's grid)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF262626),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Wrap(
                          spacing: 24,
                          runSpacing: 16,
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            _miniStat('${_rows.length}', 'Total', Colors.white),
                            _miniStat('฿${_totalRevenue.round()}', 'Revenue', Color(0xFF22C55E)),
                            _miniStat('${_countByStatus('confirmed')}', 'Confirmed', Color(0xFF3B82F6)),
                            _miniStat('${_countByStatus('pending')}', 'Pending', Color(0xFFEAB308)),
                            _miniStat('${_countByStatus('cancelled')}', 'Cancelled', Color(0xFFEF4444)),
                            _miniStat('${_countByStatus('completed')}', 'Completed', Color(0xFFA855F7)),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      // Reservation rows (matching web's table)
                      Card(
                        child: Column(
                          children: _rows.asMap().entries.map((entry) {
                            final i = entry.key;
                            final r = entry.value;
                            return _buildReportRow(i, r);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _miniStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 12, color: Color(0xFFA3A3A3))),
      ],
    );
  }

  Widget _buildReportRow(int index, Map<String, dynamic> r) {
    final status = r['status'] ?? 'pending';
    final totalPrice = double.parse(r['total_price'].toString());

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF262626))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row number + car + status
          Row(
            children: [
              Text('#${index + 1}  ', style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 13)),
              Expanded(
                child: Text('${r['brand']} ${r['model']}',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor(status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(status,
                    style: TextStyle(color: _statusColor(status), fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          SizedBox(height: 6),

          // User info
          Text('${r['user_name']} • ${r['user_email']}',
              style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 12)),
          SizedBox(height: 4),

          // Dates
          Text('${r['pickup_date']?.toString().split('T')[0]} → ${r['return_date']?.toString().split('T')[0]}',
              style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 12)),
          SizedBox(height: 4),

          // Price + action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('฿${totalPrice.round()}', style: TextStyle(fontWeight: FontWeight.w600)),
              if (status == 'confirmed')
                GestureDetector(
                  onTap: () => _returnCar(r['id']),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF16A34A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('Return Car',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
