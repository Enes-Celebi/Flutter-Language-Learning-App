import 'package:flutter/material.dart';

class LessonComponent extends StatefulWidget {
  final String explanation1;
  final String explanation2;
  final String? imageUrl;
  final String? audioUrl;
  final double progress;

  const LessonComponent({
    Key? key,
    required this.explanation1,
    required this.explanation2,
    required this.imageUrl,
    required this.audioUrl,
    required this.progress,
  }) : super(key: key);

  @override
  _LessonComponentState createState() => _LessonComponentState();
}

class _LessonComponentState extends State<LessonComponent> with TickerProviderStateMixin {
  bool isExplanation2Visible = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400), // Faster transition
    );

    final Animation<double> curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(curve);

    if (widget.progress > 0.0) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(LessonComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.progress > oldWidget.progress) {
      _animation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(_animationController);
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 50),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return LinearProgressIndicator(
                value: _animation.value,
                minHeight: 15,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getColorForProgress(_animation.value),
                ),
                borderRadius: BorderRadius.circular(10),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.imageUrl != null) _buildImageWidget(widget.imageUrl!),
                if (widget.audioUrl != null)
                  InkWell(
                    onTap: () {
                      // Handle audio playback
                    },
                    child: const Icon(Icons.volume_up),
                  ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExplanation2Visible = !isExplanation2Visible;
                    });
                  },
                  child: Text(
                    widget.explanation1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: isExplanation2Visible ? 1.0 : 0.0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: Text(
                      widget.explanation2,
                      style: TextStyle(fontSize: 16),
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
