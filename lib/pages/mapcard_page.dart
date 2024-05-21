import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/appbar_component.dart";
import "package:lingoneer_beta_0_0_1/components/mapcard_component.dart";
import "package:lingoneer_beta_0_0_1/pages/lesson_page.dart";
import "package:lingoneer_beta_0_0_1/pages/test_page.dart";

class progressMapPage extends StatefulWidget {
  final String selectedCardIndex;
  final String selectedSubjectIndex;


  const progressMapPage({
    super.key,
    required this.selectedCardIndex,
    required this.selectedSubjectIndex,
  });

  @override
  State<progressMapPage> createState() => _progressMapPageState();
}

class _progressMapPageState extends State<progressMapPage> {
  void _goToLessonPage(String mapcardId) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonPage(selectedCardIndex: mapcardId),
      ),
    );
  }

  void _goToTestPage(String mapcardId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestPage(selectedCardIndex: mapcardId),
        
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

        final mapCards = mapCardsSnapshot.docs;
        final donelessonIds = progressSnapshot.docs.map((doc) => doc['lessonId']).toList();


        return SingleChildScrollView(
          child: Column(
            children: mapCards.map((mapCard) {
              final title = mapCard.get('name');
              final imageURL = mapCard.get('image');
              final type = mapCard.get('type');
              final mapCardId = mapCard.get('id');

              final bool isSelectedCardIndexInLessonIds = donelessonIds.contains(mapCardId);

              return ProgressMapCard(
                title: title ?? 'No Title',
                lessonImagePath: imageURL ?? 'lib/assets/images/test/pic1.png',
                statusImagePath: 'lib/assets/images/icons/locked.png',
                cardColor: isSelectedCardIndexInLessonIds ? Colors.green[300]! : Colors.blue[300]!,
                borderColor: Colors.blue[200]!,
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