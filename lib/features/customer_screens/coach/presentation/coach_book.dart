import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:playhub/core/api/coach_api.dart';
import 'package:playhub/core/common/widgets/bottom_navbar.dart';
import 'package:playhub/core/common/widgets/custom_app_bar.dart';
import 'package:playhub/core/common/widgets/custom_button.dart';
import 'package:playhub/core/theme/app_pallete.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:playhub/features/customer_screens/coach/widgets/coach_detail_card.dart';

class CoachBookingScreen extends StatefulWidget {
  final String id;
  final String coachName;
  final String specialization;
  final String bio;
  final bool availability;
  final String profilePictureUrl;
  final int price;

  const CoachBookingScreen({
    Key? key,
    required this.id,
    required this.coachName,
    required this.specialization,
    required this.bio,
    required this.availability,
    required this.profilePictureUrl,
    required this.price,
  }) : super(key: key);

  @override
  _CoachBookingScreenState createState() => _CoachBookingScreenState();
}

class _CoachBookingScreenState extends State<CoachBookingScreen> {
  String? startTime;
  String? endTime;
  String? selectedDate;
  bool isLoading = false;

// Date Picker Method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd')
            .format(picked); // Correctly format the date
      });
    }
  }

// Start Time Picker Method
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final startDateTime =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        startTime = DateFormat('hh:mm a')
            .format(startDateTime); // Correctly format the time
      });
    }
  }

// End Time Picker Method
  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final endDateTime =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        endTime = DateFormat('hh:mm a')
            .format(endDateTime); // Correctly format the time
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: widget.coachName),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CoachDetailsCard(
                    id: widget.id,
                    coachName:
                        '${widget.coachName.split(' ')[0]} ${widget.coachName.split(' ').length > 1 ? widget.coachName.split(' ')[1] : ''}',
                    specialization: widget.specialization,
                    bio: widget.bio,
                    availability: widget.availability,
                    profilePictureUrl: widget.profilePictureUrl,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Choose Date and Time',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppPalettes.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDatePicker(),
                  const SizedBox(height: 15),
                  _buildStartTimePicker(),
                  const SizedBox(height: 15),
                  _buildEndTimePicker(),
                  const SizedBox(height: 30),
                  const Spacer(),
                  CustomButton(
                    text: 'Book Now',
                    onPressed: () {
                      if (selectedDate == null ||
                          startTime == null ||
                          endTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please select date, start and end times'),
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
                                  "total": totalAmount.toString(),
                                  "currency": "USD",
                                  "details": {
                                    "subtotal": totalAmount.toString(),
                                    "shipping": '0',
                                    "shipping_discount": 0,
                                  }
                                },
                              }
                            ],
                            note: "Booking Payment",
                            onSuccess: (Map params) async {
                              print("Payment successful: $params");

                              await CoachAPI.bookCoach(
                                widget.id,
                                startTime! as String,
                                endTime! as String,
                                selectedDate! as String,
                                totalAmount.toDouble(),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
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
                                const SnackBar(
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

  Widget _buildDatePicker() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.calendar_today, color: AppPalettes.primary),
      title: Text(
        selectedDate != null ? 'Selected Date: $selectedDate' : 'Select Date',
        style: TextStyle(
          fontSize: 16,
          color: AppPalettes.accent.withOpacity(0.5),
        ),
      ),
      trailing: const Icon(Icons.keyboard_arrow_down),
      onTap: () => _selectDate(context),
    );
  }

  Widget _buildStartTimePicker() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.access_time, color: AppPalettes.primary),
      title: Text(
        startTime != null ? 'Start Time: $startTime' : 'Select Start Time',
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
        endTime != null ? 'End Time: $endTime' : 'Select End Time',
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
