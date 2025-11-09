import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/symptom_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SymptomSearchScreen extends StatefulWidget {
  const SymptomSearchScreen({super.key});

  @override
  State<SymptomSearchScreen> createState() => _SymptomSearchScreenState();
}

class _SymptomSearchScreenState extends State<SymptomSearchScreen> {
  Future<void> saveSymptomToFirestore(Symptom symptom) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('symptoms');

    await ref.add(symptom.toMap());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${symptom.name} saved to history!"),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  List<Symptom> allSymptoms = [];
  List<Symptom> filteredSymptoms = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSymptoms();
  }

  Future<void> loadSymptoms() async {
    final String response = await rootBundle.loadString('assets/symptoms.json');
    final data = json.decode(response) as List;
    setState(() {
      allSymptoms = data.map((e) => Symptom.fromMap(e)).toList();
      filteredSymptoms = allSymptoms;
    });
  }

  void filterSymptoms(String query) {
    setState(() {
      filteredSymptoms = allSymptoms
          .where(
            (symptom) =>
                symptom.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Symptoms"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSymptoms,
              decoration: InputDecoration(
                hintText: "Enter symptom name...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSymptoms.length,
              itemBuilder: (context, index) {
                final symptom = filteredSymptoms[index];
                // return Card(
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   margin: const EdgeInsets.symmetric(
                //     horizontal: 10,
                //     vertical: 6,
                //   ),
                //   child: ListTile(
                //     title: Text(symptom.name),
                //     subtitle: Text(symptom.description),
                //     trailing: Chip(
                //       label: Text(
                //         symptom.severity,
                //         style: const TextStyle(color: Colors.white),
                //       ),
                //       backgroundColor: symptom.severity == 'High'
                //           ? Colors.red
                //           : symptom.severity == 'Medium'
                //           ? Colors.orange
                //           : Colors.green,
                //     ),
                //   ),
                // );
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(symptom.name),
                    subtitle: Text(symptom.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(
                            symptom.severity,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: symptom.severity == 'High'
                              ? Colors.red
                              : symptom.severity == 'Medium'
                              ? Colors.orange
                              : Colors.green,
                        ),
                        IconButton(
                          icon: const Icon(Icons.save, color: Colors.teal),
                          onPressed: () => saveSymptomToFirestore(symptom),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
