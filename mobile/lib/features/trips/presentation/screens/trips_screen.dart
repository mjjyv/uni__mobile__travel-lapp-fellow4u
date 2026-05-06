import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/trips_provider.dart';
import '../widgets/trip_card.dart';
import '../../data/models/trip_models.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Trips',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Color(0xFF00CEA6),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF00CEA6),
            tabs: [
              Tab(text: 'Current'),
              Tab(text: 'Next'),
              Tab(text: 'Past'),
              Tab(text: 'Wish List'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TripTabContent(type: 'current'),
            TripTabContent(type: 'next'),
            TripTabContent(type: 'past'),
            Center(child: Text('Wishlist functionality coming soon')),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to Trip Request Builder (Module 8)
          },
          backgroundColor: const Color(0xFF00CEA6),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class TripTabContent extends StatelessWidget {
  final String type;

  const TripTabContent({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Consumer<TripsProvider>(
      builder: (context, provider, child) {
        List<Trip> tripsToShow;
        switch (type) {
          case 'current':
            tripsToShow = provider.currentTrips;
            break;
          case 'next':
            tripsToShow = provider.nextTrips;
            break;
          case 'past':
            tripsToShow = provider.pastTrips;
            break;
          default:
            tripsToShow = [];
        }

        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF00CEA6)));
        }

        if (tripsToShow.isEmpty) {
          return _buildEmptyState(type);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tripsToShow.length,
          itemBuilder: (context, index) {
            final trip = tripsToShow[index];
            return TripCard(
              trip: trip,
              onChat: () => _showComingSoon(context, 'Chat'),
              onDetail: () => _showComingSoon(context, 'Detail View'),
              onPay: () => _showComingSoon(context, 'Payment Checkout'),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String type) {
    IconData icon;
    String title;
    String subtitle;

    switch (type) {
      case 'current':
        icon = Icons.directions_run;
        title = 'No ongoing trips';
        subtitle = 'You are not on any trip right now.';
        break;
      case 'next':
        icon = Icons.event;
        title = 'No upcoming trips';
        subtitle = 'Plan your next adventure today!';
        break;
      case 'past':
        icon = Icons.history;
        title = 'No past trips';
        subtitle = 'Your travel history will appear here.';
        break;
      default:
        icon = Icons.card_travel;
        title = 'Empty';
        subtitle = '';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature functionality coming soon!')),
    );
  }
}
