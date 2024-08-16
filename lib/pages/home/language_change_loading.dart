import 'package:flutter/material.dart';

class LanguageChangeLoading extends StatefulWidget {
  final VoidCallback onComplete;
  final String imagePath;
  final Duration slideDuration;
  final Duration waitDuration;
  final Duration fadeDuration;

  const LanguageChangeLoading({
    super.key,
    required this.onComplete,
    required this.imagePath,
    this.slideDuration = const Duration(milliseconds: 400),
    this.waitDuration = const Duration(seconds: 2),
    this.fadeDuration = const Duration(milliseconds: 500),
  });

  @override
  _LanguageChangeLoadingState createState() => _LanguageChangeLoadingState();
}

class _LanguageChangeLoadingState extends State<LanguageChangeLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.slideDuration + widget.waitDuration + widget.fadeDuration,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          widget.slideDuration.inMilliseconds / (_controller.duration?.inMilliseconds ?? 1),
          curve: Curves.easeInOut,
        ),
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          (widget.slideDuration.inMilliseconds + widget.waitDuration.inMilliseconds) / (_controller.duration?.inMilliseconds ?? 1),
          1.0,
        ),
      ),
    );

    _controller.forward().whenComplete(widget.onComplete);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.white,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(widget.imagePath, width: 150, height: 150),
                  SizedBox(height: 20), // Space between flag and loading indicator
                  CircularProgressIndicator(), // Loading indicator
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
