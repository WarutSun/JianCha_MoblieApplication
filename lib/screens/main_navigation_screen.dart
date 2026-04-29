import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../widgets/app_logo.dart';
import 'home_screen.dart';
import 'cars_screen.dart';
import 'my_bookings_screen.dart';
import 'profile_screen.dart';
import 'staff/staff_dashboard_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  int _pendingCount = 0;
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchPendingCount();
  }

  Future<void> _fetchPendingCount() async {
    try {
      final response = await _api.get('/bookings');
      if (response.statusCode == 200) {
        final List<dynamic> bookings = jsonDecode(response.body);
        final count = bookings.where((b) =>
            b['status'] == 'pending' || b['status'] == 'confirmed').length;
        if (mounted) setState(() => _pendingCount = count);
      }
    } catch (e) {
      // ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isStaff = auth.role == 'staff';

    // Index mapping: 0=Home, 1=Cars, 2=Bookings, 3=Staff(optional), 4=Profile
    final List<Widget> screens = [
      HomeScreen(onNavigateToCars: () => setState(() => _currentIndex = 1)),
      CarsScreen(),
      MyBookingsScreen(),
      if (isStaff) StaffDashboardScreen(),
      ProfileScreen(),
    ];

    final bookingsIndex = 2;

    final List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Cars'),
      BottomNavigationBarItem(
        icon: _pendingCount > 0
            ? Badge(
                label: Text('$_pendingCount', style: TextStyle(fontSize: 10)),
                child: Icon(Icons.book),
              )
            : Icon(Icons.book),
        label: 'My Bookings',
      ),
      if (isStaff) BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Staff'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AppLogo(size: 32),
            SizedBox(width: 12),
            Text('Travel Naja', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        backgroundColor: Color(0xFF161616),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _fetchPendingCount();
        },
        items: items,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
