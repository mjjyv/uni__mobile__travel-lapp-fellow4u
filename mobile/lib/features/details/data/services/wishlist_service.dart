import 'dart:convert';
import 'package:http/http.dart' as http;

class WishlistService {
  final String baseUrl = 'http://localhost:3000/api/wishlist';

  Future<Map<String, dynamic>> toggleWishlist({
    int? tourId,
    int? expId,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/toggle'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        if (tourId != null) 'tour_id': tourId,
        if (expId != null) 'exp_id': expId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to toggle wishlist');
    }
  }

  Future<Map<String, List<int>>> getWishlistIds(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List data = decoded['data'];
      List<int> tourIds = [];
      List<int> expIds = [];
      for (var item in data) {
        if (item['tour_id'] != null) tourIds.add(item['tour_id']);
        if (item['exp_id'] != null) expIds.add(item['exp_id']);
      }
      return {'tours': tourIds, 'experiences': expIds};
    }
    return {'tours': [], 'experiences': []};
  }
}
