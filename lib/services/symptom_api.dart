import 'dart:convert';
import 'package:http/http.dart' as http;

class Condition {
  final String name;
  final double probability;
  final String severity;

  Condition({
    required this.name,
    required this.probability,
    required this.severity,
  });
}

class SymptomApiService {
  final String appId = "YOUR_APP_ID";
  final String appKey = "YOUR_APP_KEY";
  final String baseUrl = "https://api.infermedica.com/v3";

  Future<List<Condition>> getPossibleConditions(String symptom) async {
    final url = Uri.parse("$baseUrl/diagnosis");
    final headers = {
      'App-Id': appId,
      'App-Key': appKey,
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "sex": "female",
      "age": 21,
      "evidence": [
        {"id": symptom, "choice_id": "present"},
      ],
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Condition> conditions = [];

      for (var condition in data["conditions"]) {
        final prob = (condition["probability"] as num).toDouble();
        String severity = prob > 0.7
            ? "High"
            : prob > 0.4
            ? "Medium"
            : "Low";
        conditions.add(
          Condition(
            name: condition['name'],
            probability: prob,
            severity: severity,
          ),
        );
      }
      return conditions;
    } else {
      throw Exception("Failed to fetch conditions");
    }
  }
}
