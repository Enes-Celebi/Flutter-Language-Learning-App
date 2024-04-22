import "package:flutter/material.dart";

class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required int selectedCardIndex});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: const SingleChildScrollView(
        child: Text("this is the lesson page")),

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