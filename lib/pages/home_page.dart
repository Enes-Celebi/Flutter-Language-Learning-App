import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Turkish new'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Welcome message
            const Text(
              'Merhaba!', // Simple greeting
              style: TextStyle(fontSize: 22.0),
            ),
            const Text('Let\'s continue your Turkish learning journey!'),

            // Learning progress section (optional)
            const SizedBox(height: 20.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progress:'),
                Text('Level 2 (50% completed)'), // replace with your logic
              ],
            ),

            // Learning options section
            const SizedBox(height: 20.0),
            const Text('Choose your learning path:'),
            const SizedBox(height: 10.0),
            Wrap( // Wrap for responsive layout
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                InkWell(
                  onTap: () {
                    // navigate to vocabulary lessons screen
                  },
                  child: const Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Icon(Icons.book, size: 30.0),
                          Text('Vocabulary'),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // navigate to grammar lessons screen
                  },
                  child: const Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Icon(Icons.format_list_bulleted, size: 30.0),
                          Text('Grammar'),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // navigate to conversation practice screen
                  },
                  child: const Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Icon(Icons.chat, size: 30.0),
                          Text('Conversation'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Additional options (optional)
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // navigate to daily challenge screen
                  },
                  icon: const Icon(Icons.star),
                  label: const Text('Daily Challenge'),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // implement search functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
