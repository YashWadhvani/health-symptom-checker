// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class Condition {
//   final String name;
//   final double probability;
//   final String severity;

//   Condition({
//     required this.name,
//     required this.probability,
//     required this.severity,
//   });
// }

// class SymptomApiService {
//   final String appId = "YOUR_APP_ID";
//   final String appKey = "YOUR_APP_KEY";
//   final String baseUrl = "https://api.infermedica.com/v3";

//   Future<List<Condition>> getPossibleConditions(String symptom) async {
//     final url = Uri.parse("$baseUrl/diagnosis");
//     final headers = {
//       'App-Id': appId,
//       'App-Key': appKey,
//       'Content-Type': 'application/json',
//     };

//     final body = jsonEncode({
//       "sex": "female",
//       "age": 21,
//       "evidence": [
//         {"id": symptom, "choice_id": "present"},
//       ],
//     });

//     final response = await http.post(url, headers: headers, body: body);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final List<Condition> conditions = [];

//       for (var condition in data["conditions"]) {
//         final prob = (condition["probability"] as num).toDouble();
//         String severity = prob > 0.7
//             ? "High"
//             : prob > 0.4
//             ? "Medium"
//             : "Low";
//         conditions.add(
//           Condition(
//             name: condition['name'],
//             probability: prob,
//             severity: severity,
//           ),
//         );
//       }
//       return conditions;
//     } else {
//       throw Exception("Failed to fetch conditions");
//     }
//   }
// }

import '../models/symptom_model.dart';

