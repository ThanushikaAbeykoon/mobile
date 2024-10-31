import 'package:flutter/material.dart';
import 'package:playhub/core/api/auth_api.dart';
import 'package:playhub/core/theme/app_pallete.dart';
import 'package:playhub/features/common/auth/presentation/login_screen.dart';
import 'package:playhub/features/common/auth/presentation/widgets/auth_bottom.dart';
import 'package:playhub/features/common/auth/presentation/widgets/auth_button.dart';
import 'package:playhub/features/common/auth/presentation/widgets/auth_field.dart';
import 'package:playhub/features/common/auth/presentation/widgets/auth_header.dart';

class SignUpScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRole;
  final List<String> _roles = ['Customer', 'Coach'];

  // Controllers to capture input field values
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    const emailRegex = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!RegExp(emailRegex).hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters';
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String _getPasswordStrength(String password) {
    if (password.length < 8) return "Weak";
    if (password.length >= 8 && RegExp(r'[A-Z]').hasMatch(password))
      return "Medium";
    if (password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password)) return "Strong";
    return "Very Strong";
  }

  void _handleRegister() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    if (_formKey.currentState!.validate()) {
      try {
        await AuthAPI.register(
          context,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          userRole: _selectedRole as String,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHeader(
                    title: 'Create Account',
                    titleDesc: 'Sign up to get started',
                  ),
                  AuthField(
                    hintText: 'First Name',
                    isObscured: false,
                    controller: _firstNameController,
                  ),
                  const SizedBox(height: 20),
                  AuthField(
                    hintText: 'Last Name',
                    isObscured: false,
                    controller: _lastNameController,
                  ),
                  const SizedBox(height: 20),
                  AuthField(
                    hintText: 'Email',
                    isObscured: false,
                    controller: _emailController,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 20),
                  AuthField(
                    hintText: 'Password',
                    isObscured: true,
                    controller: _passwordController,
                    validator: _validatePassword,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      _getPasswordStrength(_passwordController.text),
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppPalettes.cardForeground,
                      hintText: "Select Role",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0,
                      ),
                    ),
                    dropdownColor: AppPalettes.cardForeground,
                    iconEnabledColor: Colors.white,
                    items: _roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(
                          role,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a role' : null,
                  ),
                  const SizedBox(height: 40),
                  AuthButton(
                    text: 'Register',
                    onPressed: _isLoading ? null : _handleRegister,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 20),
                  AuthBottom(
                    text: 'Already have an account?',
                    onPressed: () {
                      Navigator.push(context, LoginScreen.route());
                    },
                    linkText: 'Login',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
