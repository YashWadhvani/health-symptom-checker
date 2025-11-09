// //
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../models/symptom_model.dart';

// class SymptomHistoryScreen extends StatelessWidget {
//   const SymptomHistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     final ref = FirebaseFirestore.instance
//         .collection('users')
//         .doc(user?.uid)
//         .collection('symptoms')
//         .orderBy('timestamp', descending: true);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Symptom History"),
//         backgroundColor: Colors.teal,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: ref.snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final data = snapshot.data!.docs;
//           if (data.isEmpty) {
//             return const Center(child: Text("No symptoms logged yet."));
//           }

//           return ListView.builder(
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               final item = data[index].data() as Map<String, dynamic>;
//               final symptom = Symptom.fromMap(item);
//               return ListTile(
//                 leading: Icon(
//                   Icons.local_hospital,
//                   color: symptom.severity == 'High'
//                       ? Colors.red
//                       : symptom.severity == 'Medium'
//                       ? Colors.orange
//                       : Colors.green,
//                 ),
//                 title: Text(symptom.name),
//                 subtitle: Text(
//                   "${symptom.description}\n${symptom.timestamp?.toLocal().toString().split('.')[0]}",
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// class SymptomHistoryScreen extends StatelessWidget {
//   const SymptomHistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       return const Scaffold(
//         body: Center(
//           child: Text("Please sign in to view your symptom history."),
//         ),
//       );
//     }

//     final ref = FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('symptoms')
//         .orderBy('timestamp', descending: true);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Symptom History"),
//         backgroundColor: Colors.teal,
//         foregroundColor: Colors.white,
//         elevation: 2,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: ref.snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(color: Colors.teal),
//             );
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 "Error fetching data: ${snapshot.error}",
//                 style: const TextStyle(color: Colors.red),
//               ),
//             );
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No symptoms logged yet.\nStart by using the AI Symptom Checker!",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16, color: Colors.black54),
//               ),
//             );
//           }

//           final data = snapshot.data!.docs;

//           return ListView.separated(
//             padding: const EdgeInsets.all(10),
//             separatorBuilder: (_, __) => const Divider(),
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               final item = data[index].data() as Map<String, dynamic>;
//               final symptom = Symptom.fromMap(item);

//               Color severityColor;
//               switch (symptom.severity?.toLowerCase()) {
//                 case 'high':
//                   severityColor = Colors.redAccent;
//                   break;
//                 case 'medium':
//                   severityColor = Colors.orangeAccent;
//                   break;
//                 default:
//                   severityColor = Colors.green;
//               }

//               return Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 elevation: 2,
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: severityColor.withOpacity(0.15),
//                     child: Icon(Icons.local_hospital, color: severityColor),
//                   ),
//                   title: Text(
//                     symptom.name,
//                     style: const TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                   subtitle: Text(
//                     "${symptom.description}\n"
//                     "${symptom.timestamp != null ? symptom.timestamp!.toLocal().toString().split('.')[0] : ''}",
//                   ),
//                   isThreeLine: true,
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class SymptomHistoryScreen extends StatefulWidget {
  const SymptomHistoryScreen({super.key});

  @override
  State<SymptomHistoryScreen> createState() => _SymptomHistoryScreenState();
}

class _SymptomHistoryScreenState extends State<SymptomHistoryScreen> {
  final _user = FirebaseAuth.instance.currentUser!;
  String _sortBy = 'Date (Recent First)';

  Stream<QuerySnapshot> _getSymptomsStream() {
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('symptoms');

    if (_sortBy == 'Severity') {
      query = query.orderBy('severity');
    } else {
      query = query.orderBy('date', descending: true);
    }
    return query.snapshots();
  }

  Future<void> _deleteSymptom(String docId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('symptoms')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptom History'),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _getSymptomsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No symptoms logged yet!"));
          }

          final symptoms = snapshot.data!.docs;

          return ListView.builder(
            itemCount: symptoms.length,
            itemBuilder: (context, index) {
              final data = symptoms[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  title: Text(data['symptom'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Severity: ${data['severity']}"),
                      Text(
                        "Date: ${DateTime.parse(data['date'].toDate().toString()).toLocal()}",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
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
