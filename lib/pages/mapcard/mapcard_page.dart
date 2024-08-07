import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/appbar_component.dart";
import "package:lingoneer_beta_0_0_1/pages/mapcard/mapcard_component.dart";
import "package:lingoneer_beta_0_0_1/pages/test/lesson_page.dart";
import "package:lingoneer_beta_0_0_1/pages/test/test_page.dart";

class progressMapPage extends StatefulWidget {
  final String selectedCardIndex;
  final String selectedSubjectIndex;
  final Color levelCardColor;

  const progressMapPage({
    Key? key,
    required this.selectedCardIndex,
    required this.selectedSubjectIndex,
    required this.levelCardColor,
  }) : super(key: key);

  @override
  State<progressMapPage> createState() => _progressMapPageState();
}

class _progressMapPageState extends State<progressMapPage> {
  void _goToLessonPage(String mapcardId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonPage(selectedCardIndex: mapcardId),
      ),
    );
    setState(() {}); // Refresh the FutureBuilder when returning from the lesson page
  }

  void _goToTestPage(String mapcardId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestPage(selectedCardIndex: mapcardId),
      ),
    );
    setState(() {}); // Refresh the FutureBuilder when returning from the test page
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    Color cardBorder = widget.levelCardColor.withOpacity(0.1);

    return Scaffold(
      //appBar: const CustomBar(),
      body: FutureBuilder<List<QuerySnapshot>>(
        future: Future.wait([
          FirebaseFirestore.instance
              .collection('mapcards')
              .where('level', isEqualTo: widget.selectedCardIndex)
              .get(),
          FirebaseFirestore.instance
              .collection('progress')
              .where('userId', isEqualTo: user?.uid)
              .get(),
          FirebaseFirestore.instance
              .collection('mapcards')
              .where('subject', isEqualTo: widget.selectedSubjectIndex)
              .get(),
        ]),
        builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final mapCardsSnapshot = snapshot.data![0];
          final progressSnapshot = snapshot.data![1];
          final mapCardSubjectSnapshot = snapshot.data![2];

          if (mapCardsSnapshot.docs.isEmpty || mapCardSubjectSnapshot.docs.isEmpty) {
            return const Center(child: Text('No mapcards found.'));
          }

          var mapCards = mapCardsSnapshot.docs;
          final donelessonIds = progressSnapshot.docs.map((doc) => doc['lessonId']).toList();

          // Sort mapCards by the 'order' field
          mapCards.sort((a, b) => (a['order'] as int).compareTo(b['order'] as int));

          return SingleChildScrollView(
            child: Column(
              children: mapCards.map((mapCard) {
                final title = mapCard.get('name');
                final imageURL = mapCard.get('image');
                final type = mapCard.get('type');
                final mapCardId = mapCard.get('id');

                // Determine the status image path based on whether the lesson is completed
                final statusImagePath = donelessonIds.contains(mapCardId)
                    ? 'lib/assets/images/icons/done.png'
                    : 'lib/assets/images/icons/undone.png';

                return ProgressMapCard(
                  title: title ?? 'No Title',
                  lessonImagePath: imageURL ?? 'lib/assets/images/test/pic1.png',
                  statusImagePath: statusImagePath,
                  cardColor: widget.levelCardColor.withOpacity(0.8),  // Keep the card color consistent
                  borderColor: widget.levelCardColor,
                  onTap: () {
                    if (type == 'lesson') {
                      _goToLessonPage(mapCardId);
                    } else if (type == 'test') {
                      _goToTestPage(mapCardId);
                    } else {
                      // Handle other types if needed
                    }
                  },
                  alignRight: type == 'lesson', // Align right if type is lesson
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
