import 'package:flutter/material.dart';

class TestComponent extends StatelessWidget {
  final String question;
  final String? imageUrl;
  final String? audioUrl;
  //final List<String> options; // Updated to list of strings
  final VoidCallback onBackButtonPressed;
  final double progress;

  const TestComponent({
    super.key,
    required this.question,
    required this.imageUrl,
    required this.audioUrl,
    //required this.options,
    required this.progress,
    required this.onBackButtonPressed
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LinearProgressIndicator(value: progress),
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackButtonPressed,
            ),
            title: const Text('Lesson'),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  _buildQuestionContent(),
                  const SizedBox(height: 20),
                  Text(question),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent() {
    if (imageUrl != null && audioUrl == null) {
      return _buildImageWidget(imageUrl!);
    } else if (audioUrl != null && imageUrl == null) {
      return InkWell(
        onTap: () {
          // Handle audio playback
        },
        child: Icon(Icons.volume_up),
      );
    } else if (imageUrl != null && audioUrl != null) {
      // Display both image and audio
      return Column(
        children: [
          _buildImageWidget(imageUrl!),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              // Handle audio playback
            },
            child: Icon(Icons.volume_up),
          ),
        ],
      );
    } else {
      // You can customize the placeholder for when there's neither image nor audio
      return const SizedBox.shrink(); // to remove the empty space
    }
  }

  Widget _buildImageWidget(String url) {
    return imageUrl != null
        ? Image.network(url)
        : Image.asset('lib/assets/images/flags/egypt.png'); // Local image asset path
  }
}