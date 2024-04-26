import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/appbar.dart";
import "package:lingoneer_beta_0_0_1/components/subject_level_card.dart";
import "package:lingoneer_beta_0_0_1/pages/progress_map_page.dart";


class subjectLevelPage extends StatefulWidget {
  final int selectedCardIndex;

  const subjectLevelPage({
    super.key,
    required this.selectedCardIndex,
  });

  @override
  State<subjectLevelPage> createState() => _SubjectLevelPageState();
}

class _SubjectLevelPageState extends State<subjectLevelPage> {
  int selectedCardIndex = -1;

  void _goToProgressMapPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => progressMapPage(selectedCardIndex: index)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // card 1
            SubjectLevelCard(
              title: "Subject level 1",
             imagePath: 'lib/assets/images/test/pic1.png', 
             progressValue: 0.9, 
             cardColor: Colors.green, 
             progressColor: Colors.green[800]!, 
             onTap: () {
              _goToProgressMapPage(0);
             },
            ),

            // card 1
            SubjectLevelCard(
              title: "Subject level 1",
             imagePath: 'lib/assets/images/test/pic1.png', 
             progressValue: 0.9, 
             cardColor: Colors.green, 
             progressColor: Colors.green[800]!, 
             onTap: () {
              _goToProgressMapPage(0);
             },
            ),

            // card 1
            SubjectLevelCard(
              title: "Subject level 1",
             imagePath: 'lib/assets/images/test/pic1.png', 
             progressValue: 0.9, 
             cardColor: Colors.green, 
             progressColor: Colors.green[800]!, 
             onTap: () {
              _goToProgressMapPage(0);
             },
            ),

            // card 1
            SubjectLevelCard(
              title: "Subject level 1",
             imagePath: 'lib/assets/images/test/pic1.png', 
             progressValue: 0.9, 
             cardColor: Colors.green, 
             progressColor: Colors.green[800]!, 
             onTap: () {
              _goToProgressMapPage(0);
             },
            ),

          ],
        ),
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