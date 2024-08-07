import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestCompletionPage extends StatelessWidget {
  const TestCompletionPage({super.key, required this.selectedCardIndex,required this.isLesson});
  final String selectedCardIndex;
  final bool isLesson;

  Future<void> _updateProgress() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference progressCollection = firestore.collection('progress');
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    print(selectedCardIndex);

    try {
      await progressCollection.add({
        'userId': user?.uid,
        'lessonId': selectedCardIndex,
      });
      print('Progress updated successfully');
    } catch (e) {
      print('Error updating progress: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    _updateProgress();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              isLesson ? 'Lesson Done!' : 'Test Done!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Go to Lesson Page'),
            ),
          ],
        ),
      ),
    );
  }
}
