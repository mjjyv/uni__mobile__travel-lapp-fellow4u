import 'package:flutter/material.dart';
import '../../data/models/explore_models.dart';

class TourCard extends StatelessWidget {
  final Tour tour;
  final VoidCallback? onTap;
  final bool isHorizontal;

  const TourCard({
    super.key,
    required this.tour,
    this.onTap,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    return isHorizontal ? _buildHorizontalCard() : _buildVerticalCard();
  }

  Widget _buildHorizontalCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                tour.thumbnailUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      const Text(
                        'Jan 30, 2020', // Static for design matching or use dynamic
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Spacer(),
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${tour.durationDays} days',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${tour.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF00CEA6),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    tour.thumbnailUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border, size: 20, color: Color(0xFF00CEA6)),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 15,
                  child: Row(
                    children: List.generate(5, (index) => const Icon(Icons.star, size: 16, color: Colors.amber)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          tour.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      const Icon(Icons.favorite_border, color: Color(0xFF00CEA6)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      const Text('Jan 30, 2020', style: TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(width: 20),
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text('${tour.durationDays} days', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      const Spacer(),
                      Text(
                        '\$${tour.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFF00CEA6),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
