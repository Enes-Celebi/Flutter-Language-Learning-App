import 'package:flutter/material.dart';

class TestComponent extends StatefulWidget {
  final String? imageUrl;
  final String? audioUrl;
  final String question;
  final String text;
  final double progress;
  final Function(bool) onOptionSelected;

  const TestComponent({
    Key? key,
    required this.imageUrl,
    required this.question,
    required this.text,
    required this.progress,
    required this.onOptionSelected,
    required this.audioUrl,
  }) : super(key: key);

  @override
  _TestComponentState createState() => _TestComponentState();
}

class _TestComponentState extends State<TestComponent> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400), // Reduced duration for faster transition
    );

    // Create a Tween to animate the progress
    final Animation<double> curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut, // Smoother curve for transition
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(curve);

    // Start the animation only if the progress is greater than the previous value
    if (widget.progress > 0.0) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(TestComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the progress is greater than the previous value and animate accordingly
    if (widget.progress > oldWidget.progress) {
      _animation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(_animationController);
      _animationController.forward(from: 0.0); // Start the animation from the beginning
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 50), // Padding from the top
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16), // Horizontal padding
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return LinearProgressIndicator(
                value: _animation.value,
                minHeight: 15, // Increase the height
                backgroundColor: Colors.grey[300], // Background color
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getColorForProgress(_animation.value), // Determine color based on progress value
                ),
                borderRadius: BorderRadius.circular(10), // Rounded corners
              );
            },
          ),
        ),
        const SizedBox(height: 16), // Spacing below the progress bar
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.imageUrl != null) _buildImageWidget(widget.imageUrl!),
                const SizedBox(height: 16), // Additional space between image and question
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16), // Horizontal padding for the question
                  child: Text(
                    widget.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 50), // Additional space between question and text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16), // Horizontal padding for the text
                  child: Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getColorForProgress(double progress) {
    return Color.lerp(Colors.blue, Colors.yellow, progress)!;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildImageWidget(String url) {
    return Image.network(
      url,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'lib/assets/images/icons/undone.png',
          width: 150,
          height: 150,
        );
      },
    );
  }
}
