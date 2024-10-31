import 'package:flutter/material.dart';
import 'package:playhub/core/api/auth_api.dart';
import 'package:playhub/core/theme/app_pallete.dart';
import 'package:playhub/features/common/auth/presentation/signup_screen.dart';
import 'package:playhub/features/common/auth/presentation/widgets/auth_bottom.dart';
import 'package:playhub/features/common/auth/presentation/widgets/auth_button.dart';
import 'package:playhub/features/common/auth/presentation/widgets/auth_field.dart';
import 'package:playhub/features/common/auth/presentation/widgets/auth_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => LoginScreen(),
      );

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  Future<void> _handleLogin(BuildContext context) async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text;
    final String password = _passwordController.text;

    await AuthAPI.login(context, email, password);

    setState(() {
      _isLoading = false;
    });
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
                  AuthHeader(
                    title: "Welcome Back",
                    titleDesc: 'Login to your account',
                  ),
                  AuthField(
                    hintText: 'Email',
                    isObscured: false,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AuthField(
                    hintText: 'Password',
                    isObscured: !_isPasswordVisible,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey[400],
                        size: 18.0,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text(
                        'Remember Me',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Forgot password logic
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: AppPalettes.accent,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  AuthButton(
                    text: 'Login',
                    onPressed: _isLoading
                        ? null
                        : () {
                            _handleLogin(context);
                          },
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 20),
                  AuthBottom(
                    text: "Don't have an account?",
                    linkText: 'Sign Up',
                    onPressed: () {
                      Navigator.push(
                        context,
                        SignUpScreen.route(),
                      );
                    },
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
