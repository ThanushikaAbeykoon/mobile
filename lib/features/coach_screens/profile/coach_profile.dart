import 'package:flutter/material.dart';
import 'package:playhub/core/api/auth_api.dart';
import 'package:playhub/core/api/coach_api.dart';
import 'package:playhub/core/theme/app_pallete.dart';
import 'package:playhub/features/coach_screens/profile/coach_profile_edit.dart';
import 'package:playhub/features/common/auth/presentation/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoachProfile extends StatefulWidget {
  const CoachProfile({Key? key}) : super(key: key);

  @override
  _CoachProfileState createState() => _CoachProfileState();
}

class _CoachProfileState extends State<CoachProfile> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      final profileData = await AuthAPI.fetchUserProfile();
      setState(() {
        userData = profileData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _showEditProfileModal() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: EditCoachProfile(
            initialData: userData!,
            onSave: (updatedData) async {
              try {
                await CoachAPI.updateCoachProfileById(updatedData);

                setState(() {
                  userData = updatedData;
                });
                Navigator.pop(context);
              } catch (e) {
                // Handle update failure (optional)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update profile: $e')),
                );
              }
            },
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
          'Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppPalettes.accent,
          ),
        ),
        backgroundColor: AppPalettes.primary,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchUserProfile,
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return _buildLoadingScreen();
    }

    if (errorMessage.isNotEmpty) {
      return _buildErrorScreen(errorMessage);
    }

    if (userData == null) {
      return _buildErrorScreen('User data is not available');
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(child: _buildProfileCard()),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _fetchUserProfile,
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return SingleChildScrollView(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: AppPalettes.cardForeground,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    userData!['profile_picture_url'] ??
                        'https://via.placeholder.com/150',
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '${userData!['firstName'][0].toUpperCase()}${userData!['firstName'].substring(1)} ${userData!['lastName'][0].toUpperCase()}${userData!['lastName'].substring(1)}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  userData!['email'] ?? 'N/A',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Phone: ${userData!['phone'] ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Address: ${userData!['address'] ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Preferred Sports: ${userData!['preferred_sports']?.join(', ') ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _showEditProfileModal, // Show the modal sheet
                      style: ElevatedButton.styleFrom(
                        primary: AppPalettes.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await logout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
