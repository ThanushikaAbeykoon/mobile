import 'package:flutter/material.dart';
import 'package:playhub/core/theme/app_pallete.dart';

class ArenaDetailsCard extends StatelessWidget {
  final String arenaName;
  final String location;
  final int capacity;
  final double rating;
  final String bookingStatus;

  const ArenaDetailsCard({
    Key? key,
    required this.arenaName,
    required this.location,
    required this.capacity,
    required this.rating,
    required this.bookingStatus,
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
            Text(
              arenaName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppPalettes.accent,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    location,
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
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 5),
                    Text(
                      '$rating',
                      style: const TextStyle(
                          fontSize: 18, color: AppPalettes.accent),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.group, color: Colors.blueGrey),
                    const SizedBox(width: 5),
                    Text(
                      '$capacity people',
                      style: const TextStyle(
                          fontSize: 18, color: AppPalettes.accent),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Status: $bookingStatus',
              style: TextStyle(
                fontSize: 18,
                color: bookingStatus == 'Available' ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
