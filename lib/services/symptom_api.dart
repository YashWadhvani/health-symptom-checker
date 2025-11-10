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
        Condition(
          name: 'COVID-19',
          severity: 'Medium',
          probability: 0.42,
          description: 'Coronavirus infection with fever as common symptom',
          recommendations: [
            'Get tested for COVID-19',
            'Self-isolate until test results',
            'Monitor oxygen levels if available',
            'Seek care if breathing difficulty develops',
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
        Condition(
          name: 'Sinus Headache',
          severity: 'Low',
          probability: 0.38,
          description: 'Headache from sinus pressure or infection',
          recommendations: [
            'Use saline nasal spray',
            'Apply warm compress to face',
            'Steam inhalation',
            'Decongestants may help',
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
        Condition(
          name: 'Asthma',
          severity: 'Medium',
          probability: 0.35,
          description: 'Chronic condition causing airway inflammation',
          recommendations: [
            'Use prescribed inhaler',
            'Avoid triggers (smoke, cold air, exercise)',
            'Keep rescue inhaler accessible',
            'Develop action plan with doctor',
          ],
        ),
      ];
    }
    // Stomach/Digestive symptoms
    else if (symptomLower.contains('stomach') ||
        symptomLower.contains('nausea') ||
        symptomLower.contains('vomit') ||
        symptomLower.contains('diarrhea') ||
        symptomLower.contains('abdominal')) {
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
        Condition(
          name: 'Irritable Bowel Syndrome',
          severity: 'Medium',
          probability: 0.33,
          description:
              'Chronic digestive disorder with cramping and bowel changes',
          recommendations: [
            'Keep food diary to identify triggers',
            'Manage stress levels',
            'Regular exercise',
            'Consider low-FODMAP diet',
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
        Condition(
          name: 'Anxiety/Panic Attack',
          severity: 'Low',
          probability: 0.30,
          description: 'Stress-induced chest tightness or pain',
          recommendations: [
            'Practice deep breathing',
            'Remove yourself from stressful situation',
            'Seek mental health support',
            'Rule out cardiac causes first',
          ],
        ),
      ];
    }
    // Fatigue/Tiredness
    else if (symptomLower.contains('tired') ||
        symptomLower.contains('fatigue') ||
        symptomLower.contains('weak') ||
        symptomLower.contains('exhausted')) {
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
        Condition(
          name: 'Thyroid Disorder',
          severity: 'Medium',
          probability: 0.28,
          description: 'Underactive thyroid causing fatigue and sluggishness',
          recommendations: [
            'Get thyroid function tests',
            'Thyroid hormone replacement if needed',
            'Regular monitoring',
            'Maintain healthy diet',
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
        Condition(
          name: 'Laryngitis',
          severity: 'Low',
          probability: 0.32,
          description: 'Voice box inflammation causing hoarseness',
          recommendations: [
            'Rest your voice completely',
            'Avoid whispering (strains vocal cords)',
            'Use humidifier',
            'Stay hydrated',
          ],
        ),
      ];
    }
    // Dizziness/Vertigo
    else if (symptomLower.contains('dizzy') ||
        symptomLower.contains('vertigo') ||
        symptomLower.contains('lightheaded')) {
      return [
        Condition(
          name: 'Benign Positional Vertigo',
          severity: 'Low',
          probability: 0.62,
          description: 'Inner ear issue causing spinning sensation',
          recommendations: [
            'Avoid sudden head movements',
            'Epley maneuver (ask doctor)',
            'Stay hydrated',
            'Sit down when dizzy',
          ],
        ),
        Condition(
          name: 'Dehydration',
          severity: 'Low',
          probability: 0.55,
          description: 'Fluid loss causing dizziness',
          recommendations: [
            'Drink water slowly',
            'Electrolyte drinks',
            'Avoid caffeine and alcohol',
            'Rest in cool environment',
          ],
        ),
        Condition(
          name: 'Low Blood Pressure',
          severity: 'Medium',
          probability: 0.38,
          description: 'Hypotension causing lightheadedness',
          recommendations: [
            'Stand up slowly from sitting/lying',
            'Increase salt intake (if approved by doctor)',
            'Wear compression stockings',
            'Monitor blood pressure regularly',
          ],
        ),
        Condition(
          name: 'Inner Ear Infection',
          severity: 'Medium',
          probability: 0.35,
          description: 'Infection affecting balance and causing dizziness',
          recommendations: [
            'See doctor for evaluation',
            'May need antibiotics',
            'Avoid driving until resolved',
            'Balance exercises after recovery',
          ],
        ),
      ];
    }
    // Back pain
    else if (symptomLower.contains('back') && symptomLower.contains('pain')) {
      return [
        Condition(
          name: 'Muscle Strain',
          severity: 'Low',
          probability: 0.72,
          description: 'Overuse or injury causing back muscle pain',
          recommendations: [
            'Rest for first 24-48 hours',
            'Apply ice, then heat after 48 hours',
            'Over-the-counter pain relievers',
            'Gentle stretching and movement',
          ],
        ),
        Condition(
          name: 'Poor Posture',
          severity: 'Low',
          probability: 0.58,
          description: 'Chronic bad posture leading to back discomfort',
          recommendations: [
            'Ergonomic workspace setup',
            'Core strengthening exercises',
            'Take breaks from sitting',
            'Consider physical therapy',
          ],
        ),
        Condition(
          name: 'Herniated Disc',
          severity: 'Medium',
          probability: 0.32,
          description: 'Spinal disc pressing on nerves',
          recommendations: [
            'Physical therapy',
            'Anti-inflammatory medication',
            'Avoid heavy lifting',
            'See specialist if pain radiates to legs',
          ],
        ),
        Condition(
          name: 'Sciatica',
          severity: 'Medium',
          probability: 0.28,
          description: 'Nerve pain radiating down leg from back',
          recommendations: [
            'Physical therapy exercises',
            'Heat and ice therapy',
            'Avoid prolonged sitting',
            'Medical evaluation if severe',
          ],
        ),
      ];
    }
    // Joint pain
    else if (symptomLower.contains('joint') ||
        (symptomLower.contains('knee') && symptomLower.contains('pain')) ||
        (symptomLower.contains('ankle') && symptomLower.contains('pain')) ||
        (symptomLower.contains('elbow') && symptomLower.contains('pain'))) {
      return [
        Condition(
          name: 'Osteoarthritis',
          severity: 'Medium',
          probability: 0.58,
          description: 'Wear-and-tear arthritis causing joint pain',
          recommendations: [
            'Low-impact exercise (swimming, cycling)',
            'Maintain healthy weight',
            'Anti-inflammatory medication',
            'Physical therapy',
          ],
        ),
        Condition(
          name: 'Sprain or Strain',
          severity: 'Low',
          probability: 0.52,
          description: 'Ligament or muscle injury',
          recommendations: [
            'RICE: Rest, Ice, Compression, Elevation',
            'Avoid weight-bearing if severe',
            'Over-the-counter pain relief',
            'See doctor if no improvement in 48 hours',
          ],
        ),
        Condition(
          name: 'Rheumatoid Arthritis',
          severity: 'Medium',
          probability: 0.35,
          description: 'Autoimmune condition causing joint inflammation',
          recommendations: [
            'Rheumatologist consultation',
            'Disease-modifying medications',
            'Regular exercise',
            'Joint protection techniques',
          ],
        ),
        Condition(
          name: 'Bursitis',
          severity: 'Low',
          probability: 0.30,
          description: 'Inflammation of fluid-filled sacs around joints',
          recommendations: [
            'Rest affected joint',
            'Ice application',
            'Anti-inflammatory medication',
            'Avoid repetitive movements',
          ],
        ),
      ];
    }
    // Skin issues
    else if (symptomLower.contains('rash') ||
        symptomLower.contains('itch') ||
        symptomLower.contains('skin')) {
      return [
        Condition(
          name: 'Allergic Reaction',
          severity: 'Low',
          probability: 0.68,
          description: 'Skin reaction to allergen',
          recommendations: [
            'Identify and avoid trigger',
            'Antihistamine medication',
            'Cool compress to affected area',
            'Seek emergency care if breathing difficulty',
          ],
        ),
        Condition(
          name: 'Eczema',
          severity: 'Low',
          probability: 0.48,
          description: 'Chronic skin condition causing dry, itchy patches',
          recommendations: [
            'Moisturize regularly',
            'Avoid harsh soaps and detergents',
            'Topical corticosteroids',
            'Identify and avoid triggers',
          ],
        ),
        Condition(
          name: 'Contact Dermatitis',
          severity: 'Low',
          probability: 0.45,
          description: 'Skin inflammation from contact with irritant',
          recommendations: [
            'Wash area with mild soap',
            'Avoid the irritant',
            'Hydrocortisone cream',
            'Cool, wet compresses',
          ],
        ),
        Condition(
          name: 'Fungal Infection',
          severity: 'Low',
          probability: 0.32,
          description: 'Skin infection caused by fungus',
          recommendations: [
            'Antifungal cream or powder',
            'Keep area clean and dry',
            'Avoid sharing personal items',
            'See doctor if not improving',
          ],
        ),
      ];
    }
    // Breathing issues
    else if (symptomLower.contains('breathing') ||
        symptomLower.contains('breath') ||
        symptomLower.contains('shortness')) {
      return [
        Condition(
          name: 'Asthma Attack',
          severity: 'High',
          probability: 0.55,
          description: 'Airway constriction causing breathing difficulty',
          recommendations: [
            'Use rescue inhaler immediately',
            'Sit upright',
            'Stay calm and breathe slowly',
            'Seek emergency care if no improvement',
          ],
        ),
        Condition(
          name: 'Anxiety/Panic Attack',
          severity: 'Medium',
          probability: 0.48,
          description: 'Stress causing hyperventilation',
          recommendations: [
            'Practice slow, deep breathing',
            'Focus on exhaling slowly',
            'Remove from stressful situation',
            'Seek mental health support',
          ],
        ),
        Condition(
          name: 'Pneumonia',
          severity: 'High',
          probability: 0.35,
          description: 'Lung infection causing breathing difficulty',
          recommendations: [
            'See doctor immediately',
            'May require antibiotics',
            'Rest and hydration',
            'Monitor oxygen levels',
          ],
        ),
        Condition(
          name: 'Pulmonary Embolism',
          severity: 'High',
          probability: 0.15,
          description: 'Blood clot in lung - MEDICAL EMERGENCY',
          recommendations: [
            '⚠️ CALL EMERGENCY SERVICES IMMEDIATELY',
            'Do not wait',
            'Especially if sudden onset with chest pain',
          ],
        ),
      ];
    }
    // Ear pain
    else if (symptomLower.contains('ear') && symptomLower.contains('pain')) {
      return [
        Condition(
          name: 'Ear Infection',
          severity: 'Medium',
          probability: 0.68,
          description: 'Bacterial or viral infection of middle ear',
          recommendations: [
            'Warm compress on ear',
            'Pain relievers',
            'See doctor for possible antibiotics',
            'Avoid getting water in ear',
          ],
        ),
        Condition(
          name: 'Earwax Buildup',
          severity: 'Low',
          probability: 0.52,
          description: 'Excessive wax blocking ear canal',
          recommendations: [
            'Over-the-counter ear drops',
            'Do NOT use cotton swabs',
            'Professional removal if impacted',
            'Soften with mineral oil',
          ],
        ),
        Condition(
          name: 'TMJ Disorder',
          severity: 'Low',
          probability: 0.35,
          description: 'Jaw joint problem causing ear pain',
          recommendations: [
            'Avoid hard or chewy foods',
            'Apply warm compress to jaw',
            'Gentle jaw exercises',
            'See dentist or specialist',
          ],
        ),
        Condition(
          name: 'Swimmers Ear',
          severity: 'Low',
          probability: 0.30,
          description: 'Outer ear canal infection',
          recommendations: [
            'Keep ear dry',
            'Antibiotic ear drops',
            'Avoid swimming until healed',
            'Do not insert anything in ear',
          ],
        ),
      ];
    }
    // Insomnia/Sleep issues
    else if (symptomLower.contains('sleep') ||
        symptomLower.contains('insomnia') ||
        symptomLower.contains('can\'t sleep')) {
      return [
        Condition(
          name: 'Stress-Related Insomnia',
          severity: 'Low',
          probability: 0.72,
          description: 'Difficulty sleeping due to stress or anxiety',
          recommendations: [
            'Establish consistent sleep schedule',
            'Relaxation techniques before bed',
            'Avoid screens 1 hour before sleep',
            'Create calm sleep environment',
          ],
        ),
        Condition(
          name: 'Poor Sleep Hygiene',
          severity: 'Low',
          probability: 0.58,
          description: 'Habits interfering with good sleep',
          recommendations: [
            'Keep bedroom cool and dark',
            'Avoid caffeine after 2 PM',
            'No exercise close to bedtime',
            'Reserve bed for sleep only',
          ],
        ),
        Condition(
          name: 'Sleep Apnea',
          severity: 'Medium',
          probability: 0.32,
          description: 'Breathing interruptions during sleep',
          recommendations: [
            'Sleep study recommended',
            'Weight loss if overweight',
            'Sleep on side, not back',
            'CPAP machine if diagnosed',
          ],
        ),
        Condition(
          name: 'Circadian Rhythm Disorder',
          severity: 'Low',
          probability: 0.28,
          description: 'Body clock misalignment',
          recommendations: [
            'Light therapy in morning',
            'Consistent wake time',
            'Avoid naps',
            'Melatonin supplements (consult doctor)',
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
        Condition(
          name: 'Nutritional Deficiency',
          severity: 'Low',
          probability: 0.28,
          description: 'Lacking essential vitamins or minerals',
          recommendations: [
            'Eat balanced, varied diet',
            'Consider multivitamin',
            'Blood tests to identify deficiencies',
            'Address specific deficiencies with doctor',
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
      'severe abdominal pain',
      'coughing blood',
      'sudden vision loss',
      'stroke symptoms',
      'allergic reaction with swelling',
    ];

    return urgentKeywords.any((keyword) => symptomLower.contains(keyword));
  }
}
