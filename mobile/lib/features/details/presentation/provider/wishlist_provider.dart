import 'package:flutter/material.dart';
import '../../data/services/wishlist_service.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistService _service = WishlistService();
  
  Set<int> _tourIds = {};
  Set<int> _expIds = {};
  bool _isLoading = false;

  Set<int> get tourIds => _tourIds;
  Set<int> get expIds => _expIds;
  bool get isLoading => _isLoading;

  bool isFavorite(int id, {bool isTour = true}) => 
      isTour ? _tourIds.contains(id) : _expIds.contains(id);

  Future<void> fetchWishlist(String token) async {
    _isLoading = true;
    notifyListeners();
    try {
      final idMap = await _service.getWishlistIds(token);
      _tourIds = idMap['tours']?.toSet() ?? {};
      _expIds = idMap['experiences']?.toSet() ?? {};
    } catch (e) {
      debugPrint('Error fetching wishlist: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleWishlist(String token, {int? tourId, int? expId}) async {
    final bool isTour = tourId != null;
    final targetId = tourId ?? expId;
    if (targetId == null) return;

    final targetSet = isTour ? _tourIds : _expIds;

    // Optimistic UI update
    if (targetSet.contains(targetId)) {
      targetSet.remove(targetId);
    } else {
      targetSet.add(targetId);
    }
    notifyListeners();

    try {
      await _service.toggleWishlist(
        token: token,
        tourId: tourId,
        expId: expId,
      );
    } catch (e) {
      // Rollback on failure
      if (targetSet.contains(targetId)) {
        targetSet.remove(targetId);
      } else {
        targetSet.add(targetId);
      }
      notifyListeners();
      debugPrint('Error toggling wishlist: $e');
    }
  }
}
