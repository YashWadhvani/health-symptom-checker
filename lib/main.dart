import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart'; // Generated via flutterfire configure

// Screens
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/ai_symptom_analysis_screen.dart';
import 'screens/symptom_history_screen.dart';
import 'screens/symptom_input_screen.dart';
import 'screens/dashboard.dart';
import 'screens/nearby_clinics_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/symptom_search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Health Symptom Checker',
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(
  //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
  //       useMaterial3: true,
  //       scaffoldBackgroundColor: Colors.white,
  //       appBarTheme: const AppBarTheme(
  //         backgroundColor: Colors.teal,
  //         foregroundColor: Colors.white,
  //         elevation: 0,
  //       ),
  //       elevatedButtonTheme: ElevatedButtonThemeData(
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.teal,
  //           foregroundColor: Colors.white,
  //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //         ),
  //       ),
  //       inputDecorationTheme: InputDecorationTheme(
  //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //         filled: true,
  //         fillColor: Colors.grey[100],
  //       ),
  //     ),
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Symptom Checker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
      home: const AuthGate(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/history': (context) => const SymptomHistoryScreen(),
        '/ai': (context) => const AISymptomAnalysisScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/symptom': (context) => const SymptomInputScreen(),
        '/clinics': (context) => const NearbyClinicsScreen(),
        '/privacy': (context) => const PrivacyPolicyScreen(),
        '/symptom/search': (context) => const SymptomSearchScreen(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return DashboardScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
