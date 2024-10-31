import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:playhub/core/api/api_config.dart';

class ArenaAPI {
  static Future<List<dynamic>> fetchArenas() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    final url = ApiConfig.getBaseUrl('arena/');

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

  static Future<void> bookArena(
    String arenaId,
    String startTime,
    String endTime,
    double totalCost,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');
    final customerId = prefs.getString('_id');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    final url = ApiConfig.getBaseUrl('book/book_arena');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'customerId': customerId,
        'arenaId': arenaId,
        'bookingDate': DateTime.now().toIso8601String().split('T').first,
        'startTime': startTime,
        'endTime': endTime,
        'status': 'confirmed',
        'totalCost': totalCost,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error booking arena: ${response.body}');
    }
  }

  static Future<List<dynamic>> fetchArenasByUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    final url = ApiConfig.getBaseUrl('book/get_customer_bookings');

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

  static Future<List<dynamic>> fetchCoachesByUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    final url = ApiConfig.getBaseUrl('book/get_coach_bookings');

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
}
