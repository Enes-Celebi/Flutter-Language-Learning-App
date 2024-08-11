import 'package:flutter/material.dart';
import 'package:lingoneer_beta_0_0_1/components/appbar_component.dart';
import 'package:lingoneer_beta_0_0_1/pages/home/subject_card.dart';
import 'package:lingoneer_beta_0_0_1/pages/home/topbar.dart';
import 'package:lingoneer_beta_0_0_1/pages/level/level_page.dart';
import 'package:lingoneer_beta_0_0_1/themes/subject_colors.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingoneer_beta_0_0_1/services/language_provider.dart';

class HomePage extends StatefulWidget {
  final String? selectedLanguageComb;

  const HomePage({
    super.key,
    required this.selectedLanguageComb,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FirebaseAuth _auth;
  late User? _user;
  bool _isArrowDown = true;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    final selectedLanguageCombination = Provider.of<LanguageProvider>(context).languageComb;

    return Scaffold(
      appBar: TopBar(
        isArrowDown: _isArrowDown,
        onArrowToggle: () {
          setState(() {
            _isArrowDown = !_isArrowDown;
          });
        },
        onLanguageSelected: (languageId) {
          // Handle language selection
          print('Selected language ID: $languageId');
        },
      ),
      body: FutureBuilder<List<QuerySnapshot>>(
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

          return SubjectCard(
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
          );
        },
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
}
