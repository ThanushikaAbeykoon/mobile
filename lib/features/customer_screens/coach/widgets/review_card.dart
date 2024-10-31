import 'package:flutter/material.dart';
import 'package:playhub/core/theme/app_pallete.dart';

class ReviewCard extends StatelessWidget {
  final VoidCallback onBookNow;
  final Map<String, dynamic> review;

  const ReviewCard({
    Key? key,
    required this.onBookNow,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerDetails = review['customerDetails'];
    final firstName = customerDetails?['firstName'] ?? 'Anonymous';
    final lastName = customerDetails?['lastName'] ?? '';

    return GestureDetector(
      onTap: onBookNow,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: AppPalettes.cardForeground,
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(review['profilePictureUrl'] ?? ''),
                    radius: 30,
                    backgroundColor: AppPalettes.accentForeground,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${firstName[0].toUpperCase()}${firstName.substring(1)} ${lastName[0].toUpperCase()}${lastName.substring(1)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppPalettes.accent,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${DateTime.parse(review['createdAt']).toLocal().toString().split(' ')[0] ?? 'Unknown date'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Rating Section
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    '${review['rating'] ?? '0'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppPalettes.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                review['review'] ?? 'No review provided.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: AppPalettes.accentForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
