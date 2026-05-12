import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/notification_provider.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.watch<NotificationProvider>();
    final notifications = notificationProvider.notifications;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Banner Header
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://storage.mistudio.asia/ha-noi-viptour-9671112913/storage/cau-rong-da-nang-citytour-hanpiviptours.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.2)),
              ),
              Positioned(
                bottom: 24,
                left: 24,
                child: const Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                right: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  child: const Icon(Icons.search, color: Colors.white),
                ),
              ),
            ],
          ),
          // Notification List
          Expanded(
            child: notifications.isEmpty
                ? const Center(child: Text('No notifications'))
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return _buildNotificationItem(context, notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, dynamic notification) {
    final dateFormat = DateFormat('MMM dd');
    
    // Determine sub-icon based on category
    IconData subIcon = Icons.location_on;
    Color subIconColor = Colors.green;
    
    final category = notification.category.toLowerCase();
    if (category.contains('offer') || category.contains('request')) {
      subIcon = Icons.description;
      subIconColor = Colors.orange;
    } else if (category.contains('finish') || category.contains('review')) {
      subIcon = Icons.edit;
      subIconColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with sub-icon
          Stack(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(notification.extraData?['sender_avatar'] ?? 'https://via.placeholder.com/150'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: subIconColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(subIcon, color: Colors.white, size: 10),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    children: [
                      TextSpan(
                        text: notification.message,
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(notification.createdAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                if (category.contains('finish')) ...[
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00CEA6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    ),
                    child: const Text('Leave Review'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
