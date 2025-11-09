import 'package:flutter/material.dart';
import '../services/health_api_service.dart';
import 'health_report_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AISymptomAnalysisScreen extends StatefulWidget {
  const AISymptomAnalysisScreen({super.key});

  @override
  State<AISymptomAnalysisScreen> createState() =>
      _AISymptomAnalysisScreenState();
}

class _AISymptomAnalysisScreenState extends State<AISymptomAnalysisScreen> {
  final _symptomController = TextEditingController();
  final _apiService = HealthApiService();
  bool _isLoading = false;
  List<dynamic> _results = [];

  Future<void> _analyzeSymptom() async {
    if (_symptomController.text.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      final response = await _apiService.fetchPossibleDiseases(
        _symptomController.text.trim(),
      );
      setState(() {
        _results = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error fetching data!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Symptom Analysis')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _symptomController,
              decoration: InputDecoration(
                labelText: 'Enter symptom (e.g., headache, fever)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(onPressed: _analyzeSymptom, child: Text('Analyze')),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HealthReportScreen(symptom: _symptomController.text),
                  ),
                );
              },
              child: Text('View Health Report'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: SpinKitThreeBounce(color: Colors.blue))
                : Expanded(
                    child: _results.isEmpty
                        ? Text("No data yet. Enter a symptom to analyze.")
                        : ListView.builder(
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              final item = _results[index];
                              return Card(
                                elevation: 3,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(
                                    item['name'] ?? 'Unknown Disease',
                                  ),
                                  subtitle: Text(
                                    item['description'] ??
                                        'No description available',
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
