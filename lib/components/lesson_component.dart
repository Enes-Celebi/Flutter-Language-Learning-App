import 'package:flutter/material.dart';

class LessonComponent extends StatelessWidget {
  final String explanation;
  final String? imageUrl;
  final String? audioUrl;
  final double progress;

  const LessonComponent({
    super.key,
    required this.explanation,
    required this.imageUrl,
    required this.audioUrl,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 50),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 15,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            borderRadius: BorderRadius.circular(10),
          )
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _buildQuestionContent(),
                const SizedBox(height: 20),
                Text(explanation),
              ],
            ),
          ),
        ),
      ],
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



