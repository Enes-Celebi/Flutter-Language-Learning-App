import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/lesson_component.dart";

class LessonPage extends StatefulWidget {
  final String selectedCardIndex;

  const LessonPage({
    super.key, 
    required this.selectedCardIndex
  });

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  int _currentIndex = 0;
  late List<Map<String, dynamic>> _lessonData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('lessons')
            .where('mapcard', isEqualTo: widget.selectedCardIndex)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          

          _lessonData = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

          return Column(
            children: [
              Expanded(
                child: LessonComponent(
                  explanation: _lessonData[_currentIndex]['explanation'] ?? '',
                  imageUrl: _lessonData[_currentIndex]['image'] ?? null,
                  audioUrl: _lessonData[_currentIndex]['audio'] ?? null,
                  progress: (_currentIndex + 1) / _lessonData.length,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_currentIndex > 0) {
                        setState(() {
                          _currentIndex--;
                        });
                      }
                    },
                    child: Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentIndex < _lessonData.length - 1) {
                        setState(() {
                          _currentIndex++;
                        });
                      }
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ],
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