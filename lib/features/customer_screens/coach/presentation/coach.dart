import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:playhub/core/api/coach_api.dart';
import 'package:playhub/core/common/widgets/draggable_header.dart';
import 'package:playhub/core/theme/app_pallete.dart';
import 'package:playhub/features/customer_screens/arena/camera_preview.dart';
import 'package:playhub/features/customer_screens/coach/presentation/booked_coach.dart';
import 'package:playhub/features/customer_screens/coach/presentation/coach_book.dart';
import 'package:playhub/features/customer_screens/coach/widgets/coach_card.dart';

class Coach extends StatefulWidget {
  const Coach({super.key});

  @override
  _CoachState createState() => _CoachState();
}

class _CoachState extends State<Coach> {
  List<dynamic> coaches = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCoach();
  }

  Future<void> fetchCoach() async {
    try {
      final fetchedCoaches = await CoachAPI.fetchCoach();
      setState(() {
        coaches = fetchedCoaches.where((coach) {
          final coachDetails = coach['coachDetails'];
          return coachDetails != null &&
              coachDetails['availability'] != null &&
              coachDetails['price'] != null;
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      appBarColor: Colors.black,
      backgroundColor: Colors.black,
      expandedBody: CameraPreview(),
      title: Text(
        'Coach',
        style: TextStyle(
          color: AppPalettes.accent,
        ),
      ),
      headerWidget: DraggableHeader(
        title: 'Coach',
        description: 'Welcome to the Coach. Book your favorite coach now!',
        onPressedOne: () {},
        onPressedTwo: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookedCoachScreen(),
            ),
          );
        },
      ),
      body: [
        isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: coaches.map((coach) {
                    final coachDetails = coach['coachDetails'];
                    return CoachCard(
                      coachName: '${coach['firstName']} ${coach['lastName']}',
                      specialization: coachDetails['specialization'] ?? 'N/A',
                      bio: coachDetails['bio'] ?? 'No bio available',
                      availability: coachDetails['availability'] ?? false,
                      profilePictureUrl: coach['profile_picture_url'] ?? '',
                      onBookNow: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoachBookingScreen(
                              id: coach['_id'],
                              coachName:
                                  '${coach['firstName']} ${coach['lastName']}',
                              specialization:
                                  coachDetails['specialization'] ?? 'N/A',
                              bio: coachDetails['bio'] ?? 'No bio available',
                              availability:
                                  coachDetails['availability'] ?? 'N/A',
                              profilePictureUrl:
                                  coach['profile_picture_url'] ?? '',
                              price: coachDetails['price'] ?? 10.0,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
      ],
    );
  }
}
