import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/explore_provider.dart';
import '../widgets/section_header.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/location_chip.dart';
import '../widgets/tour_card.dart';
import '../widgets/guide_card.dart';
import '../widgets/experience_card.dart';
import '../widgets/news_item.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<ExploreProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${provider.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => provider.fetchExploreData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => provider.fetchExploreData(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Explore',
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: const [
                                    Icon(Icons.location_on, size: 16, color: Color(0xFF00CEA6)),
                                    SizedBox(width: 4),
                                    Text(
                                      'Da Nang',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Icon(Icons.cloud_queue, size: 16, color: Colors.blue),
                                    SizedBox(width: 4),
                                    Text(
                                      '26°C',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Search Bar
                    const CustomSearchBar(),

                    // Top Journeys (Horizontal)
                    if (provider.featuredTours.isNotEmpty) ...[
                      const SectionHeader(title: 'Top Journeys'),
                      SizedBox(
                        height: 280,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.featuredTours.length,
                          itemBuilder: (context, index) {
                            return TourCard(tour: provider.featuredTours[index], isHorizontal: true);
                          },
                        ),
                      ),
                    ],

                    // Best Guides (Grid 2 columns)
                    if (provider.bestGuides.isNotEmpty) ...[
                      SectionHeader(
                        title: 'Best Guides',
                        onSeeAll: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: provider.bestGuides.length.clamp(0, 4), // Limit to 4 for preview
                          itemBuilder: (context, index) {
                            return GuideCard(guide: provider.bestGuides[index]);
                          },
                        ),
                      ),
                    ],

                    // Top Experiences
                    if (provider.topExperiences.isNotEmpty) ...[
                      const SectionHeader(title: 'Top Experiences'),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.topExperiences.length,
                          itemBuilder: (context, index) {
                            return ExperienceCard(experience: provider.topExperiences[index]);
                          },
                        ),
                      ),
                    ],

                    // Featured Tours (Vertical)
                    if (provider.featuredTours.isNotEmpty) ...[
                      SectionHeader(
                        title: 'Featured Tours',
                        onSeeAll: () {},
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: provider.featuredTours.length,
                        itemBuilder: (context, index) {
                          return TourCard(tour: provider.featuredTours[index], isHorizontal: false);
                        },
                      ),
                    ],

                    // Travel News
                    if (provider.travelNews.isNotEmpty) ...[
                      SectionHeader(
                        title: 'Travel News',
                        onSeeAll: () {},
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: provider.travelNews.length,
                        itemBuilder: (context, index) {
                          return NewsItem(news: provider.travelNews[index]);
                        },
                      ),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
