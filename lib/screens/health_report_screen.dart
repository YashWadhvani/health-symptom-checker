import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/symptom_api.dart';

class HealthReportScreen extends StatefulWidget {
  final String symptom;
  const HealthReportScreen({super.key, required this.symptom});

  @override
  State<HealthReportScreen> createState() => _HealthReportScreenState();
}

class _HealthReportScreenState extends State<HealthReportScreen> {
  final SymptomApiService _apiService = SymptomApiService();
  List<Condition> _conditions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await _apiService.getPossibleConditions(widget.symptom);
      setState(() {
        _conditions = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Color getColor(String severity) {
    switch (severity) {
      case "High":
        return Colors.redAccent;
      case "Medium":
        return Colors.orangeAccent;
      default:
        return Colors.greenAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Health Report")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Severity Indicators for: ${widget.symptom}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🟩 Severity Cards
                  Expanded(
                    child: ListView.builder(
                      itemCount: _conditions.length,
                      itemBuilder: (context, index) {
                        final c = _conditions[index];
                        return Card(
                          color: getColor(c.severity).withOpacity(0.3),
                          child: ListTile(
                            title: Text(c.name),
                            subtitle: Text(
                              "Severity: ${c.severity} • Probability: ${(c.probability * 100).toStringAsFixed(1)}%",
                            ),
                            leading: Icon(
                              Icons.warning_amber_rounded,
                              color: getColor(c.severity),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Visual Severity Chart",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // 📊 Bar Chart
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: _conditions
                            .map(
                              (c) => BarChartGroupData(
                                x: _conditions.indexOf(c),
                                barRods: [
                                  BarChartRodData(
                                    toY: c.probability * 100,
                                    color: getColor(c.severity),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                final name = _conditions[value.toInt()].name
                                    .split(' ');
                                return Text(
                                  name.first,
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
