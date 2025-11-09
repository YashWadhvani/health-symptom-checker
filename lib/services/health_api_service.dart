import 'dart:convert';
import 'package:http/http.dart' as http;

class HealthApiService {
  final String apiKey =
      'yo1JiGFHl08lw/GwYg26WA==DX3EZhRQmmrbfthJ'; // 🔑 Replace with your own API key

  Future<List<dynamic>> fetchPossibleDiseases(String symptom) async {
    final url = Uri.parse(
      'https://api.api-ninjas.com/v1/disease?symptoms=$symptom',
    );

    final response = await http.get(url, headers: {'X-Api-Key': apiKey});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }
}
