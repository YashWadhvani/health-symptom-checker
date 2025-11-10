// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class HealthApiService {
//   final String apiKey =
//       'yo1JiGFHl08lw/GwYg26WA==DX3EZhRQmmrbfthJ'; // 🔑 Replace with your own API key

//   Future<List<dynamic>> fetchPossibleDiseases(String symptom) async {
//     final url = Uri.parse(
//       'https://api.api-ninjas.com/v1/disease?symptoms=$symptom',
//     );

//     final response = await http.get(url, headers: {'X-Api-Key': apiKey});

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data;
//     } else {
//       throw Exception('Failed to fetch data from API');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for fetching health and disease information from external APIs
class HealthApiService {
  // Base URLs for health APIs
  static const String _diseaseApiBase = 'https://disease.sh/v3/covid-19';
  static const String _healthApiBase =
      'https://health.gov/myhealthfinder/api/v3';

  /// Fetch possible diseases based on symptom
  /// This is a mock implementation - replace with actual medical API
  Future<List<dynamic>> fetchPossibleDiseases(String symptom) async {
    try {
      // For demo purposes, returning mock data
      // In production, replace with actual medical API like:
      // - Infermedica API: https://developer.infermedica.com/
      // - API Medic: https://apimedic.com/
      // - Health API: https://health-api.com/

      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      return _getMockDiseaseData(symptom);
    } catch (e) {
      throw Exception('Failed to fetch disease data: $e');
    }
  }

