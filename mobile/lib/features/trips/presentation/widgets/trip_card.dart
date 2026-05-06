import 'package:flutter/material.dart';
import '../../data/models/trip_models.dart';
import 'trip_status_badge.dart';
import 'package:intl/intl.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onChat;
  final VoidCallback? onDetail;
  final VoidCallback? onPay;

  const TripCard({
    super.key,
    required this.trip,
    this.onChat,
    this.onDetail,
    this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Status
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  trip.tour.thumbnailUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: TripStatusBadge(status: trip.status),
              ),
              if (trip.status == TripStatus.bidding)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: _buildBiddingAvatars(),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.tour.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${dateFormat.format(trip.startDate)} - ${dateFormat.format(trip.endDate)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${timeFormat.format(trip.startDate)} to ${timeFormat.format(trip.endDate)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                
                if (trip.guide != null) ...[
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(trip.guide!.avatarUrl),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.guide!.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Local Guide • ${trip.guide!.rating} ⭐',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      if (trip.status == TripStatus.unpaid)
                        ElevatedButton(
                          onPressed: onPay,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00CEA6),
                            minimumSize: const Size(80, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: const Text('Pay', style: TextStyle(fontSize: 14)),
                        )
                      else if (trip.status != TripStatus.completed && trip.status != TripStatus.cancelled)
                        IconButton(
                          onPressed: onChat,
                          icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF00CEA6)),
                        ),
                    ],
                  ),
                ],

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      trip.status == TripStatus.bidding 
                        ? 'Bidding in progress...' 
                        : 'Total: \$${trip.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: trip.status == TripStatus.bidding ? Colors.blue : Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: onDetail,
                      child: const Text(
                        'Detail',
                        style: TextStyle(color: Color(0xFF00CEA6), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiddingAvatars() {
    return SizedBox(
      height: 32,
      child: Stack(
        children: List.generate(
          trip.bids.length.clamp(0, 3),
          (index) => Positioned(
            right: index * 20.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(trip.bids[index].guide.avatarUrl),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
