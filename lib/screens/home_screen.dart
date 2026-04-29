import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onNavigateToCars;

  const HomeScreen({this.onNavigateToCars});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0A0A0A), Color(0xFF262626)],
                  ),
                ),
                child: Column(
                  children: [
                    Text('Welcome to Travel Naja',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    SizedBox(height: 12),
                    Text('Your all-in-one travel companion for flights, cars, and accommodations',
                        style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 16),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),

              // Service Cards
              Padding(
                padding: EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    final cards = [
                      _buildServiceCard('✈️', 'Flights', 'Book flights to your destination', false, null),
                      _buildServiceCard('🚗', 'Car Rental', 'Reserve a car for your trip', true, onNavigateToCars),
                      _buildServiceCard('🏨', 'Hotels', 'Find and book accommodation', false, null),
                    ];

                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: cards.map((c) => Expanded(child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: c,
                        ))).toList(),
                      );
                    }
                    return Column(children: cards);
                  },
                ),
              ),

              SizedBox(height: 24),

              // Why Choose Travel Naja?
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('Why Choose Travel Naja?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              SizedBox(height: 24),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    final features = [
                      _buildFeature('⚡', 'Fast Booking', 'Quick and easy reservation process'),
                      _buildFeature('🛡️', 'Secure', 'Your data is protected with encryption'),
                      _buildFeature('💰', 'Best Prices', 'Competitive rates on all services'),
                    ];

                    if (isWide) {
                      return Row(
                        children: features.map((f) => Expanded(child: f)).toList(),
                      );
                    }
                    return Column(children: features);
                  },
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(String icon, String title, String description, bool enabled, VoidCallback? onTap) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.6,
      child: Card(
        margin: EdgeInsets.only(bottom: 12),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(icon, style: TextStyle(fontSize: 40)),
                      if (!enabled)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFF262626),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('Coming Soon',
                              style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 12)),
                        ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(description, style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 14)),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: enabled
                        ? ElevatedButton(
                            onPressed: onTap,
                            child: Text('Explore $title'),
                          )
                        : ElevatedButton(
                            onPressed: null,
                            child: Text('Coming Soon'),
                          ),
                  ),
                ],
              ),
            ),
            if (!enabled)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Text(icon, style: TextStyle(fontSize: 36)),
          SizedBox(height: 12),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text(description,
              style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 14),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
