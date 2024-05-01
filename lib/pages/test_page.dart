import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  final String selectedCardIndex;

  const TestPage({
    super.key,
    required this.selectedCardIndex
  });
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              final data = document.data() as Map<String, dynamic>;

              return TestComponent(
                imageUrl: data['image'],
                question: data['question'],
                options: List<Map<String, dynamic>>.from(data['options'] ?? []),
              );
            },
          );
        },
      ),
    );
  }
}

class TestComponent extends StatelessWidget {
  final String? imageUrl;
  final String question;
  final List<Map<String, dynamic>> options;

  const TestComponent({
    Key? key,
    required this.imageUrl,
    required this.question,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageUrl != null)
          Image.network(
            imageUrl!,
            width: 200,
            height: 200,
          ),
        Text(question),
        Column(
          children: options.map((option) {
            return ListTile(
              title: Text(option['text']),
              onTap: () {
                // Handle option selection
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
