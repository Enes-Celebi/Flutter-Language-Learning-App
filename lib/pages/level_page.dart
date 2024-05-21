import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/appbar_component.dart";
import "package:lingoneer_beta_0_0_1/components/level_card_component.dart";
import "package:lingoneer_beta_0_0_1/pages/mapcard_page.dart";

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

  void _goToProgressMapPage(String levelId, String subjectId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => progressMapPage(
          selectedCardIndex: levelId, 
          selectedSubjectIndex: subjectId,
        )
      ),
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

          final levelsSnapshot = snapshot.data![0].docs;
          final progressSnapshot = snapshot.data![1];

          final doneMapcardsIds = progressSnapshot.docs
            .map((doc) => doc['lessonId'].toString()
            .substring(0, doc['lessonId'].toString().length - 3))
            .toList();

          return SingleChildScrollView(
            child: Column(
              children: levelsSnapshot.map((levelsSnapshot) {
                final title = levelsSnapshot.get('name');
                final imageURL = levelsSnapshot.get('image');
                final levelId = levelsSnapshot.get('id');
                final subjectId = levelsSnapshot.get('subject');

                final countOfSpecificLevel = doneMapcardsIds
                  .where((level) => level == levelId).length;

                return SubjectLevelCard(
                  title: title ??
                      'No Title', // Set default title if "name" is missing
                  imagePath: imageURL ?? 'lib/assets/images/test/pic1.png',
                  progressValue: countOfSpecificLevel/8,
                  cardColor: Colors.blue,
                  progressColor: Colors.blue.shade700,
                  onTap: () => _goToProgressMapPage(
                      levelId,
                      subjectId
                    ), // Use document ID for navigation (optional)
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
