import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lingoneer_beta_0_0_1/components/appbar_component.dart';
import 'package:lingoneer_beta_0_0_1/components/subject_card_component.dart';
import 'package:lingoneer_beta_0_0_1/pages/level_page.dart';
import 'package:lingoneer_beta_0_0_1/services/language_provider.dart';
import 'package:lingoneer_beta_0_0_1/themes/subject_colors.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String? selectedLanguageComb;

  const HomePage({
    super.key,
    required this.selectedLanguageComb,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, WidgetsBindingObserver {
  late FirebaseAuth _auth;
  late User? _user;
  String? _intendedLanguageImage;
  bool _isArrowDown = true;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isInteractionDisabled = false;
  int _currentPage = 0;
  final PageController _pageController = PageController();
  List<DocumentSnapshot> _availableLanguages = [];
  late List<AnimationController> _flagAnimationControllers;
  late List<Animation<double>> _flagSizeAnimations;
  late AnimationController _textAnimationController;
  late Animation<double> _textAppearanceAnimation;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    _checkUsername();
    WidgetsBinding.instance?.addObserver(this);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.4, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _textAppearanceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeIn,
    ));

    _fetchIntendedLanguageImage();
    _fetchAvailableLanguages();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _animationController.dispose();
    for (var controller in _flagAnimationControllers) {
      controller.dispose();
    }
    _textAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _toggleArrow() {
    setState(() {
      _isArrowDown = !_isArrowDown;
      if (_isArrowDown) {
        _animationController.reverse();
        _isInteractionDisabled = false;
        _textAnimationController.reverse();
        for (var controller in _flagAnimationControllers) {
          controller.stop();
          controller.reset();
        }
      } else {
        _animationController.forward();
        _isInteractionDisabled = true;
        _textAnimationController.forward();
        _startFlagAnimations();
      }
    });
  }

  void _handleTapOutside() {
    if (!_isArrowDown) {
      _toggleArrow();
    }
  }

  Future<void> _fetchIntendedLanguageImage() async {
    final intendedLanguageId = Provider.of<LanguageProvider>(context, listen: false).intendedSelectedLanguage;
    if (intendedLanguageId == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('intended_languages')
          .where('language', isEqualTo: intendedLanguageId)
          .get();
      final intendedLanguageData = snapshot.docs;
      if (intendedLanguageData.isNotEmpty) {
        setState(() {
          _intendedLanguageImage = (intendedLanguageData.first.data() as Map<String, dynamic>)['image'] ?? 'No image';
        });
      }
    } catch (e) {
      print('Error fetching intended language image: $e');
    }
  }

  Future<void> _fetchAvailableLanguages() async {
    final selectedLanguageId = Provider.of<LanguageProvider>(context, listen: false).selectedLanguage;
    final intendedLanguageId = Provider.of<LanguageProvider>(context, listen: false).intendedSelectedLanguage;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('intended_languages')
          .get();

      final hasDocument = snapshot.docs.any((doc) => doc.get('language') == selectedLanguageId);

      if (hasDocument) {
        final userLanguageDoc = snapshot.docs.firstWhere(
          (doc) => doc.get('language') == selectedLanguageId,
        );
        final availability = List<String>.from(userLanguageDoc.get('availability'));

        final filteredLanguages = snapshot.docs
            .where((doc) =>
                availability.contains(doc.get('language')) &&
                doc.get('language') != intendedLanguageId)
            .toList();

        setState(() {
          _availableLanguages = filteredLanguages;

          _flagAnimationControllers = List.generate(
            _availableLanguages.length,
            (index) => AnimationController(
              duration: const Duration(milliseconds: 300),
              vsync: this,
            ),
          );

          _flagSizeAnimations = List.generate(
            _availableLanguages.length,
            (index) => Tween<double>(begin: 0.01, end: 1.0).animate(CurvedAnimation(
              parent: _flagAnimationControllers[index],
              curve: Curves.easeOut,
            )),
          );
        });
      }
    } catch (e) {
      print('Error fetching available languages: $e');
    }
  }

  Future<void> _startFlagAnimations() async {
    for (var i = 0; i < _flagAnimationControllers.length; i++) {
      _flagAnimationControllers[i].forward();
      if (i < _flagAnimationControllers.length - 1) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  Future<List<QuerySnapshot>> _fetchData(String selectedLanguageCombination) async {
    final subjectsFuture = FirebaseFirestore.instance
        .collection('subjects')
        .where('language', isEqualTo: selectedLanguageCombination)
        .get();
    final progressFuture = FirebaseFirestore.instance
        .collection('progress')
        .where('userId', isEqualTo: _user!.uid)
        .get();
    return Future.wait([subjectsFuture, progressFuture]);
  }

  Widget _buildCardList(List<QueryDocumentSnapshot> subjectsSnapshot, List<String> doneMapcardsIds) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      physics: _isInteractionDisabled ? const NeverScrollableScrollPhysics() : const PageScrollPhysics(),
      itemCount: subjectsSnapshot.length,
      itemBuilder: (context, index) {
        final subject = subjectsSnapshot[index];
        final title = subject.get('name') as String?;
        final imageURL = subject.get('image') as String?;
        final subjectId = subject.get('id') as String;

        final countOfSpecificSubject = doneMapcardsIds.where((id) => id == subjectId).length;
        final cardColor = getSubjectColor(subjectId);
        final progressValue = countOfSpecificSubject / 32;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final slideOffset = _isInteractionDisabled && _currentPage == index ? _slideAnimation.value : Offset.zero;
            return Transform.translate(
              offset: slideOffset * MediaQuery.of(context).size.width,
              child: GestureDetector(
                onTap: () {
                  if (_isInteractionDisabled) {
                    _toggleArrow();
                  } else {
                    _goToSubjectLevel(subjectId);
                  }
                },
                child: child,
              ),
            );
          },
          child: MyMainCard(
            title: title ?? 'No Title',
            imagePath: imageURL ?? 'lib/assets/images/test/pic1.png',
            progressValue: progressValue,
            cardColor: cardColor,
            progressColor: cardColor.withOpacity(0.7),
            onTap: _isInteractionDisabled ? () {
              _toggleArrow();
            } : () {
              _goToSubjectLevel(subjectId);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedLanguageCombination = Provider.of<LanguageProvider>(context).languageComb;

    return Scaffold(
      appBar: _buildAppBar(),
      body: GestureDetector(
        onTap: _handleTapOutside,
        child: Stack(
          children: [
            FutureBuilder<List<QuerySnapshot>>(
              future: _fetchData(selectedLanguageCombination!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final subjectsSnapshot = snapshot.data![0].docs;
                final progressSnapshot = snapshot.data![1].docs;
                final doneMapcardsIds = progressSnapshot
                    .map((doc) => doc['lessonId'].toString().substring(0, doc['lessonId'].toString().length - 7))
                    .toList();

                return Stack(
                  children: [
                    _buildCardList(subjectsSnapshot, doneMapcardsIds),
                    if (!_isArrowDown) _buildLanguageListView(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBar(
        isBottomBar: true,
        height: 80,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(135.0),
      child: CustomBar(
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
              onTap: _toggleArrow,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 50.0),
                child: Icon(
                  _isArrowDown ? Icons.arrow_drop_down : Icons.arrow_drop_up,
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
    );
  }

  Widget _buildLanguageListView() {
    return Positioned(
      top: 20.0,
      left: 20.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _availableLanguages.asMap().entries.map((entry) {
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
                _fetchAvailableLanguages();
                _fetchIntendedLanguageImage();
                _toggleArrow();
              },
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: _flagAnimationControllers[index],
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _flagSizeAnimations[index].value,
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
                    opacity: _textAppearanceAnimation,
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
      ),
    );
  }

  Color getSubjectColor(String subjectId) {
    final Map<String, Color> colorMap = {
      'mat': SubjectColors.mat,
      'dif': SubjectColors.dif,
      'phy': SubjectColors.phy
    };
    final String prefix = subjectId.substring(0, 3).toLowerCase();
    return colorMap[prefix] ?? Colors.grey;
  }

  void _goToSubjectLevel(String subjectId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (content) => subjectLevelPage(
          selectedCardIndex: subjectId,
          subjectCardColor: getSubjectColor(subjectId),
        ),
      ),
    );
  }

  void _checkUsername() async {
    if (_user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: _user!.email)
          .get();

      if (userData.docs.isNotEmpty) {
        final userDoc = userData.docs.first;
        final userDataMap = userDoc.data() as Map<String, dynamic>;

        if (!userDataMap.containsKey('username') ||
            userDataMap['username'] == null ||
            userDataMap['username'].isEmpty) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              String newUsername = '';
              return AlertDialog(
                title: const Text('Set Username'),
                content: TextField(
                  onChanged: (value) {
                    newUsername = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      if (newUsername.isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(userDoc.id)
                            .update({'username': newUsername});
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Set'),
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }
}