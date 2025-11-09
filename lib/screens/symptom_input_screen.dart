import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SymptomInputScreen extends StatefulWidget {
  const SymptomInputScreen({super.key});

  @override
  State<SymptomInputScreen> createState() => _SymptomInputScreenState();
}

class _SymptomInputScreenState extends State<SymptomInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;

  final _symptomController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _severity = "Mild";

  Future<void> _saveSymptom() async {
    if (_formKey.currentState!.validate()) {
      await _firestore
          .collection('users')
          .doc(_user!.uid)
          .collection('symptoms')
          .add({
            'symptom': _symptomController.text.trim(),
            'description': _descriptionController.text.trim(),
            'severity': _severity,
            'date': DateTime.now(),
          });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Symptom saved successfully!")));
      }

      _symptomController.clear();
      _descriptionController.clear();
      setState(() => _severity = "Mild");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log Symptoms')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Enter your symptoms:", style: TextStyle(fontSize: 18)),
              SizedBox(height: 15),
              TextFormField(
                controller: _symptomController,
                decoration: InputDecoration(labelText: "Symptom"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a symptom" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(labelText: "Description"),
                validator: (value) =>
                    value!.isEmpty ? "Please describe your symptom" : null,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _severity,
                decoration: InputDecoration(labelText: "Severity"),
                items: ["Mild", "Moderate", "Severe"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _severity = val!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSymptom,
                child: Text("Save Symptom"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
