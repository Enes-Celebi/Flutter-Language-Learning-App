import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/appbar.dart";
import "package:lingoneer_beta_0_0_1/components/subject_level_card.dart";
import "package:lingoneer_beta_0_0_1/pages/progress_map_page.dart";
import "package:lingoneer_beta_0_0_1/services/language_provider.dart";
import "package:provider/provider.dart";


class subjectLevelPage extends StatefulWidget {
  final String selectedCardIndex;

  const subjectLevelPage({
    super.key,
    required this.selectedCardIndex,
  });

  @override
  State<subjectLevelPage> createState() => _SubjectLevelPageState();
}

class _SubjectLevelPageState extends State<subjectLevelPage> {

  void _goToProgressMapPage(String levelId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => progressMapPage(selectedCardIndex: levelId)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
        .collection('levels')
        .where('subject', isEqualTo: widget.selectedCardIndex)
        .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final Levels = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Column(
              children: Levels.map((Levels) {
                final title = Levels.get('name');
                final imageURL = Levels.get('image');
                final levelId = Levels.get('id');

                return SubjectLevelCard(
                  title: title ?? 'No Title', // Set default title if "name" is missing
                  imagePath: imageURL ?? 'lib/assets/images/test/pic1.png',
                  progressValue: 0.5,
                  cardColor: Colors.blue,
                  progressColor: Colors.blue.shade700,
                  onTap: () => _goToProgressMapPage(levelId), // Use document ID for navigation (optional)
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