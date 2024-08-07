import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingoneer_beta_0_0_1/pages/test/test_component.dart';
import 'package:lingoneer_beta_0_0_1/pages/test/test_completion_page.dart';

class TestPage extends StatefulWidget {
  final String selectedCardIndex;

  const TestPage({
    Key? key,
    required this.selectedCardIndex,
  }) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int _currentIndex = 0;
  late List<Map<String, dynamic>> _testData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('tests')
            .where('mapcard', isEqualTo: widget.selectedCardIndex)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          _testData = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16), // Spacing below the progress bar
              Expanded(
                child: Center(
                  child: TestComponent( // Use the TestComponent here
                    imageUrl: _testData.isNotEmpty ? _testData[_currentIndex]['image'] : null,
                    question: _testData.isNotEmpty ? _testData[_currentIndex]['question'] : '',
                    text: _testData.isNotEmpty ? _testData[_currentIndex]['text'] : '',
                    progress: (_currentIndex + 1) / _testData.length,
                    onOptionSelected: _handleOptionSelection,
                    audioUrl: _testData.isNotEmpty ? _testData[_currentIndex]['audio'] : null,
                  ),
                ),
              ),
              const SizedBox(height: 16), // Spacing below the question
              Wrap(
                alignment: WrapAlignment.center, // Align the boxes in the center
                children: _testData[_currentIndex]['options'].map<Widget>((option) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust the spacing between boxes
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle option selection
                        _handleOptionSelection(option['correct']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Change button color here
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Reduce the border radius
                        ),
                      ),
                      child: Text(option['text']),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 60),
            ],
          );
        },
      ),
    );
  }

  void _handleOptionSelection(bool isCorrect) {
    showModalBottomSheet(
      context: context,
      isDismissible: false, // Disable dismissing by tapping outside
      builder: (BuildContext context) {
        return Container(
          width: double.infinity, // Make it as wide as the screen
          padding: const EdgeInsets.all(16),
          color: isCorrect ? Colors.lightGreen : const Color.fromARGB(255, 247, 106, 106), // Set background color
          child: Row(
            children: [
              Expanded(
                child: Text(
                  isCorrect ? 'Correct!' : 'Wrong Answer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green : Colors.red, // Set text color
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (isCorrect) {
                    if (_currentIndex < _testData.length - 1) {
                      setState(() {
                        _currentIndex++;
                      });
                    } else {
                      // Handle test completion
                      _showTestCompletionPage();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCorrect ? Colors.green : Colors.red, // Set button color
                ),
                child: Text(isCorrect ? 'Next Question' : 'Okay', style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTestCompletionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestCompletionPage(selectedCardIndex: widget.selectedCardIndex, isLesson: false),
      ),
    );
  }
}
