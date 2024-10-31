import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:playhub/core/api/api_config.dart';
import 'package:playhub/core/common/widgets/bottom_navbar.dart';
import 'package:playhub/core/common/widgets/coach_navbar.dart';
import 'package:playhub/features/common/auth/presentation/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthAPI {
  static Future<void> login(
      BuildContext context, String email, String password) async {
    final url = ApiConfig.getBaseUrl('user/login/');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        String token = data['token'];
        String _id = data['_id'];
        String role = data['role'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt', token);
        await prefs.setString('_id', _id);
        await prefs.setString('role', role);

        print(
            "Login successful: ${data['message']}, token: $token, id: $_id, role: $role");

        if (role == 'Customer') {
          Navigator.pushReplacement(context, BottomNavbar.route());
        } else if (role == 'Coach') {
          Navigator.pushReplacement(context, CoachBottomNavBar.route());
        } else {
          _showError(context, "Invalid user role: $role");
        }
      } else {
        _showError(context, "Login failed: ${response.body}");
      }
    } catch (error) {
      _showError(context, "An error occurred during login: $error");
    }
  }

  static Future<void> register(
    BuildContext context, {
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String userRole,
  }) async {
    final url = ApiConfig.getBaseUrl('user/register/');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": password,
          "userRole": userRole,
        }),
      );

      if (response.statusCode == 200) {
        print("User registered successfully!");
        Navigator.push(context, LoginScreen.route());
      } else if (response.statusCode == 400) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['error'] == 'email_already_registered') {
          _showError(
              context, "This email is already registered. Please use another.");
        } else {
          _showError(context, "Failed to register: ${responseBody['message']}");
        }
      } else {
        _showError(context, "Failed to register: ${response.body}");
      }
    } catch (error) {
      _showError(context, "An error occurred during registration: $error");
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  static Future<Map<String, dynamic>?> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');

    if (token == null) {
      throw Exception('No token found, please log in.');
    }

    final url = ApiConfig.getBaseUrl('user/profile');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user data.');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
