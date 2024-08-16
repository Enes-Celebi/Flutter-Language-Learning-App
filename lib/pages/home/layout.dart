import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingoneer_beta_0_0_1/components/appbar_component.dart';
import 'package:lingoneer_beta_0_0_1/themes/subject_colors.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:lingoneer_beta_0_0_1/services/language_provider.dart';
import 'package:lingoneer_beta_0_0_1/pages/home/data_fetch.dart';
import 'package:lingoneer_beta_0_0_1/pages/home/subject_card.dart';
import 'package:lingoneer_beta_0_0_1/pages/home/subject_manager_card_component.dart';
import 'package:lingoneer_beta_0_0_1/pages/home/topbar.dart';
import 'package:lingoneer_beta_0_0_1/pages/level/level_page.dart';
import 'package:lingoneer_beta_0_0_1/pages/home/language_change_loading.dart'; // Import the new class

class HomePage extends StatefulWidget {
  final String? selectedLanguageComb;

  const HomePage({
    super.key,
    required this.selectedLanguageComb,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late FirebaseAuth _auth;
  late User? _user;
  bool _isArrowDown = true;
  int _currentPage = 0;
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _showLanguageChangeLoading = false; // State variable to manage loading screen visibility
  String? _intendedLanguageImage; // Variable to store the image path
  Offset _flagPosition = Offset.zero; // State variable to store the flag position
  bool _isManagerCardExpanded = false; // Track the expanded state of the card

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.4, 0.0), // Slide to the right
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fetchIntendedLanguageImage(); // Fetch the intended language image
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
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

  Future<void> _fetchIntendedLanguageImage() async {
    final intendedLanguageId = Provider.of<LanguageProvider>(context, listen: false).intendedSelectedLanguage;
    final image = await DataFetch.fetchIntendedLanguageImage(intendedLanguageId);
    setState(() {
      _intendedLanguageImage = image;
    });
  }

  void _toggleManagerCard() {
    setState(() {
      _isManagerCardExpanded = !_isManagerCardExpanded;
      if (_isManagerCardExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _onFlagClicked(String imageURL, Offset flagPosition) {
    setState(() {
      _flagPosition = flagPosition;
      _intendedLanguageImage = imageURL;
      _showLanguageChangeLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedLanguageCombination = Provider.of<LanguageProvider>(context).languageComb;

    return Scaffold(
      body: Stack(
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

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: SubjectManagerCardComponent(
                      slideAnimation: _slideAnimation, // Pass the animation
                    ),
                  ), // SizedBox with 250 px height
                  Expanded(
                    child: SubjectCard(
                      subjectsSnapshot: subjectsSnapshot,
                      doneMapcardsIds: doneMapcardsIds,
                      pageController: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      currentPage: _currentPage,
                      goToSubjectLevel: (subjectId) async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (content) => subjectLevelPage(
                              selectedCardIndex: subjectId,
                              subjectCardColor: getSubjectColor(subjectId),
                            ),
                          ),
                        );
                      },
                      toggleArrow: () {
                        setState(() {
                          _isArrowDown = !_isArrowDown;
                        });
                      },
                      getSubjectColor: getSubjectColor,
                      isArrowDown: _isArrowDown,
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopBar(
              imagePath: _intendedLanguageImage ?? '', // Pass the imagePath
              isArrowDown: _isArrowDown,
              onArrowToggle: () {
                _toggleManagerCard(); // Toggle the card animation
                setState(() {
                  _isArrowDown = !_isArrowDown;
                });
              },
              onLanguageSelected: (languageId) {
                // Handle language selection
                print('Selected language ID: $languageId');
              },
              onFlagClicked: (imageURL, flagPosition) {
                _onFlagClicked(imageURL, flagPosition); // Pass flagPosition here
              },
            ),
          ),
          if (_showLanguageChangeLoading)
            Positioned.fill(
              child: LanguageChangeLoading(
                imagePath: _intendedLanguageImage ?? '', // Pass the imagePath
                onComplete: () {
                  // Hide the loading animation after it completes
                  setState(() {
                    _showLanguageChangeLoading = false;
                  });
                },
              ),
            ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBar(
              isBottomBar: true,
              height: 80,
            ),
          ),
        ],
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
}
