import 'package:flutter/material.dart';
import 'screens/ai_symptom_analysis_screen.dart';
import 'screens/dashboard.dart';
import 'screens/health_report_screen.dart';
import 'screens/login_screen.dart';
import 'screens/nearby_clinics_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/symptom_history_screen.dart';
import 'screens/symptom_input_screen.dart';
import 'screens/symptom_screen.dart';
import 'screens/symptom_search_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const DashboardScreen(),
  '/login': (context) => const LoginScreen(),
  '/signup': (context) => const SignupScreen(),
  '/ai': (context) => const AISymptomAnalysisScreen(),
  '/history': (context) => const SymptomHistoryScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/clinics': (context) => const NearbyClinicsScreen(),
  '/privacy': (context) => const PrivacyPolicyScreen(),
  '/symptom': (context) => const SymptomScreen(),
  '/symptom/input': (context) => const SymptomInputScreen(),
  '/symptom/search': (context) => const SymptomSearchScreen(),
};
