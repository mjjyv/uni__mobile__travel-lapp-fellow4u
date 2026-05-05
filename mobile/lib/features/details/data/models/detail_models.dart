import '../../../explore/data/models/explore_models.dart';

class GuidePricing {
  final int minTravelers;
  final int maxTravelers;
  final double pricePerHour;

  GuidePricing({
    required this.minTravelers,
    required this.maxTravelers,
    required this.pricePerHour,
  });

  factory GuidePricing.fromJson(Map<String, dynamic> json) {
    return GuidePricing(
      minTravelers: json['min_travelers'],
      maxTravelers: json['max_travelers'],
      pricePerHour: double.parse(json['price_per_hour'].toString()),
    );
  }
}

class ReviewModel {
  final int id;
  final String authorName;
  final String authorAvatar;
  final int rating;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final author = json['Author'];
    return ReviewModel(
      id: json['review_id'],
      authorName: author != null ? '${author['first_name']} ${author['last_name']}' : 'Anonymous',
      authorAvatar: author?['avatar_url'] ?? '',
      rating: json['rating'],
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class PortfolioMedia {
  final String url;
  final String type; // 'image' or 'video'
  final String title;

  PortfolioMedia({
    required this.url,
    required this.type,
    required this.title,
  });

  factory PortfolioMedia.fromJson(Map<String, dynamic> json) {
    return PortfolioMedia(
      url: json['media_url'],
      type: json['media_type'],
      title: json['title'] ?? '',
    );
  }
}

class LanguageModel {
  final String name;
  final String code;

  LanguageModel({required this.name, required this.code});

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      name: json['lang_name'],
      code: json['lang_code'],
    );
  }
}

class GuideFullProfile {
  final Guide basicInfo;
  final String bio;
  final String coverUrl;
  final List<LanguageModel> languages;
  final List<GuidePricing> pricings;
  final List<ReviewModel> reviews;
  final List<PortfolioMedia> portfolio;

  GuideFullProfile({
    required this.basicInfo,
    required this.bio,
    required this.coverUrl,
    required this.languages,
    required this.pricings,
    required this.reviews,
    required this.portfolio,
  });

  factory GuideFullProfile.fromJson(Map<String, dynamic> json) {
    final user = json['User'];
    return GuideFullProfile(
      basicInfo: Guide.fromJson(json),
      bio: user?['bio'] ?? '',
      coverUrl: user?['cover_url'] ?? '',
      languages: (json['Languages'] as List? ?? [])
          .map((item) => LanguageModel.fromJson(item))
          .toList(),
      pricings: (json['Pricings'] as List? ?? [])
          .map((item) => GuidePricing.fromJson(item))
          .toList(),
      reviews: (json['Reviews'] as List? ?? [])
          .map((item) => ReviewModel.fromJson(item))
          .toList(),
      portfolio: (json['Portfolio'] as List? ?? [])
          .map((item) => PortfolioMedia.fromJson(item))
          .toList(),
    );
  }
}

class Attraction {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final String address;

  Attraction({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.address,
  });

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      id: json['attraction_id'],
      name: json['name'],
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

class LocationFullDetail {
  final Location basicInfo;
  final String description;
  final List<Attraction> attractions;
  final List<Tour> suggestedTours;
  final List<Experience> suggestedExperiences;

  LocationFullDetail({
    required this.basicInfo,
    required this.description,
    required this.attractions,
    required this.suggestedTours,
    required this.suggestedExperiences,
  });

  factory LocationFullDetail.fromJson(Map<String, dynamic> json) {
    return LocationFullDetail(
      basicInfo: Location.fromJson(json),
      description: json['description'] ?? '',
      attractions: (json['Attractions'] as List? ?? [])
          .map((item) => Attraction.fromJson(item))
          .toList(),
      suggestedTours: (json['Tours'] as List? ?? [])
          .map((item) => Tour.fromJson(item))
          .toList(),
      suggestedExperiences: (json['Experiences'] as List? ?? [])
          .map((item) => Experience.fromJson(item))
          .toList(),
    );
  }
}
