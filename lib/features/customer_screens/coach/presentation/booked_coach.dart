import 'package:flutter/material.dart';
import 'package:playhub/core/api/arena_api.dart';
import 'package:playhub/core/api/coach_api.dart';
import 'package:playhub/core/theme/app_pallete.dart';
import 'package:playhub/features/customer_screens/coach/widgets/coach_booking_detail_card.dart';

class BookedCoachScreen extends StatefulWidget {
  const BookedCoachScreen({super.key});

  @override
  State<BookedCoachScreen> createState() => _BookedCoachScreenState();
}

class _BookedCoachScreenState extends State<BookedCoachScreen> {
  List<dynamic> coaches = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCoaches();
  }

  Future<void> fetchCoaches() async {
    try {
      final fetchedCoaches = await ArenaAPI.fetchCoachesByUser();
      for (var coach in fetchedCoaches) {
        final coachDetails = await CoachAPI.fetchCoachById(coach['coachId']);
        coach['coachName'] =
            '${coachDetails['firstName']} ${coachDetails['lastName']}';

        if (coachDetails['coachDetails'] != null) {
          coach['bio'] =
              coachDetails['coachDetails']['bio'] ?? 'Bio not available';
        } else {
          coach['bio'] = 'Bio not available';
        }
      }
      setState(() {
        coaches = fetchedCoaches;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error: $e');
    }
  }

  void _showMoreDetails(BuildContext context, dynamic coach) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: AppPalettes.primary,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppPalettes.accent,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Booking ID: ${coach['bookingId']}',
                style: TextStyle(color: AppPalettes.accent),
              ),
              Text(
                'Coach Name: ${coach['coachName']}',
                style: TextStyle(color: AppPalettes.accent),
              ),
              Text(
                'Booking Date: ${coach['bookingDate']}',
                style: TextStyle(color: AppPalettes.accent),
              ),
              Text(
                'Total Cost: \$${coach['totalCost']}',
                style: TextStyle(color: AppPalettes.accent),
              ),
              const SizedBox(height: 16),
              Divider(color: AppPalettes.accent),
              const SizedBox(height: 16),
              Text(
                'Coach Bio: ${coach['bio']}',
                style: TextStyle(color: AppPalettes.accent),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: AppPalettes.accent,
                  onPrimary: AppPalettes.primary,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Bookings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppPalettes.accent,
          ),
        ),
        backgroundColor: AppPalettes.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : coaches.isEmpty
              ? const Center(child: Text('No bookings available.'))
              : SingleChildScrollView(
                  child: Column(
                    children: coaches.map((coach) {
                      return BookingDetailCard(
                        bookingId: coach['_id'] ?? 'N/A',
                        coachName: coach['coachName'] ?? 'Unknown',
                        totalCost:
                            (coach['totalCost'] as num?)?.toDouble() ?? 0.0,
                        onMoreDetails: () => _showMoreDetails(context, coach),
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
