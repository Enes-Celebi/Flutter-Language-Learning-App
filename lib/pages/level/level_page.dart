import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/appbar_component.dart";
import "package:lingoneer_beta_0_0_1/pages/level/level_card_component.dart";
import "package:lingoneer_beta_0_0_1/pages/mapcard/mapcard_page.dart";

class subjectLevelPage extends StatefulWidget {
  final String selectedCardIndex;
  final Color subjectCardColor;

  const subjectLevelPage({
    Key? key,
    required this.selectedCardIndex,
    required this.subjectCardColor,
  }) : super(key: key);

  @override
  State<subjectLevelPage> createState() => _subjectLevelPageState();
}

class _subjectLevelPageState extends State<subjectLevelPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _goToProgressMapPage(String levelId, String subjectId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => progressMapPage(
          selectedCardIndex: levelId,
          selectedSubjectIndex: subjectId,
          levelCardColor: widget.subjectCardColor,
        ),
      ),
    );
    setState(() {}); // Refresh the FutureBuilder when returning from the progress map page
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    return Scaffold(
      //appBar: const CustomBar(),
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

          print("Levels snapshot length: ${snapshot.data![0].docs.length}");
          print("Progress snapshot length: ${snapshot.data![1].docs.length}");

          final levelsSnapshot = snapshot.data![0].docs;
          final progressSnapshot = snapshot.data![1];

          // Extracting completed lessonIds from progressSnapshot
          final doneMapcardsIds = progressSnapshot.docs
              .map((doc) => doc['lessonId'].toString())
              .toList();

          // Sort levels by the 'order' field
          levelsSnapshot.sort((a, b) => (a['order'] as int).compareTo(b['order'] as int));

          return SingleChildScrollView(
            child: Column(
              children: levelsSnapshot.map((levelSnapshot) {
                final title = levelSnapshot.get('name');
                final imageURL = levelSnapshot.get('image');
                final levelId = levelSnapshot.get('id');
                final subjectId = levelSnapshot.get('subject');

                final countOfSpecificLevel = doneMapcardsIds
                    .where((id) => id.startsWith(levelId))
                    .length;

                final progressValue = countOfSpecificLevel / 8;

                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return SubjectLevelCard(
                      title: title ?? 'No Title',
                      imagePath: imageURL ?? 'lib/assets/images/test/pic1.png',
                      progressValue: _animationController.drive(
                        Tween(begin: 0.0, end: progressValue),
                      ).value,
                      cardColor: widget.subjectCardColor,
                      progressColor: widget.subjectCardColor.withOpacity(0.7),
                      onTap: () => _goToProgressMapPage(
                        levelId,
                        subjectId,
                      ),
                    );
                  },
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
