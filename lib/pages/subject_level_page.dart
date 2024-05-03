import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/appbar.dart";
import "package:lingoneer_beta_0_0_1/components/subject_level_card.dart";
import "package:lingoneer_beta_0_0_1/pages/progress_map_page.dart";

class subjectLevelPage extends StatefulWidget {
  final String selectedCardIndex;

  const subjectLevelPage({
    super.key,
    required this.selectedCardIndex,
  });

  @override
  State<subjectLevelPage> createState() => _subjectLevelPageState();
}

class _subjectLevelPageState extends State<subjectLevelPage> {
  void _goToProgressMapPage(String levelId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => progressMapPage(selectedCardIndex: levelId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: FutureBuilder<List<QuerySnapshot>>(
        future: Future.wait([
          FirebaseFirestore.instance
              .collection('levels')
              .where('subject', isEqualTo: widget.selectedCardIndex)
              .get(),
          FirebaseFirestore.instance
              .collection('progress')
              .where('userId', isEqualTo: user?.uid)
              .get(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final Levels = snapshot.data![0].docs;
          final progressSnapshot = snapshot.data![1];

          final donelevelsIds = progressSnapshot.docs
    .map((doc) => doc['lessonId'].toString().substring(0, doc['lessonId'].toString().length - 3))
    .toList();

          return SingleChildScrollView(
            child: Column(
              children: Levels.map((Levels) {
                final title = Levels.get('name');
                final imageURL = Levels.get('image');
                final levelId = Levels.get('id');

                final countOfSpecificLevel = donelevelsIds.where((level) => level == levelId).length;

                return SubjectLevelCard(
                  title: title ??
                      'No Title', // Set default title if "name" is missing
                  imagePath: imageURL ?? 'lib/assets/images/test/pic1.png',
                  progressValue: countOfSpecificLevel/8,
                  cardColor: Colors.blue,
                  progressColor: Colors.blue.shade700,
                  onTap: () => _goToProgressMapPage(
                      levelId), // Use document ID for navigation (optional)
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate back to home screen
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
