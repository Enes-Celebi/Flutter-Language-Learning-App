import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle), // Placeholder icon for user profile picture
            onPressed: () {
              // Add onPressed function to navigate to user profile page
            },
          ),
        ],
      ),
      body: PageView(
        children: [
          // First card
          Container(
            color: Colors.blue,
            child: Center(
              child: Text(
                'Card 1',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          // Second card
          Container(
            color: Colors.green,
            child: Center(
              child: Text(
                'Card 2',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add onPressed function to handle button tap
        },
        child: Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
