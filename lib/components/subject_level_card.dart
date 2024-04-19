import 'package:flutter/material.dart';

class SubjectLevelCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color cardColor;
  final double progressValue;
  final Color progressColor;
  final VoidCallback onTap;

  const SubjectLevelCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.cardColor,
    required this.progressValue,
    required this.progressColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      imagePath,
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        height: 20,
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: LinearProgressIndicator(
                            value: progressValue,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 16, 93, 155),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
