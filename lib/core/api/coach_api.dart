import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:playhub/core/api/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoachAPI {
  static Future<List<dynamic>> fetchCoach() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    final url = ApiConfig.getBaseUrl('user/coaches');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load arenas');
    }
  }

  static Future<Map<String, dynamic>> fetchCoachById(String coachId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    final url = ApiConfig.getBaseUrl('user/coaches/$coachId');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load coach');
    }
  }

  static Future<void> bookCoach(
    String coachId,
    String startTime,
    String endTime,
    String bookingDate,
    double totalCost,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');
    final customerId = prefs.getString('_id');

    debugPrint('Customer ID: $customerId');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    final url = ApiConfig.getBaseUrl('book/book_coach');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'customerId': customerId,
        'coachId': coachId,
        'bookingDate': bookingDate,
        'startTime': startTime,
        'endTime': endTime,
        'status': 'confirmed',
        'totalCost': totalCost,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error booking coach: ${response.body}');
    }
  }

  static Future<List<dynamic>> fetchCoachReviews(String coachId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    final url = ApiConfig.getBaseUrl('user/coach_reviews/$coachId');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load coach reviews');
    }
  }

  static Future<List<dynamic>> fetchCoachBookingsByCoachId(
      String coachId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    final url = ApiConfig.getBaseUrl('user/coach/bookings/$coachId');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load coach bookings');
    }
  }

  static Future<List<dynamic>> GetAllCoachBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');
    final coachId = prefs.getString('_id');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    final url = ApiConfig.getBaseUrl('coach/get_bookings/$coachId');

    print('URL: $url');
    print('Token: $token');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');
      return json.decode(response.body);
    } else {
      print('Failed Response: ${response.body}');
      throw Exception('Failed to load coach bookings');
    }
  }

  static Future<Map<String, dynamic>> updateCoachProfileById(
    Map<String, dynamic> updatedData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');
    final String? coachId = prefs.getString('_id');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    if (coachId == null) {
      throw Exception('No coach ID found');
    }

    final url = ApiConfig.getBaseUrl('coach/update_profile/$coachId');

    print('URL: $url');
    print('Token: $token');
    print('Updated Data: $updatedData');

    updatedData = updatedData.map((key, value) {
      if (value is String && value.isEmpty) return MapEntry(key, null);
      if (value is List && value.isEmpty) return MapEntry(key, null);
      return MapEntry(key, value);
    });
    updatedData.removeWhere((key, value) => value == null);

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedData),
    );

    print('Request Body: ${json.encode(updatedData)}');
    if (response.statusCode != 200) {
      print('Error Response Headers: ${response.headers}');
      print('Error Response Body: ${response.body}');
      throw Exception(
          'Failed to update coach profile: ${response.statusCode} - ${response.body}');
    }

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update coach profile: ${response.body}');
    }
  }
}
