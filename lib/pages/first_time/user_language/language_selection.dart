import "dart:async";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/primary_searchbar_component.dart";
import "package:lingoneer_beta_0_0_1/pages/first_time/intended_language/intended_language_selection.dart";
import "package:lingoneer_beta_0_0_1/services/language_provider.dart";
import "package:provider/provider.dart";

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({super.key});

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _currentLanguageNameNotifier = ValueNotifier<String>('');
  List<DocumentSnapshot> _languages = [];
  List<DocumentSnapshot> _filteredLanguages = [];
  List<String> _texts = [];
  int _currentTextIndex = 0;
  Timer? _textSwitchTimer;
  bool _isTextVisible = true;
  final double padding = 260;
  final double itemWidth = 100;
  int _currentIntersectingIndex = -1; // Define _currentIntersectingIndex

  late AnimationController _animationController;
  late Animation<double> _animation;

  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateCurrentLanguage);

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(_animationController);

    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _buttonAnimation = TweenSequence([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: -5.0).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 1.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -5.0, end: 5.0).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 1.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 5.0, end: -5.0).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 1.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -5.0, end: 5.0).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 1.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 5.0, end: 0.0).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 1.0,
      )
    ]).animate(_buttonAnimationController);

    _fetchAllTexts();
  }

  void _startButtonAnimation() {
    _buttonAnimationController.reset();
    _buttonAnimationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    _buttonAnimationController.dispose();
    _textSwitchTimer?.cancel();
    _currentLanguageNameNotifier.dispose();
    super.dispose();
  }

  Future<void> _fetchAllTexts() async {
    final snapshot = await FirebaseFirestore.instance.collection('languages').get();
    setState(() {
      _texts = snapshot.docs.map((doc) => doc['text'] as String).toList();
    });
    _startTextSwitchTimer();
  }

  void _startTextSwitchTimer() {
    _textSwitchTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _isTextVisible = false;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _currentTextIndex = (_currentTextIndex + 1) % _texts.length;
          _isTextVisible = true;
        });
      });
    });
  }

  void _updateCurrentLanguage() {
    if (_filteredLanguages.isEmpty) return;

    final totalItemWidth = itemWidth + padding;
    final centerPosition = MediaQuery.of(context).size.width / 2;
    final scrollOffset = _scrollController.offset;

    int newIntersectingIndex = -1;

    for (int index = 0; index < _filteredLanguages.length; index++) {
      final itemStartPosition = (index * totalItemWidth) - scrollOffset + padding / 2;
      final itemEndPosition = itemStartPosition + itemWidth;

      if (itemStartPosition < centerPosition && itemEndPosition > centerPosition) {
        newIntersectingIndex = index;
        final languageData = _filteredLanguages[index];
        final languageName = languageData.get('name') ?? '';
        if (_currentLanguageNameNotifier.value != languageName) {
          _currentLanguageNameNotifier.value = languageName;
          _startButtonAnimation();
        }
        break;
      }
    }

    // Update _currentIntersectingIndex only if it has changed
    if (_currentIntersectingIndex != newIntersectingIndex) {
      setState(() {
        _currentIntersectingIndex = newIntersectingIndex;
      });
    }
  }

  void _proceedToApp(Map<String, dynamic> languageData) {
    final language = languageData['language'];

    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    languageProvider.setSelectedLanguage(language);

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => IntendedLanguageSelection(onTap: () {})
      ),
    );
  }

  void _filterLanguages(String query) {
    setState(() {
      _filteredLanguages = _languages.where((language) {
        final hook = (language.get('hook') ?? '') as String;
        final keywords = hook.split(',').map((s) => s.trim().toLowerCase()).toList();
        return keywords.any((keyword) => keyword.contains(query.toLowerCase()));
      }).toList();

      // Ensure the current language is updated after filtering
      _updateCurrentLanguage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('languages').get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          _languages = snapshot.data!.docs;

          // Ensure to update the filtered languages list after fetching all languages
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _filterLanguages(_searchController.text); // Filter based on current search text
          });

          return Stack(
            children: [
              _buildLogo(),
              _buildTitle(),
              _buildSearchBar(),
              _buildCurrentLanguageName(),
              _buildLanguageListView(),
              _buildProceedButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: Image.asset('lib/assets/images/icons/appnamelogo.png'),
      ),
    );
  }

  Widget _buildTitle() {
    return Positioned(
      top: 200,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: AnimatedOpacity(
          opacity: _isTextVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Text(
            _texts.isNotEmpty ? _texts[_currentTextIndex] : 'Loading...',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 280,
      left: 20,
      right: 20,
      child: MySearchBar(
        controller: _searchController,
        hintText: 'Search...',
        obscureText: false,
        onSearchPressed: () {
          _filterLanguages(_searchController.text);
        },
        onArrowPressed: () {
          // Implement action on arrow pressed
        },
      ),
    );
  }

  Widget _buildCurrentLanguageName() {
    return Positioned(
      top: 380,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: ValueListenableBuilder<String>(
            valueListenable: _currentLanguageNameNotifier,
            builder: (context, languageName, child) {
              return Text(
                languageName.isNotEmpty ? languageName : 'Select a language',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageListView() {
    final totalItemWidth = itemWidth + padding;
    final centerPosition = MediaQuery.of(context).size.width / 2;

    return Positioned(
      top: 300,
      left: 0,
      right: 0,
      bottom: 0,
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                itemCount: _filteredLanguages.length,
                itemBuilder: (context, index) {
                  final itemStartPosition = (index * totalItemWidth) - _scrollController.offset + padding / 2;
                  final itemEndPosition = itemStartPosition + itemWidth;
                  final isIntersecting = (itemStartPosition < centerPosition && itemEndPosition > centerPosition);
                  final flagColor = isIntersecting ? Colors.transparent : Colors.transparent;
                  final languageData = _filteredLanguages[index];
                  final imageURL = languageData.get('image') ?? 'lib/assets/images/test/pic1.png';
                  final scaleFactor = (index == _currentIntersectingIndex) ? 1.4 : 1.0;

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding / 2),
                    child: Center(
                      child: AnimatedScale(
                        scale: scaleFactor,
                        duration: const Duration(milliseconds: 150),
                        child: Container(
                          width: itemWidth,
                          height: itemWidth,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: flagColor,
                              width: 2,
                            ),
                          ),
                          child: Image.asset(
                            imageURL,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 1,
            top: 0,
            bottom: 0,
            child: Container(
              width: 2,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProceedButton() {
    return Positioned(
      top: 660,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_animationController, _buttonAnimationController]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _buttonAnimation.value),
              child: Transform.scale(
                scale: _animation.value,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentIntersectingIndex != -1) {
                      final selectedLanguage = _filteredLanguages[_currentIntersectingIndex].data() as Map<String, dynamic>;
                      _proceedToApp(selectedLanguage);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color.fromARGB(255, 33, 205, 243),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.arrow_forward, size: 20),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
