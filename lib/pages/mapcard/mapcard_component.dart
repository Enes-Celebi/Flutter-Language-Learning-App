import 'package:flutter/material.dart';

class ProgressMapCard extends StatelessWidget {
  final String title;
  final String lessonImagePath;
  final String statusImagePath;
  final Color cardColor;
  final Color borderColor;
  final VoidCallback onTap;
  final bool alignRight;

  const ProgressMapCard({
    super.key,
    required this.title,
    required this.lessonImagePath,
    required this.statusImagePath,
    required this.cardColor,
    required this.borderColor,
    required this.onTap,
    this.alignRight = false,
  });

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
        child: Stack(
          children: [
            SizedBox(
              width: 200,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: borderColor,
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
                      Image.network(
                        lessonImagePath,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'lib/assets/images/test/pic1.png',
                            width: 50,
                            height: 50,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 15,
              right: 15,
              child: Image.asset(
                statusImagePath,
                width: 30,
                height: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
