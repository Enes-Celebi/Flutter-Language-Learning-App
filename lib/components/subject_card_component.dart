import "package:flutter/material.dart";

class MyMainCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final double progressValue;
  final Color cardColor;
  final Color progressColor;
  final VoidCallback onTap;

  const MyMainCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.progressValue,
    required this.cardColor,
    required this.progressColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.translate(
        offset: const Offset(0, -30),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 35),//value
                Image.asset(
                  imagePath,
                  width: 150,//value
                  height: 150,//value
                ),
                const SizedBox(height: 35),//value
                SizedBox(
                  height: 20,//value
                  width: 200,//value
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      color: progressColor,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}