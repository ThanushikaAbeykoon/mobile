import 'package:flutter/material.dart';
import 'package:playhub/core/common/widgets/custom_button.dart';
import 'package:playhub/core/theme/app_pallete.dart';

class EditCoachProfile extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSave;

  const EditCoachProfile({
    Key? key,
    required this.initialData,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditCoachProfileState createState() => _EditCoachProfileState();
}

class _EditCoachProfileState extends State<EditCoachProfile> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String phone;
  late String address;
  late List<String> preferredSports;
  late String profilePictureUrl;
  late String specialization;
  late int experienceYears;
  late String bio;
  late bool availability;
  late List<String> certification;
  late double price;

  @override
  void initState() {
    super.initState();
    firstName = widget.initialData['firstName'];
    lastName = widget.initialData['lastName'];
    phone = widget.initialData['phone'] ?? '';
    address = widget.initialData['address'] ?? '';
    preferredSports =
        List<String>.from(widget.initialData['preferredSports'] ?? []);
    profilePictureUrl = widget.initialData['profilePictureUrl'] ?? '';
    specialization = widget.initialData['specialization'] ?? '';
    experienceYears = widget.initialData['experience_years'] ?? 0;
    bio = widget.initialData['bio'] ?? '';
    availability = widget.initialData['availability'] ?? false;
    certification =
        List<String>.from(widget.initialData['certification'] ?? []);
    price = widget.initialData['price']?.toDouble() ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        color: AppPalettes.foreground,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                // First Name
                _buildTextFormField(
                  label: 'First Name',
                  initialValue: firstName,
                  onChanged: (value) => firstName = value,
                  validator: (value) =>
                      value!.isEmpty ? 'First name is required' : null,
                ),
                const SizedBox(height: 12),
                // Last Name
                _buildTextFormField(
                  label: 'Last Name',
                  initialValue: lastName,
                  onChanged: (value) => lastName = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Last name is required' : null,
                ),
                const SizedBox(height: 12),
                // Phone
                _buildTextFormField(
                  label: 'Phone',
                  initialValue: phone,
                  onChanged: (value) => phone = value,
                ),
                const SizedBox(height: 12),
                // Address
                _buildTextFormField(
                  label: 'Address',
                  initialValue: address,
                  onChanged: (value) => address = value,
                ),
                const SizedBox(height: 12),
                // Profile Picture URL
                _buildTextFormField(
                  label: 'Profile Picture URL',
                  initialValue: profilePictureUrl,
                  onChanged: (value) => profilePictureUrl = value,
                ),
                const SizedBox(height: 12),
                // Preferred Sports
                _buildTextFormField(
                  label: 'Preferred Sports (comma separated)',
                  initialValue: preferredSports.join(', '),
                  onChanged: (value) => preferredSports =
                      value.split(',').map((sport) => sport.trim()).toList(),
                ),
                const SizedBox(height: 12),
                // Specialization
                _buildTextFormField(
                  label: 'Specialization',
                  initialValue: specialization,
                  onChanged: (value) => specialization = value,
                ),
                const SizedBox(height: 12),
                // Experience Years
                _buildTextFormField(
                  label: 'Experience (Years)',
                  initialValue: experienceYears.toString(),
                  onChanged: (value) =>
                      experienceYears = int.tryParse(value) ?? 0,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                // Bio
                _buildTextFormField(
                  label: 'Bio',
                  initialValue: bio,
                  onChanged: (value) => bio = value,
                ),
                const SizedBox(height: 12),
                // Availability (Checkbox)
                Row(
                  children: [
                    Checkbox(
                      value: availability,
                      onChanged: (value) {
                        setState(() {
                          availability = value ?? false;
                        });
                      },
                    ),
                    const Text('Availability'),
                  ],
                ),
                const SizedBox(height: 12),
                // Certification
                _buildTextFormField(
                  label: 'Certifications (comma separated)',
                  initialValue: certification.join(', '),
                  onChanged: (value) => certification =
                      value.split(',').map((cert) => cert.trim()).toList(),
                ),
                const SizedBox(height: 12),
                // Price
                _buildTextFormField(
                  label: 'Price per Session',
                  initialValue: price.toString(),
                  onChanged: (value) => price = double.tryParse(value) ?? 0.0,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onSave({
                          'firstName': firstName,
                          'lastName': lastName,
                          'phone': phone,
                          'address': address,
                          'preferredSports': preferredSports,
                          'profilePictureUrl': profilePictureUrl,
                          'specialization': specialization,
                          'experience_years': experienceYears,
                          'bio': bio,
                          'availability': availability,
                          'certification': certification,
                          'price': price,
                        });
                      }
                    },
                    text: 'Save')
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
      ),
      style: TextStyle(color: Colors.white),
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
