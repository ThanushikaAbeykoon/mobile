import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:playhub/core/api/arena_api.dart';
import 'package:playhub/core/common/widgets/draggable_header.dart';
import 'package:playhub/core/theme/app_pallete.dart';
import 'package:playhub/features/customer_screens/arena/camera_preview.dart';
import 'package:playhub/features/customer_screens/arena/presentation/arena_book.dart';
import 'package:playhub/features/customer_screens/arena/presentation/booked_arena.dart';
import 'package:playhub/features/customer_screens/arena/widgets/arena_card.dart';

class Arena extends StatefulWidget {
  const Arena({super.key});

  @override
  _ArenaState createState() => _ArenaState();
}

class _ArenaState extends State<Arena> {
  List<dynamic> arenas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArenas();
  }

  Future<void> fetchArenas() async {
    try {
      final fetchedArenas = await ArenaAPI.fetchArenas();
      setState(() {
        arenas = fetchedArenas;
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
        'Arena',
        style: TextStyle(
          color: AppPalettes.accent,
        ),
      ),
      headerWidget: DraggableHeader(
        title: 'Arena',
        description: 'Welcome to the Arena. Book your favorite arena now!',
        onPressedOne: () {},
        onPressedTwo: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookedArenaScreen(),
            ),
          );
        },
      ),
      body: [
        isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: arenas.map((arena) {
                    return ArenaBookingCard(
                      arenaName: arena['name'],
                      bookingStatus: arena['availability'],
                      location: arena['location'],
                      capacity: arena['capacity'],
                      price: 50.0,
                      rating: 4.5,
                      onBookNow: () {
                        // Navigate to ArenaBookingScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArenaBookingScreen(
                              id: arena['_id'].toString(),
                              arenaName: arena['name'],
                              bookingStatus: arena['availability'],
                              location: arena['location'],
                              capacity: arena['capacity'],
                              price: 50.0,
                              rating: 4.5,
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
