import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SymptomHistoryScreen extends StatefulWidget {
  const SymptomHistoryScreen({super.key});

  @override
  State<SymptomHistoryScreen> createState() => _SymptomHistoryScreenState();
}

class _SymptomHistoryScreenState extends State<SymptomHistoryScreen> {
  String _sortBy = 'Date (Recent First)';

  Stream<QuerySnapshot> _getSymptomsStream(String uid) {
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('symptoms');

    if (_sortBy == 'Severity') {
      query = query.orderBy('severity');
    } else {
      query = query.orderBy('date', descending: true);
    }
    return query.snapshots();
  }

  Future<void> _deleteSymptom(String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('symptoms')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom History'),
        actions: [
          DropdownButton<String>(
            value: _sortBy,
            items: [
              'Date (Recent First)',
              'Severity',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => _sortBy = val!),
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Please sign in to view your symptom history.'))
          : StreamBuilder<QuerySnapshot>(
              stream: _getSymptomsStream(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  final err = snapshot.error;
                  // Friendly handling for permission issues
                  if (err is FirebaseException && err.code == 'permission-denied') {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Permission denied',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'You do not have permission to read symptom history. Please ensure you are signed in with the correct account and that Firestore security rules allow access.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/profile'),
                              child: const Text('Open Profile / Sign in'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No symptoms logged yet!'));
                }

                final symptoms = snapshot.data!.docs;

                return ListView.separated(
                  padding: const EdgeInsets.all(10),
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: symptoms.length,
                  itemBuilder: (context, index) {
                    final data = symptoms[index].data() as Map<String, dynamic>;

                    // parse date safely
                    DateTime parsedDate;
                    final rawDate = data['date'];
                    if (rawDate is Timestamp) {
                      parsedDate = rawDate.toDate();
                    } else if (rawDate is String) {
                      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
                    } else if (rawDate is DateTime) {
                      parsedDate = rawDate;
                    } else {
                      parsedDate = DateTime.now();
                    }

                    final severity = (data['severity'] ?? '').toString();

                    Color severityColor;
                    switch (severity.toLowerCase()) {
                      case 'high':
                      case 'severe':
                        severityColor = Colors.redAccent;
                        break;
                      case 'moderate':
                        severityColor = Colors.orangeAccent;
                        break;
                      default:
                        severityColor = Colors.green;
                    }

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: severityColor.withAlpha((0.15 * 255).round()),
                          child: Icon(Icons.local_hospital, color: severityColor),
                        ),
                        title: Text(data['symptom'] ?? ''),
                        subtitle: Text(
                          '${data['description'] ?? ''}\n${parsedDate.toLocal().toString()}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteSymptom(symptoms[index].id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
