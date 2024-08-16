import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingoneer_beta_0_0_1/components/appbar_component.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:lingoneer_beta_0_0_1/services/language_provider.dart';
import 'package:lingoneer_beta_0_0_1/pages/home/data_fetch.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isArrowDown;
  final VoidCallback onArrowToggle;
  final Function(String languageId) onLanguageSelected;
  final Function(String imageURL, Offset flagPosition) onFlagClicked; // Updated callback
  final String imagePath; // New parameter for the image path

  const TopBar({
    super.key,
    required this.isArrowDown,
    required this.onArrowToggle,
    required this.onLanguageSelected,
    required this.onFlagClicked,
    required this.imagePath, // Include imagePath in constructor
  });

  @override
  _TopBarState createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(135.0);
}

class _TopBarState extends State<TopBar> {
  String? _intendedLanguageImage;
  List<DocumentSnapshot> _availableLanguages = [];
  bool _isFlagsVisible = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _fetchIntendedLanguageImage();
    _fetchAvailableLanguages();
  }

  @override
  void didUpdateWidget(TopBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isArrowDown != oldWidget.isArrowDown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isFlagsVisible = !widget.isArrowDown;
          if (_isFlagsVisible) {
            _showOverlay();
          } else {
            _hideOverlay();
          }
        });
      });
    }
  }

  Future<void> _fetchIntendedLanguageImage() async {
    final intendedLanguageId = Provider.of<LanguageProvider>(context, listen: false).intendedSelectedLanguage;
    final image = await DataFetch.fetchIntendedLanguageImage(intendedLanguageId);
    setState(() {
      _intendedLanguageImage = image;
    });
  }

  Future<void> _fetchAvailableLanguages() async {
    final selectedLanguageId = Provider.of<LanguageProvider>(context, listen: false).selectedLanguage;
    final intendedLanguageId = Provider.of<LanguageProvider>(context, listen: false).intendedSelectedLanguage;

    try {
      final filteredLanguages = await DataFetch.fetchAvailableLanguages(selectedLanguageId!, intendedLanguageId);
      setState(() {
        _availableLanguages = filteredLanguages;
        if (_isFlagsVisible) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showOverlay();
          });
        }
      });
    } catch (e) {
      print('Error fetching available languages: $e');
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    _hideOverlay(); // Ensure previous overlay entry is removed before adding a new one

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 135.0,
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: _buildLanguageListView(context),
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomBar(
          height: 135,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (_intendedLanguageImage != null)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 50.0),
                  child: Image.asset(
                    _intendedLanguageImage!,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              GestureDetector(
                onTap: () {
                  widget.onArrowToggle();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 50.0),
                  child: Icon(
                    widget.isArrowDown ? Icons.arrow_drop_down : Icons.arrow_drop_up,
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
      ],
    );
  }

Widget _buildLanguageListView(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: _availableLanguages.asMap().entries.map((entry) {
      final index = entry.key;
      final languageData = entry.value;
      final imageURL = languageData.get('image') ?? 'lib/assets/images/test/pic1.png';
      final languageName = languageData.get('translation')?[Provider.of<LanguageProvider>(context).selectedLanguage] ?? 'Unknown';
      final languageId = languageData.get('language');

      return GestureDetector(
        onTap: () {
          // Access the position of the specific flag widget
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final Offset flagPosition = renderBox.localToGlobal(Offset.zero);

          // Calculate the y-position offset based on the index and height of each flag
          final double adjustedY = flagPosition.dy + (index * 60); // Adjust the y-offset

          // Use the adjusted y-position
          widget.onFlagClicked(imageURL, Offset(flagPosition.dx, adjustedY));
          Provider.of<LanguageProvider>(context, listen: false).updateIntendedLanguage(languageId);
          _fetchAvailableLanguages();
          _fetchIntendedLanguageImage();
          print('Clicked on language: $languageName');
          widget.onArrowToggle();
        },
        child: Row(
          children: [
            Animate(
              effects: [
                if (widget.isArrowDown)
                  const SlideEffect(
                    begin: Offset(0, 0),
                    end: Offset(-1.5, 0),
                    duration: Duration(milliseconds: 300),
                  )
                else
                  const SlideEffect(
                    begin: Offset(-1.5, 0),
                    end: Offset(0, 0),
                    duration: Duration(milliseconds: 300),
                  ),
              ],
              delay: Duration(milliseconds: index * 200),
              child: Image.asset(
                imageURL,
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(width: 15),
            Animate(
              effects: [
                if (widget.isArrowDown)
                  const FadeEffect(begin: 1, end: 0)
                else
                  FadeEffect(begin: 0, end: 1),
              ],
              delay: Duration(milliseconds: 600),
              child: Text(
                languageName,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );
}
}
