import 'package:mobile/features/explore/data/models/explore_models.dart';

enum TripStatus {
  waiting,
  bidding,
  unpaid,
  paid,
  ongoing,
  completed,
  cancelled,
  rejected
}

class BookingBid {
  final int id;
  final int bookingId;
  final Guide guide;
  final double offeredPrice;
  final String? message;
  final bool isSelected;

  BookingBid({
    required this.id,
    required this.bookingId,
    required this.guide,
    required this.offeredPrice,
    this.message,
    this.isSelected = false,
  });

  factory BookingBid.fromJson(Map<String, dynamic> json) {
    return BookingBid(
      id: json['bid_id'],
      bookingId: json['booking_id'],
      guide: Guide.fromJson(json['Guide']),
      offeredPrice: double.parse(json['offered_price'].toString()),
      message: json['message'],
      isSelected: json['is_selected'] ?? false,
    );
  }
}

class Trip {
  final int id;
  final int travelerId;
  final Guide? guide;
  final Tour tour;
  final DateTime startDate;
  final DateTime endDate;
  final TripStatus status;
  final double totalPrice;
  final double depositAmount;
  final String? meetingPoint;
  final String? specialRequests;
  final List<BookingBid> bids;

  Trip({
    required this.id,
    required this.travelerId,
    this.guide,
    required this.tour,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.totalPrice,
    required this.depositAmount,
    this.meetingPoint,
    this.specialRequests,
    this.bids = const [],
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['booking_id'],
      travelerId: json['traveler_id'],
      guide: json['Guide'] != null ? Guide.fromJson(json['Guide']) : null,
      tour: Tour.fromJson(json['Tour']),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: TripStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TripStatus.waiting,
      ),
      totalPrice: double.parse(json['total_price'].toString()),
      depositAmount: double.parse(json['deposit_amount'].toString()),
      meetingPoint: json['meeting_point'],
      specialRequests: json['special_requests'],
      bids: (json['Bids'] as List?)
              ?.map((i) => BookingBid.fromJson(i))
              .toList() ??
          [],
    );
  }
}
