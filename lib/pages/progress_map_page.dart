import "package:flutter/material.dart";

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
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
                ),
              ],
            ),
            Positioned(
              top: 40,
              left: 10,
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
                      width: 8, // Width of the border
                    ),
                  ),
                  // child: const Icon(
                  //   Icons.account_circle_rounded, // Default profile picture icon
                  //   color: Colors.blue, // Color of the icon
                  //   size: 30, // Size of the icon
                  // ),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // First card
            GestureDetector(
              onTap: () {
                // card clicked function
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 150),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40, horizontal:  40),
                      child: Text(
                        'Card 1',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Second card
            GestureDetector(
              onTap: () {
                // card clicked function
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 150, right: 30),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40, horizontal:  40),
                      child: Text(
                        'Card 2',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Third card
            GestureDetector(
              onTap: () {
                // card clicked function
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 150),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40, horizontal:  40),
                      child: Text(
                        'Card 3',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Second card
            GestureDetector(
              onTap: () {
                // card clicked function
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 150, right: 30),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40, horizontal:  40),
                      child: Text(
                        'Card 2',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Third card
            GestureDetector(
              onTap: () {
                // card clicked function
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 150),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40, horizontal:  40),
                      child: Text(
                        'Card 3',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Second card
            GestureDetector(
              onTap: () {
                // card clicked function
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 150, right: 30),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40, horizontal:  40),
                      child: Text(
                        'Card 2',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Third card
            GestureDetector(
              onTap: () {
                // card clicked function
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 150),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40, horizontal:  40),
                      child: Text(
                        'Card 3',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Second card
            GestureDetector(
              onTap: () {
                // card clicked function
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 150, right: 30),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40, horizontal:  40),
                      child: Text(
                        'Card 2',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
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