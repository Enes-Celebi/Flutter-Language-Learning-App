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

      body: SingleChildScrollView(
        child: Column(
          children: [

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              lessonImagePath: 'lib/assets/images/test/pic1.png', 
              statusImagePath: 'lib/assets/images/icons/done.png', 
              cardColor: Colors.blue[300]!, 
              borderColor: Colors.blue[200]!,
              onTap: () {
                _goToLessonPage(0);
              },
              alignRight: true,
            ),
            
            // first card
            ProgressMapCard(
              title: "lesson 1", 
              lessonImagePath: 'lib/assets/images/test/pic1.png', 
              statusImagePath: 'lib/assets/images/icons/done.png', 
              cardColor: Colors.blue[300]!, 
              borderColor: Colors.blue[200]!,
              onTap: () {
                _goToTestPage(0);
              },
              alignRight: false,
            ),
            
            // first card
            ProgressMapCard(
              title: "lesson 1", 
              lessonImagePath: 'lib/assets/images/test/pic1.png', 
              statusImagePath: 'lib/assets/images/icons/done.png', 
              cardColor: Colors.blue[300]!, 
              borderColor: Colors.blue[200]!,
              onTap: () {
                _goToLessonPage(0);
              },
              alignRight: true,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              lessonImagePath: 'lib/assets/images/test/pic1.png', 
              statusImagePath: 'lib/assets/images/icons/undone.png', 
              cardColor: Colors.blue[600]!, 
              borderColor: Colors.blue[400]!,
              onTap: () {
                _goToTestPage(0);
              },
              alignRight: false,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              lessonImagePath: 'lib/assets/images/test/pic1.png', 
              statusImagePath: 'lib/assets/images/icons/locked.png', 
              cardColor: Colors.grey, 
              borderColor: Colors.grey[400]!,
              onTap: () {
                _goToLessonPage(0);
              },
              alignRight: true,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              lessonImagePath: 'lib/assets/images/test/pic1.png',
              statusImagePath: 'lib/assets/images/icons/locked.png',  
              cardColor: Colors.grey, 
              borderColor: Colors.grey[400]!,
              onTap: () {
                _goToTestPage(0);
              },
              alignRight: false,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              lessonImagePath: 'lib/assets/images/test/pic1.png', 
              statusImagePath: 'lib/assets/images/icons/locked.png', 
              cardColor: Colors.grey, 
              borderColor: Colors.grey[400]!,
              onTap: () {
                _goToLessonPage(0);
              },
              alignRight: true,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              lessonImagePath: 'lib/assets/images/test/pic1.png', 
              statusImagePath: 'lib/assets/images/icons/locked.png', 
              cardColor: Colors.grey, 
              borderColor: Colors.grey[400]!,
              onTap: () {
                _goToTestPage(0);
              },
              alignRight: false,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              lessonImagePath: 'lib/assets/images/test/pic1.png', 
              statusImagePath: 'lib/assets/images/icons/locked.png', 
              cardColor: Colors.grey, 
              borderColor: Colors.grey[400]!,
              onTap: () {
                _goToLessonPage(0);
              },
              alignRight: true,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              lessonImagePath: 'lib/assets/images/test/pic1.png', 
              statusImagePath: 'lib/assets/images/icons/locked.png', 
              cardColor: Colors.grey, 
              borderColor: Colors.grey[400]!,
              onTap: () {
                                _goToTestPage(0);
              },
              alignRight: false,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              lessonImagePath: 'lib/assets/images/test/pic1.png', 
              statusImagePath: 'lib/assets/images/icons/locked.png', 
              cardColor: Colors.grey, 
              borderColor: Colors.grey[400]!,
              onTap: () {
                _goToLessonPage(0);
              },
              alignRight: true,
            ),

            
            ProgressMapCard(
              title: "lesson 1", 
              lessonImagePath: 'lib/assets/images/test/pic1.png', 
              statusImagePath: 'lib/assets/images/icons/locked.png', 
              cardColor: Colors.grey, 
              borderColor: Colors.grey[400]!,
              onTap: () {
                _goToTestPage(0);
              },
              alignRight: false,
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