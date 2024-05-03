import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/appbar.dart";
import "package:lingoneer_beta_0_0_1/components/progress_map_card.dart";
import "package:lingoneer_beta_0_0_1/pages/lesson_page.dart";
import "package:lingoneer_beta_0_0_1/pages/test_page.dart";

class progressMapPage extends StatefulWidget {
  final String selectedCardIndex;

  const progressMapPage({
    super.key,
    required this.selectedCardIndex,
  });
  // tr2en whole
  // ar2tr fizik

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
    return Scaffold(
      appBar: const CustomAppBar(),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('mapcards')
            .where('level', isEqualTo: widget.selectedCardIndex)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final mapCards = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Column(
              children: mapCards.map((mapCard) {
                final title = mapCard.get('name');
                final imageURL = mapCard.get('image');
                final type = mapCard.get('type');
                final mapCardId = mapCard.get('id');

                return ProgressMapCard(
                  title: title ?? 'No Title',
                  lessonImagePath: imageURL ?? 'lib/assets/images/test/pic1.png',
                  statusImagePath: 'lib/assets/images/icons/locked.png',
                  cardColor: Colors.blue[300]!,
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
