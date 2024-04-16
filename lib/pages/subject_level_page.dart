import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/pages/progress_map_page.dart";

class subjectLevelPage extends StatefulWidget {
  final int selectedCardIndex;

  const subjectLevelPage({
    super.key,
    required this.selectedCardIndex,
  });

  @override
  State<subjectLevelPage> createState() => _SubjectLevelPageState();
}

class _SubjectLevelPageState extends State<subjectLevelPage> {
  int selectedCardIndex = -1;

  void _goToProgressMapPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => progressMapPage(selectedCardIndex: index)
      ),
    );
  }

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
                _goToProgressMapPage(0);
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 80, horizontal:  80),
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
                padding: const EdgeInsets.all(20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 80, horizontal:  80),
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
                padding: const EdgeInsets.all(20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 80, horizontal:  80),
                      child: Text(
                        'Card 3',
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