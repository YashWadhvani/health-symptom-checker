import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'User';

    final features = [
      {
        'title': 'AI Symptom Checker',
        'icon': Icons.medical_services_outlined,
        'color': Colors.teal,
        'route': '/ai',
      },
      {
        'title': 'Symptom History',
        'icon': Icons.history,
        'color': Colors.orangeAccent,
        'route': '/history',
      },
      {
        'title': 'My Profile',
        'icon': Icons.person_outline,
        'color': Colors.blueAccent,
        'route': '/profile',
      },
      {
        'title': 'Nearby Clinics',
        'icon': Icons.location_on,
        'color': Colors.purpleAccent,
        'route': '/clinics',
      },
      {
        'title': 'Emergency Alert',
        'icon': Icons.warning_amber_rounded,
        'color': Colors.redAccent,
        'route': '/emergency',
      },
      {
        'title': 'Privacy Policy',
        'icon': Icons.privacy_tip_outlined,
        'color': Colors.green,
        'route': '/privacy',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Dashboard"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Header
            Text(
              "Welcome, $email 👋",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "How are you feeling today?",
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Grid of Features
            Expanded(
              child: GridView.builder(
                itemCount: features.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final feature = features[index];
                  return GestureDetector(
                    onTap: () {
                      if (feature['route'] == '/emergency') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Emergency alert feature coming soon! 🚨",
                            ),
                          ),
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          feature['route'] as String,
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: (feature['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: feature['color'] as Color,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            feature['icon'] as IconData,
                            color: feature['color'] as Color,
                            size: 40,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            feature['title'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
