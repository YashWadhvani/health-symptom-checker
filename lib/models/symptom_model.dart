class Symptom {
  final String name;
  final String description;
  final String severity;
  final DateTime? timestamp;

  Symptom({
    required this.name,
    required this.description,
    required this.severity,
    this.timestamp,
  });

  factory Symptom.fromMap(Map<String, dynamic> data) {
    return Symptom(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      severity: data['severity'] ?? 'Low',
      timestamp: data['timestamp'] != null
          ? DateTime.parse(data['timestamp'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'severity': severity,
      'timestamp':
          timestamp?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }
}
