import 'package:flutter/material.dart';

class JourneyList extends StatelessWidget {
  const JourneyList({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data
    final journeys = [
      {
        'title': 'A memory in Danang',
        'location': 'Da Nang, Vietnam',
        'date': 'Jan 20, 2024',
        'image': 'https://danangfantasticity.com/wp-content/uploads/2019/01/telegraph-co-uk-tai-sao-ban-nen-ghe-tham-da-nang-viet-nam-nam-2019-nay-012.jpg',
      },
      {
        'title': 'Seoul Soul',
        'location': 'Seoul, South Korea',
        'date': 'Dec 15, 2023',
        'image': 'https://www.agoda.com/wp-content/uploads/2024/04/Featured-image-Han-River-at-night-in-Seoul-South-Korea.jpg',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: journeys.length,
      itemBuilder: (context, index) {
        final journey = journeys[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
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
                  journey['image']!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      journey['title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          journey['location']!,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const Spacer(),
                        Text(
                          journey['date']!,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
