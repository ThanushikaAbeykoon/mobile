import 'package:flutter/material.dart';
import 'package:playhub/core/api/arena_api.dart';
import 'package:playhub/core/theme/app_pallete.dart';
// Removed unused import
import 'package:playhub/features/customer_screens/arena/widgets/booking_detail_card.dart';

class BookedArenaScreen extends StatefulWidget {
  const BookedArenaScreen({super.key});

  @override
  State<BookedArenaScreen> createState() => _BookedArenaScreenState();
}

class _BookedArenaScreenState extends State<BookedArenaScreen> {
  List<dynamic> arenas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArenas();
  }

  Future<void> fetchArenas() async {
    try {
      final fetchedArenas = await ArenaAPI.fetchArenasByUser();
      setState(() {
        arenas = fetchedArenas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Use a logging framework instead of print
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Bookings',
          style: const TextStyle(
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
      body: SingleChildScrollView(
        child: Column(
          children: arenas.map((arena) {
            return BookingDetailCard(
              bookingId: arena['bookingId'],
              arenaId: arena['arenaId'],
              totalCost: (arena['totalCost'] as num).toDouble(),
            );
          }).toList(),
        ),
      ),
    );
  }
}
