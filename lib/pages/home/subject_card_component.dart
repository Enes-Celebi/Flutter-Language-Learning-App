import 'package:flutter/material.dart';

class MyMainCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final double progressValue;
  final Color cardColor; // This will be used for the border color
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
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Transform.translate(
        offset: const Offset(0, -30),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80, left: 25, right: 25, top: 50),
          child: Container(
            width: screenWidth - 50, // Width adjusted for padding
            height: screenHeight * 0.4, // Set height relative to screen height
            decoration: BoxDecoration(
              color: Colors.white, // Set the card color to white
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Color.fromARGB(255, 219, 219, 219), // Use the provided color for the border
                width: 8, // Set the border width
              ),
            ),
            child: Stack(
              children: [
                // Centered content
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        imagePath,
                        width: 150, // Set the image width
                        height: 150, // Set the image height
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'lib/assets/images/test/pic1.png',
                            width: 150, // Set the image width
                            height: 150, // Set the image height
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Custom Progress Circle
                Positioned(
                  bottom: 20, // Distance from the bottom
                  left: 20, // Distance from the left
                  child: SizedBox(
                    height: 60, // Size of the progress circle
                    width: 60, // Size of the progress circle
                    child: CustomPaint(
                      painter: ProgressCirclePainter(
                        progressValue: progressValue,
                        progressColor: progressColor,
                      ),
                    ),
                  ),
                ),
                // Rectangle next to the progress circle
                Positioned(
                  bottom: 30, // Bottom padding of 30
                  left: 100, // Left padding of 30
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: cardColor, // Background color of the rectangle
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    height: 40, // Stable height for the rectangle
                    constraints: const BoxConstraints(
                      maxWidth: 150, // Maximum width of the rectangle
                    ),
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressCirclePainter extends CustomPainter {
  final double progressValue;
  final Color progressColor;

  ProgressCirclePainter({
    required this.progressValue,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final double progressAngle = 2 * 3.141592653589793 * progressValue;

    // Draw the background circle if progressValue is 0
    if (progressValue == 0) {
      final Paint backgroundPaint = Paint()
        ..color = Colors.grey[300]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8;

      canvas.drawCircle(center, radius, backgroundPaint);
    }

    // Draw the progress circle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      progressAngle,
      false,
      progressPaint,
    );

    // Draw the percentage text
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '${(progressValue * 100).toStringAsFixed(0)}%',
        style: TextStyle(
          color: progressColor,
          fontSize: 16,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    final Offset textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
