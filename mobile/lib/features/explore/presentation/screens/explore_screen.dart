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
import '../../../details/presentation/screens/tour_detail_screen.dart';
import '../../../details/presentation/screens/guide_detail_screen.dart';
import '../../../details/presentation/screens/destination_detail_screen.dart';
import '../../categories/presentation/screens/category_extended_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ExploreProvider>(
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
                  // Header with Background Image and Overlays
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 280,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1559592442-7e18259d69e7?q=80&w=1000&auto=format&fit=crop'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: 280,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.transparent,
                              Colors.black.withOpacity(0.2),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 60,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Explore',
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(Icons.location_on, size: 18, color: Colors.white),
                                        SizedBox(width: 4),
                                        Text(
                                          'Da Nang',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: const [
                                        Icon(Icons.cloud_queue, size: 24, color: Colors.white),
                                        SizedBox(width: 6),
                                        Text(
                                          '26°C',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 34,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: 0,
                        right: 0,
                        child: const CustomSearchBar(readOnly: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 45),

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
                            final tour = provider.featuredTours[index];
                            return TourCard(
                              tour: tour, 
                              isHorizontal: true,
                              onTap: () => Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (_) => TourDetailScreen(tourId: tour.id))
                              ),
                            );
                          },
                        ),
                      ),
                    ],

                    // Best Guides (Grid 2 columns)
                    if (provider.bestGuides.isNotEmpty) ...[
                      SectionHeader(
                        title: 'Best Guides',
                        onSeeAll: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CategoryExtendedScreen(
                              pageType: 'Guides_More',
                              collectionSlug: 'best-guides',
                            ),
                          ),
                        ),
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
                            final guide = provider.bestGuides[index];
                            return GuideCard(
                              guide: guide,
                              onTap: () => Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (_) => GuideDetailScreen(guideId: guide.id))
                              ),
                            );
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
                            final exp = provider.topExperiences[index];
                            return ExperienceCard(
                              experience: exp,
                              onTap: () => Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (_) => TourDetailScreen(tourId: exp.id)) // Reuse tour detail or create exp detail
                              ),
                            );
                          },
                        ),
                      ),
                    ],

                    // Featured Tours (Vertical)
                    if (provider.featuredTours.isNotEmpty) ...[
                      SectionHeader(
                        title: 'Featured Tours',
                        onSeeAll: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CategoryExtendedScreen(
                              pageType: 'Tours_More',
                              collectionSlug: 'featured-tours',
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: provider.featuredTours.length,
                        itemBuilder: (context, index) {
                          final tour = provider.featuredTours[index];
                          return TourCard(
                            tour: tour, 
                            isHorizontal: false,
                            onTap: () => Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (_) => TourDetailScreen(tourId: tour.id))
                            ),
                          );
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
