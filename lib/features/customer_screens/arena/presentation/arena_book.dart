import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:playhub/core/api/arena_api.dart';
import 'package:playhub/core/common/widgets/bottom_navbar.dart';
import 'package:playhub/core/common/widgets/custom_app_bar.dart';
import 'package:playhub/core/common/widgets/custom_button.dart';
import 'package:playhub/core/theme/app_pallete.dart';
import 'package:playhub/features/customer_screens/arena/widgets/arena_detail_card.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

class ArenaBookingScreen extends StatefulWidget {
  final String id;
  final String arenaName;
  final String bookingStatus;
  final String location;
  final int capacity;
  final double price;
  final double rating;

  const ArenaBookingScreen({
    super.key,
    required this.arenaName,
    required this.bookingStatus,
    required this.location,
    required this.capacity,
    required this.price,
    required this.rating,
    required this.id,
  });

  @override
  State<ArenaBookingScreen> createState() => _ArenaBookingScreenState();
}

class _ArenaBookingScreenState extends State<ArenaBookingScreen> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isLoading = false;

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != startTime) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != endTime) {
      setState(() {
        endTime = picked;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

// Helper function to format TimeOfDay to ISO format (for backend API)
  String formatTimeOfDayToISO(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return dateTime.toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: widget.arenaName),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArenaDetailsCard(
                    arenaName: widget.arenaName,
                    location: widget.location,
                    capacity: widget.capacity,
                    rating: widget.rating,
                    bookingStatus: widget.bookingStatus,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Choose Time',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppPalettes.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildStartTimePicker(),
                  const SizedBox(height: 15),
                  _buildEndTimePicker(),
                  const SizedBox(height: 30),
                  const Spacer(),
                  CustomButton(
                    text: 'Book Now',
                    onPressed: () {
                      if (startTime == null || endTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select start and end times'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      var totalAmount = widget.price;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaypalCheckoutView(
                            sandboxMode: true,
                            clientId:
                                "AW9VEI3zFdFhhKrdB9uigRmmwNnvafYpXixa5D6U3aveMo5JZEbcqVf7YFhR__7n6xbCxXiKPQjHMr5r",
                            secretKey:
                                "EPEBUyS8R__NI_sQY1cMGaDxsJa-aA6zBnZYqU-_PrTthTPuiO0Fq3eMsEshR-16S8gSRoaGq2_3cQed",
                            transactions: [
                              {
                                "amount": {
                                  "total": totalAmount,
                                  "currency": "USD",
                                  "details": {
                                    "subtotal": totalAmount,
                                    "shipping": '0',
                                    "shipping_discount": 0,
                                  }
                                },
                              }
                            ],
                            note: "Booking Payment",
                            onSuccess: (Map params) async {
                              print("Payment successful: $params");

                              // Handle arena booking after successful payment
                              await ArenaAPI.bookArena(
                                widget.id,
                                formatTimeOfDayToISO(startTime!),
                                formatTimeOfDayToISO(endTime!),
                                totalAmount as double,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Booking successful'),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => BottomNavbar()),
                              );
                            },
                            onError: (error) {
                              print("Error: $error");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Payment failed: $error'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            onCancel: () {
                              print('Payment cancelled');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Payment was cancelled'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStartTimePicker() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.access_time, color: AppPalettes.primary),
      title: Text(
        startTime != null
            ? 'Start Time: ${formatTimeOfDay(startTime!)}'
            : 'Select Start Time',
        style: TextStyle(
          fontSize: 16,
          color: AppPalettes.accent.withOpacity(0.5),
        ),
      ),
      trailing: const Icon(Icons.keyboard_arrow_down),
      onTap: () => _selectStartTime(context),
    );
  }

  Widget _buildEndTimePicker() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading:
          const Icon(Icons.access_time_outlined, color: AppPalettes.primary),
      title: Text(
        endTime != null
            ? 'End Time: ${formatTimeOfDay(endTime!)}'
            : 'Select End Time',
        style: TextStyle(
          fontSize: 16,
          color: AppPalettes.accent.withOpacity(0.5),
        ),
      ),
      trailing: const Icon(Icons.keyboard_arrow_down),
      onTap: () => _selectEndTime(context),
    );
  }
}
