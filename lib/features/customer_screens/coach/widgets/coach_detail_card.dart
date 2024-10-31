import 'package:flutter/material.dart';
import 'package:playhub/core/theme/app_pallete.dart';
import 'package:playhub/features/customer_screens/coach/presentation/coach_review.dart';

class CoachDetailsCard extends StatelessWidget {
  final String id;
  final String coachName;
  final String specialization;
  final String bio;
  final bool? availability;
  final String profilePictureUrl;

  const CoachDetailsCard({
    Key? key,
    required this.id,
    required this.coachName,
    required this.specialization,
    required this.bio,
    this.availability,
    required this.profilePictureUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppPalettes.foreground,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  coachName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppPalettes.accent,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoachReviewScreen(coachId: id),
                      ),
                    );
                  },
                  child: const Icon(Icons.reviews, color: AppPalettes.accent),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    specialization,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.group, color: Colors.blueGrey),
                    const SizedBox(width: 5),
                    Text(
                      availability == true ? 'Available' : 'Unavailable',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppPalettes.accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Bio: $bio', // Displaying the bio
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
