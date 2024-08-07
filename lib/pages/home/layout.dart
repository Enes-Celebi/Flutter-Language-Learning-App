import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lingoneer_beta_0_0_1/components/appbar_component.dart';
import 'package:lingoneer_beta_0_0_1/pages/home/data_fetch.dart';
import 'package:lingoneer_beta_0_0_1/pages/home/subject_card.dart';
import 'package:lingoneer_beta_0_0_1/pages/home/topbar.dart';
import 'package:lingoneer_beta_0_0_1/pages/level/level_page.dart';
import 'package:lingoneer_beta_0_0_1/services/language_provider.dart';
import 'package:lingoneer_beta_0_0_1/themes/subject_colors.dart';
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
      duration: const Duration(milliseconds: 600),
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

    if (_isArrowDown) {
      _startFlagAnimations();
      _textAnimationController.forward();
    } else {
      _reverseFlagAnimations();
      _textAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _animationController.dispose();
    for (var controller in _flagAnimationControllers) {// try disposing reverse animation too
      controller.dispose();
    }
    _textAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _toggleArrow() {
    print('Toggling arrow. Is arrow down: $_isArrowDown');
    setState(() {
      _isArrowDown = !_isArrowDown;
      if (_isArrowDown) {
         _animationController.reverse().whenComplete(() {
           setState(() {
             _isInteractionDisabled = false;
           });
         });
         _textAnimationController.reverse();
         _reverseFlagAnimations();
      } else {
        _animationController.forward().whenComplete(() {
          setState(() {
            _isInteractionDisabled = true;
          });
        });
        _textAnimationController.forward();
        _startFlagAnimations();
      }
    });

    if (_isArrowDown) {
      print("BUTTON PRESSED BACK");
      _reverseFlagAnimations();
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

  Future<void> _reverseFlagAnimations() async {
    print('Reversing flag animations...');
    for (var controller in _flagAnimationControllers) {
      print('Reversing controller with duration: ${controller.duration}');
      controller.duration = const Duration(milliseconds: 300);
      controller.reverse();
    }
  }

  void _handleTapOutside() {
    if (!_isArrowDown) {
      _toggleArrow();
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
    } catch (e) {
      print('Error fetching available languages: $e');
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

  @override
  Widget build(BuildContext context) {
    final selectedLanguageCombination = Provider.of<LanguageProvider>(context).languageComb;

    return Scaffold(
      appBar: TopBar(
        intendedLanguageImage: _intendedLanguageImage,
        isArrowDown: _isArrowDown,
        onArrowToggle: _toggleArrow,
        availableLanguages: _availableLanguages,
        flagAnimationControllers: _flagAnimationControllers,
        flagSizeAnimations: _flagSizeAnimations,
        textAppearanceAnimation: _textAppearanceAnimation,
      ),
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
                    SubjectCard(
                      subjectsSnapshot: subjectsSnapshot,
                      doneMapcardsIds: doneMapcardsIds,
                      pageController: _pageController,
                      animationController: _animationController,
                      slideAnimation: _slideAnimation,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      isInteractionDisabled: _isInteractionDisabled,
                      currentPage: _currentPage,
                      goToSubjectLevel: _goToSubjectLevel,
                      toggleArrow: _toggleArrow,
                      getSubjectColor: getSubjectColor,
                    ),
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
        final userDataMap = userDoc.data();

        if (!userDataMap.containsKey('username') ||
            userDataMap['username'] == null ||
            userDataMap['username'].isEmpty) {
          await showDialog(
            // ignore: use_build_context_synchronously
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
                        // ignore: use_build_context_synchronously
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
