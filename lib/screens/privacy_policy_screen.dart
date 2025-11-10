// import 'package:flutter/material.dart';

// class PrivacyPolicyScreen extends StatelessWidget {
//   const PrivacyPolicyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Privacy Policy'),
//         backgroundColor: Colors.teal,
//       ),
//       body: const SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Privacy Policy',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Last updated: November 2025',
//               style: TextStyle(color: Colors.grey),
//             ),
//             SizedBox(height: 24),
//             Text(
//               'Information We Collect',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               '• Personal Information (email, name)\n'
//               '• Health Information (symptoms, medical history)\n'
//               '• Device Information\n'
//               '• Usage Data',
//             ),
//             SizedBox(height: 24),
//             Text(
//               'How We Use Your Information',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'We use the collected information for:\n\n'
//               '• Providing health recommendations\n'
//               '• Improving our services\n'
//               '• Communicating with you\n'
//               '• Ensuring app security',
//             ),
//             SizedBox(height: 24),
//             Text(
//               'Data Security',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'We implement industry-standard security measures to protect your data. All health information is encrypted and stored securely.',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

/// Privacy Policy Screen displaying app's privacy terms
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                color: Colors.teal.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.withAlpha((0.3 * 255).round())),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    size: 60,
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your Privacy Matters',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated: ${DateTime.now().year}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Introduction
            _buildSection(
              icon: Icons.info_outline,
              title: 'Introduction',
              content:
                  'Welcome to Health Symptom Checker. We are committed to protecting your personal information and your right to privacy. This Privacy Policy explains how we collect, use, and share your information when you use our app.',
            ),

            _buildSection(
              icon: Icons.collections_bookmark_outlined,
              title: 'Information We Collect',
              content:
                  'We collect the following types of information:\n\n'
                  '• Personal Information: Name, email address, age, and medical history that you provide\n'
                  '• Health Data: Symptoms, conditions, and health reports you log in the app\n'
                  '• Location Data: GPS location for finding nearby clinics (only when you grant permission)\n'
                  '• Usage Data: How you interact with the app to improve our services',
            ),

            _buildSection(
              icon: Icons.security_outlined,
              title: 'How We Use Your Information',
              content:
                  'Your information is used to:\n\n'
                  '• Provide personalized symptom analysis and health recommendations\n'
                  '• Store and display your symptom history\n'
                  '• Locate nearby healthcare facilities\n'
                  '• Improve app functionality and user experience\n'
                  '• Send important notifications about your health',
            ),

            _buildSection(
              icon: Icons.lock_outline,
              title: 'Data Security',
              content:
                  'We take your security seriously:\n\n'
                  '• All data is encrypted using industry-standard protocols\n'
                  '• Stored securely in Firebase Cloud with authentication\n'
                  '• Only you can access your personal health data\n'
                  '• We never sell your data to third parties\n'
                  '• Regular security audits and updates',
            ),

            _buildSection(
              icon: Icons.share_outlined,
              title: 'Data Sharing',
              content:
                  'We do NOT share your personal health information with third parties, except:\n\n'
                  '• When required by law or legal process\n'
                  '• With your explicit consent\n'
                  '• For emergency medical services (only in critical situations)\n'
                  '• With service providers who help operate the app (under strict confidentiality)',
            ),

            _buildSection(
              icon: Icons.verified_user_outlined,
              title: 'Your Rights',
              content:
                  'You have the right to:\n\n'
                  '• Access your personal data at any time\n'
                  '• Update or correct your information\n'
                  '• Delete your account and all associated data\n'
                  '• Export your health records\n'
                  '• Opt-out of location tracking\n'
                  '• Withdraw consent for data processing',
            ),

            _buildSection(
              icon: Icons.child_care_outlined,
              title: 'Children\'s Privacy',
              content:
                  'Our app is not intended for children under 13 years of age. We do not knowingly collect personal information from children. If you are a parent or guardian and believe your child has provided us with information, please contact us immediately.',
            ),

            _buildSection(
              icon: Icons.cookie_outlined,
              title: 'Cookies and Tracking',
              content:
                  'We use minimal tracking technologies to:\n\n'
                  '• Remember your login session\n'
                  '• Analyze app performance\n'
                  '• Improve user experience\n\n'
                  'You can disable tracking in your device settings.',
            ),

            _buildSection(
              icon: Icons.update_outlined,
              title: 'Policy Updates',
              content:
                  'We may update this Privacy Policy from time to time. We will notify you of any significant changes via email or in-app notification. Continued use of the app after changes constitutes acceptance of the updated policy.',
            ),

            _buildSection(
              icon: Icons.contact_support_outlined,
              title: 'Contact Us',
              content:
                  'If you have questions about this Privacy Policy or your data, please contact us:\n\n'
                  '📧 Email: privacy@healthsymptomchecker.com\n'
                  '📱 Phone: +1 (555) 123-4567\n'
                  '🏢 Address: 123 Health Street, Medical City, HC 12345',
            ),

            const SizedBox(height: 24),

            // Footer Actions
            Card(
              elevation: 0,
              color: Colors.teal.withAlpha((0.1 * 255).round()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Need Help?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'If you have concerns about your privacy or data, we\'re here to help.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Opening support email...'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.email_outlined),
                            label: const Text('Email Us'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.teal,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showDeleteAccountDialog(context);
                            },
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Delete Data'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                            color: Colors.teal.withAlpha((0.1 * 255).round()),
                            borderRadius: BorderRadius.circular(8),
                          ),
                    child: Icon(icon, color: Colors.teal, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Account?'),
          ],
        ),
        content: const Text(
          'This will permanently delete all your health data, symptom history, and account information. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Account deletion requested. Please contact support to complete this process.',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
