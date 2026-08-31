import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'services/profile_store.dart';

void main() {
  runApp(const SessionManagerApp());
}

class SessionManagerApp extends StatelessWidget {
  const SessionManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileStore(),
      child: MaterialApp(
        title: 'Session Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0D0B1A),
          colorScheme: ThemeData.dark().colorScheme.copyWith(
                primary: const Color(0xFF6C4CE0),
              ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF171426),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
