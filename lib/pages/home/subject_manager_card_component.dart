import 'package:flutter/material.dart';

class SubjectManagerCardComponent extends StatefulWidget {
  final Animation<Offset> slideAnimation; // Animation to control sliding

  const SubjectManagerCardComponent({
    super.key,
    required this.slideAnimation, // Require animation parameter
  });

  @override
  _SubjectManagerCardComponentState createState() => _SubjectManagerCardComponentState();
}

class _SubjectManagerCardComponentState extends State<SubjectManagerCardComponent> {
  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    return SlideTransition(
      position: widget.slideAnimation, // Use the animation for sliding
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 35), // Adjusted vertical padding
        child: Container(
          width: screenWidth - 50, // Width adjusted for padding
          height: 100, // Set height for a shorter card
          decoration: BoxDecoration(
            color: Colors.blue, // Set the card color to blue
            borderRadius: BorderRadius.circular(25), // Rounded corners
          ),
        ),
      ),
    );
  }
}
