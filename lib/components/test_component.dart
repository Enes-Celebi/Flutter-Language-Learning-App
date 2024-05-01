import 'package:flutter/material.dart';

class TestComponent extends StatelessWidget {
  final String? imageUrl;
  final String? audioUrl;
  final String question;
  final List<Map<String, dynamic>> options;
  final double progress;
  final Function(bool) onOptionSelected;

  const TestComponent({
    Key? key,
    required this.imageUrl,
    required this.question,
    required this.options,
    required this.audioUrl,
    required this.progress,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 50), // Padding from the top
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16), // Horizontal padding
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 15, // Increase the height
            backgroundColor: Colors.grey[300], // Background color
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue), // Progress color
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
        ),
        const SizedBox(height: 16), // Spacing below the progress bar
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imageUrl != null)
                  Image.network(
                    imageUrl!,
                    width: 200,
                    height: 200,
                  ),
                if (imageUrl != null) const SizedBox(height: 16), // Additional space between image and question
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16), // Horizontal padding for the question
                  child: Text(
                    question,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16), // Spacing below the question
        Wrap(
          alignment: WrapAlignment.center, // Align the boxes in the center
          children: options.map((option) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust the spacing between boxes
              child: ElevatedButton(
                onPressed: () {
                  // Handle option selection
                  onOptionSelected(option['correct']);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Change button color here
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Reduce the border radius
                  ),
                ),
                child: Text(option['text']),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
