import "package:flutter/material.dart";

class FirstTimeFlag extends StatelessWidget {
  final String title;
  final String imagePath;
  final Function() onImageClicked; // Callback function for image click

  const FirstTimeFlag({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onImageClicked, // Pass the callback function
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onImageClicked(), // Call the callback function on tap
      child: Transform.translate(
        offset: const Offset(0, -30),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 35),
                InkWell( // Wrap the image with InkWell for click effect
                  onTap: () => onImageClicked(), // Call the callback function on tap
                  child: Image.asset(
                    imagePath,
                    width: 170,
                  ),
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
