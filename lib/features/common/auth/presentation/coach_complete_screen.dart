import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playhub/features/common/auth/presentation/widgets/auth_button.dart';
import 'package:playhub/features/common/auth/presentation/widgets/auth_field.dart';

class CoachCompleteScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CoachCompleteScreen(),
      );

  const CoachCompleteScreen({super.key});

  @override
  _CoachCompleteScreenState createState() => _CoachCompleteScreenState();
}

class _CoachCompleteScreenState extends State<CoachCompleteScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to capture input field values
  final TextEditingController _coachIdController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _experienceYearsController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _certificationController =
      TextEditingController();

  // Image picker
  XFile? _profileImage;

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _coachIdController.dispose();
    _specializationController.dispose();
    _experienceYearsController.dispose();
    _bioController.dispose();
    _availabilityController.dispose();
    _ratingController.dispose();
    _certificationController.dispose();
    super.dispose();
  }

  Future<void> _selectProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = image;
    });
  }

  // Function to handle form submission
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Process the submitted data or navigate to the next screen
      // For now, just printing the values
      print("Coach ID: ${_coachIdController.text}");
      print("Specialization: ${_specializationController.text}");
      print("Experience Years: ${_experienceYearsController.text}");
      print("Bio: ${_bioController.text}");
      print("Availability: ${_availabilityController.text}");
      print("Rating: ${_ratingController.text}");
      print("Certification: ${_certificationController.text}");

      // Navigate to a different screen or perform an action based on the form data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _selectProfileImage,
                    child: CircleAvatar(
                      radius: 70, // Changed size from 50 to 70
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _profileImage != null
                          ? FileImage(File(_profileImage!.path))
                          : null,
                      child: _profileImage == null
                          ? const Icon(Icons.camera_alt,
                              size: 50) // Adjusted icon size
                          : null,
                    ),
                  ),
                  const SizedBox(height: 40),
                  AuthField(
                    hintText: 'Coach ID',
                    isObscured: false,
                    controller: _coachIdController,
                  ),
                  const SizedBox(height: 20),
                  AuthField(
                    hintText: 'Specialization',
                    isObscured: false,
                    controller: _specializationController,
                  ),
                  const SizedBox(height: 20),
                  AuthField(
                    hintText: 'Experience Years',
                    isObscured: false,
                    controller: _experienceYearsController,
                  ),
                  const SizedBox(height: 20),
                  AuthField(
                    hintText: 'Bio',
                    isObscured: false,
                    controller: _bioController,
                  ),
                  const SizedBox(height: 20),
                  AuthField(
                    hintText:
                        'Availability (e.g., "Monday - Friday, 9 AM - 5 PM")',
                    isObscured: false,
                    controller: _availabilityController,
                  ),
                  const SizedBox(height: 20),
                  AuthField(
                    hintText: 'Certification (comma separated)',
                    isObscured: false,
                    controller: _certificationController,
                  ),
                  const SizedBox(height: 30),
                  // Submit Button
                  AuthButton(
                    text: 'Submit',
                    onPressed: _handleSubmit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
