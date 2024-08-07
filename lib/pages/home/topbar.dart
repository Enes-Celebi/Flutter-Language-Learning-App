import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lingoneer_beta_0_0_1/components/appbar_component.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:lingoneer_beta_0_0_1/services/language_provider.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? intendedLanguageImage;
  final bool isArrowDown;
  final VoidCallback onArrowToggle;
  final List<DocumentSnapshot> availableLanguages;
  final List<AnimationController> flagAnimationControllers;
  final List<Animation<double>> flagSizeAnimations;
  final Animation<double> textAppearanceAnimation;

  const TopBar({
    super.key,
    required this.intendedLanguageImage,
    required this.isArrowDown,
    required this.onArrowToggle,
    required this.availableLanguages,
    required this.flagAnimationControllers,
    required this.flagSizeAnimations,
    required this.textAppearanceAnimation,
  });

  @override
  Size get preferredSize => const Size.fromHeight(135.0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Allow content to overflow
      children: [
        CustomBar(
          height: 135,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (intendedLanguageImage != null)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 50.0),
                  child: Image.asset(
                    intendedLanguageImage!,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              GestureDetector(
                onTap: onArrowToggle,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 50.0),
                  child: Icon(
                    isArrowDown ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                    size: 40,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 20.0, top: 10.0),
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Lottie.asset(
                    'lib/assets/images/animations/flame1.json',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isArrowDown)
          Positioned(
            top: 135.0, // Position below the top bar
            left: 20.0,
            child: _buildLanguageListView(context),
          ),
      ],
    );
  }

  Widget _buildLanguageListView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: availableLanguages.asMap().entries.map((entry) {
        final index = entry.key;
        final languageData = entry.value;
        final imageURL = languageData.get('image') ?? 'lib/assets/images/test/pic1.png';
        final languageName = languageData.get('translation')?[Provider.of<LanguageProvider>(context).selectedLanguage] ?? 'Unknown';
        final languageId = languageData.get('language');

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: GestureDetector(
            onTap: () {
              Provider.of<LanguageProvider>(context, listen: false).updateIntendedLanguage(languageId);
              // Trigger these methods if needed from HomePage
              // _fetchAvailableLanguages();
              // _fetchIntendedLanguageImage();
              onArrowToggle(); // Trigger arrow toggle to hide language list
            },
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: flagAnimationControllers[index],
                  builder: (context, child) {
                    return Transform.scale(
                      scale: flagSizeAnimations[index].value,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    child: Image.asset(
                      imageURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FadeTransition(
                  opacity: textAppearanceAnimation,
                  child: Text(
                    languageName,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
