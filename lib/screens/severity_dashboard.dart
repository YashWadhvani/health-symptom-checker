import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart'
    show PieChart, PieChartData, PieChartSectionData;
import 'package:flutter/material.dart';

class SeverityDashboard extends StatefulWidget {
  const SeverityDashboard({super.key});

  @override
  State<SeverityDashboard> createState() => _SeverityDashboardState();
}

class _SeverityDashboardState extends State<SeverityDashboard> {
  int high = 0, medium = 0, low = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSymptomData();
  }

  Future<void> fetchSymptomData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('symptoms')
        .get();

    int highCount = 0, mediumCount = 0, lowCount = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      switch (data['severity']) {
        case 'High':
          highCount++;
          break;
        case 'Medium':
          mediumCount++;
          break;
        case 'Low':
          lowCount++;
          break;
      }
    }

    if (mounted) {
      setState(() {
        high = highCount;
        medium = mediumCount;
        low = lowCount;
        isLoading = false;
      });
    }
  }

  List<PieChartSectionData> _getSections() {
    final sections = <PieChartSectionData>[];

    if (high > 0) {
      sections.add(
        PieChartSectionData(
          color: Colors.redAccent,
          value: high.toDouble(),
          title: 'High\n$high',
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    if (medium > 0) {
      sections.add(
        PieChartSectionData(
          color: Colors.orangeAccent,
          value: medium.toDouble(),
          title: 'Medium\n$medium',
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    if (low > 0) {
      sections.add(
        PieChartSectionData(
          color: Colors.green,
          value: low.toDouble(),
          title: 'Low\n$low',
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final total = high + medium + low;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Symptom Severity Dashboard"),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : total == 0
          ? const Center(child: Text("No data yet!"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Severity Overview",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sections: _getSections(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegend(Colors.redAccent, "High Severity"),
                      _buildLegend(Colors.orangeAccent, "Medium Severity"),
                      _buildLegend(Colors.green, "Low Severity"),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
