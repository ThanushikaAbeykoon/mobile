import 'package:flutter/material.dart';
import 'package:playhub/core/theme/app_pallete.dart';

class BookingDetailCard extends StatelessWidget {
  final String bookingId;
  final String coachName;
  final double totalCost;
  final VoidCallback onMoreDetails;

  const BookingDetailCard({
    Key? key,
    required this.bookingId,
    required this.coachName,
    required this.totalCost,
    required this.onMoreDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onMoreDetails,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: AppPalettes.cardForeground,
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.confirmation_number, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Booking ID: $bookingId',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.person, color: Colors.grey[400]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Coach Name: $coachName',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey[700]),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.attach_money, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Total Cost: \$$totalCost',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
