import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../chat/presentation/screens/chat_detail_screen.dart';
import '../../../trips/presentation/screens/trip_detail_screen.dart';
import '../provider/notification_provider.dart';
import '../widgets/notification_tile.dart';
import '../../data/models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.token != null) {
        context.read<NotificationProvider>().fetchNotifications(auth.token!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (auth.token != null)
            TextButton(
              onPressed: () {
                context.read<NotificationProvider>().markAllAsRead(auth.token!);
              },
              child: const Text(
                'Mark all as read',
                style: TextStyle(color: Color(0xFF00CEA6), fontWeight: FontWeight.w600),
              ),
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                if (auth.token != null) {
                  await context.read<NotificationProvider>().fetchNotifications(auth.token!);
                }
              },
              color: const Color(0xFF00CEA6),
              child: Consumer<NotificationProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.notifications.isEmpty) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF00CEA6)));
                  }

                  if (provider.error != null && provider.notifications.isEmpty) {
                    return _buildErrorState(provider, auth.token);
                  }

                  if (provider.notifications.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: provider.notifications.length,
                    separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[100]),
                    itemBuilder: (context, index) {
                      final notification = provider.notifications[index];
                      return Dismissible(
                        key: Key('notif_${notification.notifId}'),
                        direction: DismissDirection.horizontal,
                        background: _buildSwipeBackground(Alignment.centerLeft, Colors.green, Icons.check_circle_outline, 'Read'),
                        secondaryBackground: _buildSwipeBackground(Alignment.centerRight, Colors.red, Icons.delete_outline, 'Delete'),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            if (auth.token != null) {
                              provider.markAsRead(notification.notifId, auth.token!);
                            }
                          } else {
                            if (auth.token != null) {
                              provider.deleteNotification(notification.notifId, auth.token!);
                            }
                          }
                        },
                        child: NotificationTile(
                          notification: notification,
                          onTap: () {
                            if (auth.token != null) {
                              provider.markAsRead(notification.notifId, auth.token!);
                            }
                            _handleDeepLink(notification);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              _buildFilterChip('All', NotificationFilter.all, provider),
              _buildFilterChip('Unread', NotificationFilter.unread, provider),
              _buildFilterChip('Bookings', NotificationFilter.bookings, provider),
              _buildFilterChip('Messages', NotificationFilter.messages, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, NotificationFilter filter, NotificationProvider provider) {
    final isSelected = provider.currentFilter == filter;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => provider.setFilter(filter),
        selectedColor: const Color(0xFF00CEA6).withOpacity(0.2),
        checkmarkColor: const Color(0xFF00CEA6),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF00CEA6) : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildSwipeBackground(Alignment alignment, Color color, IconData icon, String label) {
    return Container(
      color: color,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerLeft) Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          if (alignment == Alignment.centerRight) Icon(icon, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildErrorState(NotificationProvider provider, String? token) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: ${provider.error}', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (token != null) provider.fetchNotifications(token);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00CEA6)),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_outlined, size: 100, color: Colors.grey[200]),
          const SizedBox(height: 24),
          const Text(
            'No notifications here',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check your filters or wait for new updates.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _handleDeepLink(NotificationModel notification) {
    if (notification.relatedEntityId == null) return;

    if (notification.relatedEntityType == 'booking') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripDetailScreen(tripId: notification.relatedEntityId!),
        ),
      );
    } else if (notification.relatedEntityType == 'chat') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailScreen(roomId: notification.relatedEntityId!),
        ),
      );
    }
  }
}
