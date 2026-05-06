import 'package:flutter/material.dart';
import '../../data/models/trip_models.dart';
import '../../../../explore/data/models/explore_models.dart';

class TripsProvider with ChangeNotifier {
  List<Trip> _trips = [];
  bool _isLoading = false;

  List<Trip> get trips => _trips;
  bool get isLoading => _isLoading;

  List<Trip> get nextTrips => _trips.where((t) => 
    [TripStatus.waiting, TripStatus.bidding, TripStatus.unpaid, TripStatus.paid].contains(t.status)).toList();
  
  List<Trip> get currentTrips => _trips.where((t) => t.status == TripStatus.ongoing).toList();
  
  List<Trip> get pastTrips => _trips.where((t) => 
    [TripStatus.completed, TripStatus.cancelled, TripStatus.rejected].contains(t.status)).toList();

  TripsProvider() {
    _loadMockTrips();
  }

  void _loadMockTrips() {
    _trips = [
      // Ongoing Trip
      Trip(
        id: 1,
        travelerId: 1,
        guide: Guide(
          id: 101,
          name: 'Emmy',
          avatarUrl: 'https://i.pravatar.cc/150?u=emmy',
          rating: 4.8,
          totalReviews: 124,
          locationName: 'Da Nang',
        ),
        tour: Tour(
          id: 1,
          title: 'Dragon Bridge & Night Market',
          price: 25.0,
          durationDays: 1,
          thumbnail_url: 'https://images.unsplash.com/photo-1559592442-7e18259f63cc?auto=format&fit=crop&w=800&q=80',
          locationName: 'Da Nang',
        ),
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(hours: 4)),
        status: TripStatus.ongoing,
        totalPrice: 25.0,
        depositAmount: 12.5,
      ),
      // Next Trip - Waiting
      Trip(
        id: 2,
        travelerId: 1,
        guide: Guide(
          id: 102,
          name: 'Tuan',
          avatarUrl: 'https://i.pravatar.cc/150?u=tuan',
          rating: 4.5,
          totalReviews: 56,
          locationName: 'Hoi An',
        ),
        tour: Tour(
          id: 2,
          title: 'Hoi An Ancient Town Walk',
          price: 30.0,
          durationDays: 1,
          thumbnail_url: 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?auto=format&fit=crop&w=800&q=80',
          locationName: 'Hoi An',
        ),
        startDate: DateTime.now().add(const Duration(days: 2)),
        endDate: DateTime.now().add(const Duration(days: 2, hours: 3)),
        status: TripStatus.waiting,
        totalPrice: 30.0,
        depositAmount: 15.0,
      ),
      // Next Trip - Bidding
      Trip(
        id: 3,
        travelerId: 1,
        tour: Tour(
          id: 3,
          title: 'Custom Hue City Tour',
          price: 0.0,
          durationDays: 1,
          thumbnail_url: 'https://images.unsplash.com/photo-1599708153386-62e269290076?auto=format&fit=crop&w=800&q=80',
          locationName: 'Hue',
        ),
        startDate: DateTime.now().add(const Duration(days: 5)),
        endDate: DateTime.now().add(const Duration(days: 5, hours: 8)),
        status: TripStatus.bidding,
        totalPrice: 0.0,
        depositAmount: 0.0,
        bids: [
          BookingBid(
            id: 1,
            bookingId: 3,
            guide: Guide(id: 201, name: 'Linh', avatarUrl: 'https://i.pravatar.cc/150?u=linh', rating: 4.9, totalReviews: 89, locationName: 'Hue'),
            offeredPrice: 45.0,
          ),
          BookingBid(
            id: 2,
            bookingId: 3,
            guide: Guide(id: 202, name: 'Nam', avatarUrl: 'https://i.pravatar.cc/150?u=nam', rating: 4.2, totalReviews: 34, locationName: 'Hue'),
            offeredPrice: 40.0,
          ),
        ],
      ),
      // Past Trip
      Trip(
        id: 4,
        travelerId: 1,
        guide: Guide(
          id: 103,
          name: 'Hanh',
          avatarUrl: 'https://i.pravatar.cc/150?u=hanh',
          rating: 4.7,
          totalReviews: 112,
          locationName: 'Ho Chi Minh',
        ),
        tour: Tour(
          id: 4,
          title: 'Saigon Street Food Tour',
          price: 20.0,
          durationDays: 1,
          thumbnail_url: 'https://images.unsplash.com/photo-1528330959610-fe93b37d0ef4?auto=format&fit=crop&w=800&q=80',
          locationName: 'Ho Chi Minh City',
        ),
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        endDate: DateTime.now().subtract(const Duration(days: 10, hours: -3)),
        status: TripStatus.completed,
        totalPrice: 20.0,
        depositAmount: 10.0,
      ),
    ];
    notifyListeners();
  }

  Future<void> fetchTrips() async {
    _isLoading = true;
    notifyListeners();
    
    // In real app, call API here
    await Future.delayed(const Duration(seconds: 1));
    
    _isLoading = false;
    notifyListeners();
  }
}
