import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/progress_map_card.dart";

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
            
            // first card
            ProgressMapCard(
              title: "lesson 1", 
              imagePath: 'lib/assets/images/test/pic1.png', 
              cardColor: Colors.blue, 
              onTap: () {},
              alignRight: false,
            ),
            
            // first card
            ProgressMapCard(
              title: "lesson 1", 
              imagePath: 'lib/assets/images/test/pic1.png', 
              cardColor: Colors.blue, 
              onTap: () {},
              alignRight: true,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              imagePath: 'lib/assets/images/test/pic1.png', 
              cardColor: Colors.blue, 
              onTap: () {},
              alignRight: false,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              imagePath: 'lib/assets/images/test/pic1.png', 
              cardColor: Colors.blue, 
              onTap: () {},
              alignRight: true,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              imagePath: 'lib/assets/images/test/pic1.png', 
              cardColor: Colors.blue, 
              onTap: () {},
              alignRight: false,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              imagePath: 'lib/assets/images/test/pic1.png', 
              cardColor: Colors.blue, 
              onTap: () {},
              alignRight: true,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              imagePath: 'lib/assets/images/test/pic1.png', 
              cardColor: Colors.blue, 
              onTap: () {},
              alignRight: false,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              imagePath: 'lib/assets/images/test/pic1.png', 
              cardColor: Colors.blue, 
              onTap: () {},
              alignRight: true,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              imagePath: 'lib/assets/images/test/pic1.png', 
              cardColor: Colors.blue, 
              onTap: () {},
              alignRight: false,
            ),

            // first card
            ProgressMapCard(
              title: "lesson 1", 
              imagePath: 'lib/assets/images/test/pic1.png', 
              cardColor: Colors.blue, 
              onTap: () {},
              alignRight: true,
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