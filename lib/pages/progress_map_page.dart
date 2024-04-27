import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/appbar.dart";
import "package:lingoneer_beta_0_0_1/components/progress_map_card.dart";
import "package:lingoneer_beta_0_0_1/pages/lesson_page.dart";
import "package:lingoneer_beta_0_0_1/pages/test_page.dart";

class progressMapPage extends StatefulWidget {
  final int selectedCardIndex;

  const progressMapPage({
    super.key,
    required this.selectedCardIndex
  });

  @override
  State<progressMapPage> createState() => _progressMapPageState();
}

class _progressMapPageState extends State<progressMapPage> {
  int selectedCardIndex = -1;

  void _goToLessonPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonPage(selectedCardIndex: index),
      ),
    );
  }

  void _goToTestPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestPage(selectedCardIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('mapcards').get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }


          final Mapcards = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Column(
              children: Mapcards.map((Mapcards) {
                final title = Mapcards.get('name');
                final imageURL = Mapcards.get('image');

                return ProgressMapCard(
                  title: title ?? 'No Title', 
                  lessonImagePath: imageURL ?? 'lib/assets/images/test/pic1.png', 
                  statusImagePath: 'lib/assets/images/icons/locked.png', 
                  cardColor: Colors.blue[200]!, 
                  borderColor: Colors.blue[200]!, 
                  onTap: () => _goToLessonPage(0),
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