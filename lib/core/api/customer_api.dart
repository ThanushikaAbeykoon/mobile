import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:playhub/core/api/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerAPI {
  static Future<Map<String, dynamic>> fetchCustomerById(
      String customerId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    final url = ApiConfig.getBaseUrl('user/customers/$customerId');

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

  static Future<Map<String, dynamic>> AddReview(
    String coachId,
    double rating,
    String review,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');
    final customerId = prefs.getString('_id');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    if (customerId == null) {
      throw Exception('Customer ID not found in SharedPreferences');
    }

    final url = ApiConfig.getBaseUrl('book/add_review');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'rating': rating,
        'review': review,
        'coachId': coachId,
        'customerId': customerId,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add review: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> updateCustomerProfileById(
    Map<String, dynamic> updatedData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');
    final customerId = prefs.getString('_id');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    final url = ApiConfig.getBaseUrl('book/update_profile/$customerId');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update customer profile: ${response.body}');
    }
  }
}
