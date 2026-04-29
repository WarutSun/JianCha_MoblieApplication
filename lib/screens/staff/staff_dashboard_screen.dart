import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'staff_reports_screen.dart';

class StaffDashboardScreen extends StatefulWidget {
  @override
  _StaffDashboardScreenState createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  final ApiService _api = ApiService();
  Map<String, dynamic> _stats = {'totalBookings': 0, 'totalRevenue': 0, 'availableCars': 0};
  bool _isLoading = true;
  bool _isResetting = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    setState(() => _isLoading = true);
    try {
      final response = await _api.get('/staff/dashboard');
      if (response.statusCode == 200) {
        setState(() { _stats = jsonDecode(response.body); _error = ''; });
      } else {
        setState(() => _error = 'Failed to load dashboard');
      }
    } catch (e) {
      setState(() => _error = 'Failed to connect to server');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resetDatabase() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF161616),
        title: Text('Are you sure?'),
        content: Text('This will delete all bookings and reset car availability. This action cannot be undone.'),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEF4444)),
            child: Text('Yes, Reset Database', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isResetting = true);
      try {
        await _api.delete('/staff/reset');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Database reset successfully!')));
        _fetchDashboard();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to reset database')));
      } finally {
        setState(() => _isResetting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator(strokeWidth: 2))
            : RefreshIndicator(
                onRefresh: _fetchDashboard,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Staff Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),

                      if (_error.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Text(_error, style: TextStyle(color: Color(0xFFEF4444))),
                        ),

                      // Stats Cards (matching web's 3 cards)
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Bookings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text('${_stats['totalBookings']}',
                                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Revenue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text('฿${_stats['totalRevenue']}',
                                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Available Cars', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text('${_stats['availableCars']}',
                                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 32),

                      // Quick Actions (matching web)
                      Text('Quick Actions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                      SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => StaffReportsScreen()),
                          ),
                          child: Text('📊 View Reports'),
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _isResetting ? null : _resetDatabase,
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEF4444)),
                          child: Text(
                            _isResetting ? '🔄 Resetting...' : '🔄 Reset Database',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