  /// Fetch health recommendations based on symptom
  Future<Map<String, dynamic>> fetchHealthRecommendations(
    String symptom,
  ) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 800));

      return {
        'recommendations': [
          'Stay hydrated and drink plenty of water',
          'Get adequate rest (7-8 hours of sleep)',
          'Monitor your symptoms closely',
          'Consult a doctor if symptoms worsen',
        ],
        'severity': _determineSeverity(symptom),
        'urgency': _determineUrgency(symptom),
      };
    } catch (e) {
      throw Exception('Failed to fetch recommendations: $e');
    }
  }

  /// Fetch nearby clinics (requires Google Maps API key)
  Future<List<dynamic>> fetchNearbyClinics({
    required double latitude,
    required double longitude,
    double radius = 5000, // 5km radius
  }) async {
    // This requires Google Places API key
    // const apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
    // final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
    //     'location=$latitude,$longitude&radius=$radius&type=hospital&key=$apiKey';

    try {
      // For demo, return mock clinic data
      await Future.delayed(const Duration(seconds: 1));

      return [
        {
          'name': 'City General Hospital',
          'address': '123 Main Street',
          'distance': '1.2 km',
          'rating': 4.5,
          'open': true,
        },
        {
          'name': 'Community Health Clinic',
          'address': '456 Park Avenue',
          'distance': '2.5 km',
          'rating': 4.2,
          'open': true,
        },
        {
          'name': 'Emergency Care Center',
          'address': '789 Hospital Road',
          'distance': '3.8 km',
          'rating': 4.7,
          'open': true,
        },
      ];
    } catch (e) {
      throw Exception('Failed to fetch clinics: $e');
    }
  }

  // ==================== Helper Methods ====================

  /// Mock disease data based on symptom
  List<dynamic> _getMockDiseaseData(String symptom) {
    final symptomLower = symptom.toLowerCase();

    // Common symptom mappings
    if (symptomLower.contains('fever') ||
        symptomLower.contains('temperature')) {
      return [
        {
          'name': 'Common Cold',
          'description':
              'A viral infection of the upper respiratory tract. Usually mild and resolves within a week.',
          'severity': 'Low',
          'probability': 0.65,
        },
        {
          'name': 'Influenza (Flu)',
          'description':
              'A respiratory illness caused by influenza viruses. More severe than common cold.',
          'severity': 'Medium',
          'probability': 0.45,
        },
        {
          'name': 'COVID-19',
          'description':
              'Respiratory illness caused by SARS-CoV-2. Can range from mild to severe.',
          'severity': 'Medium',
          'probability': 0.35,
        },
      ];
    } else if (symptomLower.contains('headache') ||
        symptomLower.contains('head')) {
      return [
        {
          'name': 'Tension Headache',
          'description':
              'Most common type of headache, often caused by stress or muscle tension.',
          'severity': 'Low',
          'probability': 0.70,
        },
        {
          'name': 'Migraine',
          'description':
              'Severe recurring headache with throbbing pain, often with sensitivity to light.',
          'severity': 'Medium',
          'probability': 0.40,
        },
        {
          'name': 'Sinus Infection',
          'description':
              'Inflammation of sinuses causing pressure and headache.',
          'severity': 'Low',
          'probability': 0.30,
        },
      ];
    } else if (symptomLower.contains('cough')) {
      return [
        {
          'name': 'Bronchitis',
          'description':
              'Inflammation of the bronchial tubes causing cough and mucus production.',
          'severity': 'Low',
          'probability': 0.55,
        },
        {
          'name': 'Allergies',
          'description':
              'Allergic reaction causing respiratory symptoms including cough.',
          'severity': 'Low',
          'probability': 0.50,
        },
        {
          'name': 'Asthma',
          'description':
              'Chronic condition causing airway inflammation and difficulty breathing.',
          'severity': 'Medium',
          'probability': 0.35,
        },
      ];
    } else if (symptomLower.contains('stomach') ||
        symptomLower.contains('nausea')) {
      return [
        {
          'name': 'Gastroenteritis',
          'description':
              'Inflammation of the digestive tract, often called stomach flu.',
          'severity': 'Low',
          'probability': 0.60,
        },
        {
          'name': 'Food Poisoning',
          'description':
              'Illness caused by consuming contaminated food or beverages.',
          'severity': 'Medium',
          'probability': 0.45,
        },
        {
          'name': 'Indigestion',
          'description': 'Discomfort in upper abdomen, often after eating.',
          'severity': 'Low',
          'probability': 0.40,
        },
      ];
    } else if (symptomLower.contains('chest') ||
        symptomLower.contains('pain')) {
      return [
        {
          'name': 'Muscle Strain',
          'description': 'Overuse or injury to chest muscles causing pain.',
          'severity': 'Low',
          'probability': 0.50,
        },
        {
          'name': 'Acid Reflux (GERD)',
          'description':
              'Stomach acid flowing back into the esophagus causing chest discomfort.',
          'severity': 'Low',
          'probability': 0.45,
        },
        {
          'name': 'Costochondritis',
          'description':
              'Inflammation of cartilage connecting ribs to breastbone.',
          'severity': 'Low',
          'probability': 0.35,
        },
      ];
    } else {
      // Generic symptoms
      return [
        {
          'name': 'General Malaise',
          'description':
              'Non-specific feeling of being unwell. Monitor symptoms and rest.',
          'severity': 'Low',
          'probability': 0.60,
        },
        {
          'name': 'Viral Infection',
          'description':
              'General viral illness affecting the body. Usually resolves with rest.',
          'severity': 'Low',
          'probability': 0.45,
        },
        {
          'name': 'Stress-Related Symptoms',
          'description':
              'Physical symptoms caused by mental or emotional stress.',
          'severity': 'Low',
          'probability': 0.35,
        },
      ];
    }
  }

  /// Determine severity based on symptom
  String _determineSeverity(String symptom) {
    final symptomLower = symptom.toLowerCase();

    if (symptomLower.contains('chest pain') ||
        symptomLower.contains('difficulty breathing') ||
        symptomLower.contains('severe')) {
      return 'High';
    } else if (symptomLower.contains('fever') ||
        symptomLower.contains('persistent')) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }

  /// Determine urgency level
  String _determineUrgency(String symptom) {
    final symptomLower = symptom.toLowerCase();

    if (symptomLower.contains('chest pain') ||
        symptomLower.contains('difficulty breathing') ||
        symptomLower.contains('severe bleeding')) {
      return 'Immediate - Seek emergency care';
    } else if (symptomLower.contains('high fever') ||
        symptomLower.contains('persistent pain')) {
      return 'Soon - See doctor within 24-48 hours';
    } else {
      return 'Routine - Monitor and schedule appointment if worsens';
    }
  }
}