/// Service for analyzing symptoms and getting possible conditions
class SymptomApiService {
  /// Get possible conditions based on symptom analysis
  Future<List<Condition>> getPossibleConditions(String symptom) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1200));

      // Analyze symptom and return conditions
      return _analyzeSymptom(symptom);
    } catch (e) {
      throw Exception('Failed to analyze symptom: $e');
    }
  }

  /// Analyze symptom and return detailed condition list
  List<Condition> _analyzeSymptom(String symptom) {
    final symptomLower = symptom.toLowerCase().trim();

    // Fever-related symptoms
    if (symptomLower.contains('fever') ||
        symptomLower.contains('temperature')) {
      return [
        Condition(
          name: 'Viral Infection',
          severity: 'Medium',
          probability: 0.72,
          description:
              'Common viral infection causing fever and general malaise',
          recommendations: [
            'Rest and stay hydrated',
            'Take fever-reducing medication (acetaminophen/ibuprofen)',
            'Monitor temperature every 4 hours',
            'Seek medical care if fever exceeds 103°F (39.4°C)',
          ],
        ),
        Condition(
          name: 'Influenza',
          severity: 'Medium',
          probability: 0.58,
          description: 'Seasonal flu with fever, body aches, and fatigue',
          recommendations: [
            'Get plenty of rest',
            'Drink fluids to prevent dehydration',
            'Consider antiviral medication within 48 hours',
            'Isolate to prevent spreading',
          ],
        ),
        Condition(
          name: 'Bacterial Infection',
          severity: 'High',
          probability: 0.35,
          description: 'Bacterial infection requiring antibiotic treatment',
          recommendations: [
            'Consult doctor for proper diagnosis',
            'May require antibiotics',
            'Complete full course of medication if prescribed',
          ],
        ),
      ];
    }
    // Headache-related symptoms
    else if (symptomLower.contains('headache') ||
        symptomLower.contains('head pain')) {
      return [
        Condition(
          name: 'Tension Headache',
          severity: 'Low',
          probability: 0.78,
          description:
              'Stress or muscle tension causing dull, aching head pain',
          recommendations: [
            'Apply cold or warm compress',
            'Practice relaxation techniques',
            'Over-the-counter pain relievers',
            'Reduce stress and get adequate sleep',
          ],
        ),
        Condition(
          name: 'Migraine',
          severity: 'Medium',
          probability: 0.48,
          description:
              'Severe throbbing headache, often one-sided with sensitivity to light',
          recommendations: [
            'Rest in a quiet, dark room',
            'Avoid triggers (certain foods, stress, lack of sleep)',
            'Prescribed migraine medications',
            'Keep a headache diary',
          ],
        ),
        Condition(
          name: 'Dehydration',
          severity: 'Low',
          probability: 0.42,
          description: 'Insufficient fluid intake causing headache',
          recommendations: [
            'Drink water immediately',
            'Aim for 8 glasses of water daily',
            'Avoid excessive caffeine and alcohol',
          ],
        ),
      ];
    }
    // Cough-related symptoms
    else if (symptomLower.contains('cough')) {
      return [
        Condition(
          name: 'Upper Respiratory Infection',
          severity: 'Low',
          probability: 0.68,
          description: 'Common cold or viral infection affecting airways',
          recommendations: [
            'Rest and drink warm fluids',
            'Use honey to soothe throat (if over 1 year old)',
            'Humidifier to moisten air',
            'Avoid irritants and smoking',
          ],
        ),
        Condition(
          name: 'Bronchitis',
          severity: 'Medium',
          probability: 0.52,
          description: 'Inflammation of bronchial tubes with persistent cough',
          recommendations: [
            'Rest and increase fluid intake',
            'Use a humidifier',
            'Avoid smoke and air pollution',
            'See doctor if cough persists beyond 3 weeks',
          ],
        ),
        Condition(
          name: 'Allergic Reaction',
          severity: 'Low',
          probability: 0.45,
          description: 'Allergies causing respiratory irritation and cough',
          recommendations: [
            'Identify and avoid allergens',
            'Antihistamines may help',
            'Keep windows closed during high pollen days',
            'Use air purifier indoors',
          ],
        ),
      ];
    }
    // Stomach/Digestive symptoms
    else if (symptomLower.contains('stomach') ||
        symptomLower.contains('nausea') ||
        symptomLower.contains('vomit')) {
      return [
        Condition(
          name: 'Gastroenteritis',
          severity: 'Medium',
          probability: 0.65,
          description: 'Stomach flu causing nausea, vomiting, and diarrhea',
          recommendations: [
            'Stay hydrated with clear fluids',
            'BRAT diet (Bananas, Rice, Applesauce, Toast)',
            'Rest and avoid solid foods initially',
            'Seek care if unable to keep fluids down',
          ],
        ),
        Condition(
          name: 'Food Poisoning',
          severity: 'Medium',
          probability: 0.55,
          description: 'Illness from contaminated food or beverages',
          recommendations: [
            'Hydration is crucial',
            'Rest and let symptoms pass',
            'Avoid dairy and fatty foods',
            'See doctor if symptoms severe or persistent',
          ],
        ),
        Condition(
          name: 'Acid Reflux',
          severity: 'Low',
          probability: 0.38,
          description: 'Stomach acid backing up into esophagus',
          recommendations: [
            'Avoid trigger foods (spicy, fatty, acidic)',
            'Eat smaller meals',
            'Don\'t lie down immediately after eating',
            'Elevate head while sleeping',
          ],
        ),
      ];
    }
    // Chest pain symptoms
    else if (symptomLower.contains('chest') && symptomLower.contains('pain')) {
      return [
        Condition(
          name: 'Muscle Strain',
          severity: 'Low',
          probability: 0.55,
          description: 'Chest wall pain from muscle overuse or injury',
          recommendations: [
            'Rest and avoid strenuous activities',
            'Apply ice for first 48 hours',
            'Over-the-counter pain relievers',
            'Gentle stretching after acute phase',
          ],
        ),
        Condition(
          name: 'Costochondritis',
          severity: 'Low',
          probability: 0.42,
          description:
              'Inflammation of cartilage connecting ribs to breastbone',
          recommendations: [
            'Rest and avoid aggravating movements',
            'Anti-inflammatory medication',
            'Heat or ice application',
          ],
        ),
        Condition(
          name: 'Cardiac Issue',
          severity: 'High',
          probability: 0.25,
          description:
              'Possible heart-related condition requiring immediate evaluation',
          recommendations: [
            '⚠️ SEEK IMMEDIATE MEDICAL ATTENTION',
            'Call emergency services if accompanied by:',
            '- Shortness of breath',
            '- Pain radiating to arm/jaw',
            '- Dizziness or sweating',
          ],
        ),
      ];
    }
    // Fatigue/Tiredness
    else if (symptomLower.contains('tired') ||
        symptomLower.contains('fatigue') ||
        symptomLower.contains('weak')) {
      return [
        Condition(
          name: 'Sleep Deprivation',
          severity: 'Low',
          probability: 0.70,
          description: 'Insufficient sleep causing fatigue and low energy',
          recommendations: [
            'Aim for 7-9 hours of sleep nightly',
            'Establish consistent sleep schedule',
            'Avoid screens before bedtime',
            'Create comfortable sleep environment',
          ],
        ),
        Condition(
          name: 'Anemia',
          severity: 'Medium',
          probability: 0.45,
          description: 'Low red blood cell count causing fatigue',
          recommendations: [
            'Blood test to confirm diagnosis',
            'Iron-rich foods or supplements',
            'Vitamin B12 and folate intake',
            'Follow up with healthcare provider',
          ],
        ),
        Condition(
          name: 'Chronic Fatigue',
          severity: 'Medium',
          probability: 0.32,
          description: 'Persistent fatigue lasting more than 6 months',
          recommendations: [
            'Comprehensive medical evaluation needed',
            'Rule out underlying conditions',
            'Paced activity management',
            'Stress reduction techniques',
          ],
        ),
      ];
    }
    // Sore throat
    else if (symptomLower.contains('throat') || symptomLower.contains('sore')) {
      return [
        Condition(
          name: 'Viral Pharyngitis',
          severity: 'Low',
          probability: 0.75,
          description: 'Viral infection causing sore throat',
          recommendations: [
            'Gargle with warm salt water',
            'Drink warm liquids',
            'Throat lozenges for comfort',
            'Rest your voice',
          ],
        ),
        Condition(
          name: 'Strep Throat',
          severity: 'Medium',
          probability: 0.40,
          description: 'Bacterial infection requiring antibiotics',
          recommendations: [
            'See doctor for throat culture',
            'Antibiotics if confirmed',
            'Complete full course of medication',
            'Replace toothbrush after starting treatment',
          ],
        ),
        Condition(
          name: 'Tonsillitis',
          severity: 'Medium',
          probability: 0.35,
          description: 'Inflammation of tonsils with pain and swelling',
          recommendations: [
            'Rest and hydrate',
            'Pain relievers as needed',
            'Warm compresses on neck',
            'See doctor if severe or persistent',
          ],
        ),
      ];
    }
    // Default/Generic symptoms
    else {
      return [
        Condition(
          name: 'General Malaise',
          severity: 'Low',
          probability: 0.60,
          description: 'Non-specific feeling of discomfort or unease',
          recommendations: [
            'Monitor your symptoms',
            'Get adequate rest',
            'Stay hydrated',
            'See doctor if symptoms worsen or persist',
          ],
        ),
        Condition(
          name: 'Stress Response',
          severity: 'Low',
          probability: 0.45,
          description:
              'Physical symptoms related to mental or emotional stress',
          recommendations: [
            'Practice stress management techniques',
            'Regular exercise',
            'Adequate sleep',
            'Consider counseling if stress is overwhelming',
          ],
        ),
        Condition(
          name: 'Viral Syndrome',
          severity: 'Low',
          probability: 0.38,
          description: 'General viral illness with various symptoms',
          recommendations: [
            'Rest and fluids',
            'Over-the-counter symptom relief',
            'Monitor for worsening symptoms',
            'Consult doctor if no improvement in 7-10 days',
          ],
        ),
      ];
    }
  }

  /// Get severity level for a symptom
  String getSeverityLevel(String symptom) {
    final conditions = _analyzeSymptom(symptom);
    if (conditions.isEmpty) return 'Low';

    // Find highest severity
    bool hasHigh = conditions.any((c) => c.severity == 'High');
    bool hasMedium = conditions.any((c) => c.severity == 'Medium');

    if (hasHigh) return 'High';
    if (hasMedium) return 'Medium';
    return 'Low';
  }

  /// Check if symptom requires urgent care
  bool requiresUrgentCare(String symptom) {
    final symptomLower = symptom.toLowerCase();

    final urgentKeywords = [
      'chest pain',
      'difficulty breathing',
      'severe bleeding',
      'loss of consciousness',
      'severe head injury',
      'sudden weakness',
      'confusion',
      'seizure',
    ];

    return urgentKeywords.any((keyword) => symptomLower.contains(keyword));
  }
}
