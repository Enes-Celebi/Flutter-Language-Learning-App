import 'package:flutter/material.dart';

class TestComponent extends StatelessWidget {
  final String question;
  final String? imageUrl;
  final String? audioUrl;
  final List<String> options; // Adding options
  final double progress;

  const TestComponent({
    Key? key,
    required this.question,
    required this.imageUrl,
    required this.audioUrl,
    required this.options, // Adding options
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: progress),
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
                  const SizedBox(height: 20),
                  _buildOptions(), // Adding options
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

  Widget _buildOptions() {
    return Column(
      children: options.map((option) {
        return Text(option);
      }).toList(),
    );
  }
}
