import "package:flutter/material.dart";

class ProgressMapCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color cardColor;
  final VoidCallback onTap;
  final bool alignRight; // Removed 'const' keyword

  const ProgressMapCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.cardColor,
    required this.onTap,
    this.alignRight = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          bottom: 20,
          left: alignRight ? 30 : 150,
          right: alignRight ? 150 : 30,
        ),
        child: SizedBox(
          width: 200,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 10,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Image.asset(
                    imagePath,
                    width: 50,
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
