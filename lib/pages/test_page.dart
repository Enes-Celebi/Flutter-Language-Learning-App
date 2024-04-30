import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lingoneer_beta_0_0_1/components/test_component.dart';

class TestPage extends StatefulWidget {
  final String selectedCardIndex;

  const TestPage({
    super.key,
    required this.selectedCardIndex,
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int _currentIndex = 0;
  late List<Map<String, dynamic>> _lessonData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('tests')
            //.where('mapcard', isEqualTo: widget.selectedCardIndex)
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
                child: TestComponent(
                  question: _lessonData[_currentIndex]['question'] ?? '',
                  imageUrl: _lessonData[_currentIndex]['image'] ?? null,
                  audioUrl: _lessonData[_currentIndex]['audio'] ?? null,
                  onBackButtonPressed: () {
                    if (_currentIndex > 0) {
                      setState(() {
                        _currentIndex--;
                      });
                    }
                  },
                  progress: _currentIndex / _lessonData.length,
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