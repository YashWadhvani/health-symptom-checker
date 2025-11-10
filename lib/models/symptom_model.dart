import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Symptom model class for managing symptom data
class Symptom {
  final String name;
  final String description;
  final String
  severity; // "High", "Medium", "Low" or "Mild", "Moderate", "Severe"
  final DateTime? timestamp;
  final double? probability; // Optional: for AI analysis (0.0 to 1.0)

  Symptom({
    required this.name,
    required this.description,
    required this.severity,
    this.timestamp,
    this.probability,
  });

  /// Create Symptom from JSON/Map (for API responses and Firestore)
  factory Symptom.fromMap(Map<String, dynamic> map) {
    return Symptom(
      name: map['name'] ?? map['symptom'] ?? 'Unknown',
      description: map['description'] ?? 'No description available',
      severity: map['severity'] ?? 'Low',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] is Timestamp
                ? (map['timestamp'] as Timestamp).toDate()
                : map['date'] is Timestamp
                ? (map['date'] as Timestamp).toDate()
                : DateTime.tryParse(map['timestamp'].toString()) ??
                      DateTime.now())
          : map['date'] != null
          ? (map['date'] is Timestamp
                ? (map['date'] as Timestamp).toDate()
                : DateTime.tryParse(map['date'].toString()))
          : null,
      probability: map['probability'] != null
          ? (map['probability'] is double
                ? map['probability']
                : double.tryParse(map['probability'].toString()))
          : null,
    );
  }

  /// Convert Symptom to Map (for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'symptom': name, // Alias for compatibility
      'description': description,
      'severity': severity,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
      'date': timestamp ?? FieldValue.serverTimestamp(),
      if (probability != null) 'probability': probability,
    };
  }

  /// Convert to JSON string (for debugging)
  @override
  String toString() {
    return 'Symptom(name: $name, severity: $severity, description: $description, timestamp: $timestamp)';
  }

  /// Create a copy with modified fields
  Symptom copyWith({
    String? name,
    String? description,
    String? severity,
    DateTime? timestamp,
    double? probability,
  }) {
    return Symptom(
      name: name ?? this.name,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      timestamp: timestamp ?? this.timestamp,
      probability: probability ?? this.probability,
    );
  }

  /// Check if symptom is high severity
  bool get isHighSeverity {
    final lower = severity.toLowerCase();
    return lower == 'high' || lower == 'severe';
  }

  /// Check if symptom is medium severity
  bool get isMediumSeverity {
    final lower = severity.toLowerCase();
    return lower == 'medium' || lower == 'moderate';
  }

  /// Check if symptom is low severity
  bool get isLowSeverity {
    final lower = severity.toLowerCase();
    return lower == 'low' || lower == 'mild';
  }

  /// Get severity color
  static getSeverityColor(String severity) {
    final lower = severity.toLowerCase();
    if (lower == 'high' || lower == 'severe') {
      return const Color(0xFFFF5252); // Red
    } else if (lower == 'medium' || lower == 'moderate') {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFF4CAF50); // Green
    }
  }
}

/// Condition model for health report and AI analysis
class Condition {
  final String name;
  final String severity;
  final double probability;
  final String? description;
  final List<String>? recommendations;

  Condition({
    required this.name,
    required this.severity,
    required this.probability,
    this.description,
    this.recommendations,
  });

  /// Create Condition from JSON/Map
  factory Condition.fromMap(Map<String, dynamic> map) {
    return Condition(
      name: map['name'] ?? 'Unknown Condition',
      severity: map['severity'] ?? 'Low',
      probability: map['probability'] != null
          ? (map['probability'] is double
                ? map['probability']
                : double.tryParse(map['probability'].toString()) ?? 0.0)
          : 0.0,
      description: map['description'],
      recommendations: map['recommendations'] != null
          ? List<String>.from(map['recommendations'])
          : null,
    );
  }

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'severity': severity,
      'probability': probability,
      if (description != null) 'description': description,
      if (recommendations != null) 'recommendations': recommendations,
    };
  }

  @override
  String toString() {
    return 'Condition(name: $name, severity: $severity, probability: ${(probability * 100).toStringAsFixed(1)}%)';
  }
}
