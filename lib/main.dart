import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:playhub/core/common/widgets/bottom_navbar.dart';
import 'package:playhub/core/common/widgets/coach_navbar.dart';
import 'package:playhub/core/theme/theme.dart';
import 'package:playhub/features/common/auth/presentation/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  try {
    await dotenv.load(fileName: 'lib/config/.env');

    print('Dotenv loaded successfully: ${dotenv.env}');
  } catch (e) {
    print('Failed to load .env file: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String?> userRole;

  @override
  void initState() {
    super.initState();
    userRole = _checkLoginStatus();
  }

  Future<String?> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('jwt') && prefs.containsKey('role')) {
      return prefs.getString('role');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.lightThemeMode,
      home: FutureBuilder<String?>(
        future: userRole,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            if (snapshot.data == 'Coach') {
              return CoachBottomNavBar();
            } else if (snapshot.data == 'Customer') {
              return BottomNavbar();
            } else {
              return LoginScreen();
            }
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
