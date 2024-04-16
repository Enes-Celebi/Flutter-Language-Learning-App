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
              ),
            ],
          ),
          Positioned(
            top: 18,
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

      body: PageView(
        children: const [
          //cards
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