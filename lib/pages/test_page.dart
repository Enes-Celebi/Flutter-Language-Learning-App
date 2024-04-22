import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TestPage extends StatefulWidget {
  const TestPage({Key? key, required this.selectedCardIndex}) : super(key: key);

  final int selectedCardIndex;

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<Map<String, dynamic>> questions = []; // List to store fetched questions
  int currentQuestionIndex = 0; // Index of the current question
  String? _selectedOption; // Variable to store the selected option for multiple-choice questions
  String _userAnswer = ''; // Variable to store the user's answer for fill-in-the-blank questions

  @override
  void initState() {
    super.initState();
    // Fetch questions when the widget initializes
    fetchQuestions();
  }

  // Function to fetch questions
  void fetchQuestions() async {
    // Sample JSON structure for quiz questions
    List<Map<String, dynamic>> sampleQuestions = [
      {
        'question_text': 'What is the capital of France?',
        'type': 'multiple_choice',
        'options': ['Paris', 'London', 'Berlin', 'Rome'],
        'correct_answer': 'Paris',
      },
      {
        'question_text': 'Which animal can fly?',
        'type': 'multiple_choice',
        'options': ['Dog', 'Cat', 'Bird', 'Fish'],
        'correct_answer': 'Bird',
      },
      {
        'question_text': 'What is 10 + 5?',
        'type': 'fill_in_the_blank',
        'correct_answer': '15',
      },
    ];

    // Assign sample questions to 'questions' list
    questions = sampleQuestions;
    // Trigger a rebuild to display questions
    setState(() {});
  }

  // Function to move to the next question
  void _moveToNextQuestion() {
    setState(() {
      currentQuestionIndex++; // Move to the next question
      _selectedOption = null; // Reset selected option
      _userAnswer = ''; // Reset user's answer
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display fetched questions
            if (questions.isNotEmpty && currentQuestionIndex < questions.length)
              _buildQuestionCard(questions[currentQuestionIndex]),
            if (currentQuestionIndex >= questions.length)
              const Center(child: Text('Quiz completed!')),
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

  // Function to build a card for each question
  Widget _buildQuestionCard(Map<String, dynamic> question) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question_text'],
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            // Display question based on its type
            if (question['type'] == 'multiple_choice')
              _buildMultipleChoiceQuestion(question),
            // Add other types of questions here
          ],
        ),
      ),
    );
  }

  // Function to build UI for multiple-choice question
  Widget _buildMultipleChoiceQuestion(Map<String, dynamic> question) {
    List<String> options = question['options'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < options.length; i++)
          RadioListTile(
            title: Text(options[i]),
            value: options[i],
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value; // Update selected option
              });
              // After selecting an option, navigate to the next question
              _moveToNextQuestion();
            },
          ),
      ],
    );
  }
}
