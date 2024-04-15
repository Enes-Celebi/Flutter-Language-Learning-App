import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Stack(
        children: [
          Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: const Color.fromARGB(255, 224, 224, 224),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                title: const Text(
                  'Home',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          Positioned(
            top: 25,
            left: 16,
            child: GestureDetector(
              onTap: () {
                // go to profile & settings page
              },
              child: Container(
                width: 60, // Adjusted width to accommodate the border thickness
                height: 60, // Adjusted height to accommodate the border thickness
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // Background color of the circle
                  border: Border.all(
                    color: Colors.white, // Color of the border
                    width: 10, // Width of the border
                  ),
                ),
                child: const Icon(
                  Icons.account_circle_rounded, // Default profile picture icon
                  color: Colors.blue, // Color of the icon
                  size: 50, // Size of the icon
                ),
              ),
            ),
          ),
        ],
      ),
    ),

      body: PageView(
        children: [
          // First card
          Transform.translate(
            offset: const Offset(0, -30), // Adjust the value to move it up or down
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    'Card 1',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
          ),

          // Second card
          Transform.translate(
            offset: const Offset(0, -30), // Adjust the value to move it up or down
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    'Card 2',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
          ),

          // Third card
          Transform.translate(
            offset: const Offset(0, -30), // Adjust the value to move it up or down
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    'Card 3',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add onPressed function to handle button tap
        },
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}