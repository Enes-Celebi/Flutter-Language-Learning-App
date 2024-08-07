import "dart:ui";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/appbar_component.dart";
import "package:lingoneer_beta_0_0_1/pages/home/subject_card_component.dart";
import "package:lingoneer_beta_0_0_1/pages/level/level_page.dart";
import "package:lingoneer_beta_0_0_1/services/language_provider.dart";
import "package:lingoneer_beta_0_0_1/themes/subject_colors.dart";
import "package:lottie/lottie.dart";
import "package:provider/provider.dart";

class HomePage extends StatefulWidget {
  final String? selectedLanguageComb;

  const HomePage({
    super.key,
    required this.selectedLanguageComb,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  late FirebaseAuth _auth;
  late User? _user;
  String? _intendedLanguageImage;
  bool _isArrowDown = true;  

  // initializatoin
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    _checkUsername(_user!);

    WidgetsBinding.instance?.addObserver(this);

    // Fetch the intended language image URL
    _fetchIntendedLanguageImage();
  }

  // username checking function
  void _checkUsername(User user) async {
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: user.email)
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
                  onChanged: (value) => newUsername = value,
                  decoration: const InputDecoration(hintText: 'Enter Username'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (newUsername.isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(user.uid)
                            .set({'username': newUsername}, SetOptions(merge: true));
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid username.'),
                          ),
                        );
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            }
          );
        }
      }
    }
  }

  // function to go to the level page when a subject is pressed
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

  // function to toggle arrow button
  void _toggleArrow() {
    setState(() {
      _isArrowDown = !_isArrowDown;
    });
  }

  // dispose
  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  // handling of subject colors
  Color getSubjectColor(String subjectId) {
    final Map<String, Color> colorMap = {
      'mat': SubjectColors.mat,
      'dif': SubjectColors.dif,
      'phy': SubjectColors.phy
    };
    final String prefix = subjectId.substring(0, 3).toLowerCase();
    return colorMap[prefix] ?? Colors.grey;
  }

  // function to get the intended language image
  Future<void> _fetchIntendedLanguageImage() async {
    final intendedLanguageId = Provider.of<LanguageProvider>(context, listen: false).intendedSelectedLanguage;
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
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

  @override
  Widget build(BuildContext context) {
    final selectedLanguageCombination = Provider.of<LanguageProvider>(context).languageComb;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final String? intendedLanguageId = languageProvider.intendedSelectedLanguage;

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 110,),
              Expanded(
                child: Stack(
                  children: [
                    FutureBuilder<List<QuerySnapshot>>(
                      future: Future.wait([
                        FirebaseFirestore.instance
                            .collection('subjects')
                            .where('language', isEqualTo: selectedLanguageCombination)
                            .get(),
                        FirebaseFirestore.instance
                            .collection('Users')
                            .where('email', isEqualTo: _user!.email)
                            .get(),
                        FirebaseFirestore.instance
                            .collection('intended_languages')
                            .where('language', isEqualTo: intendedLanguageId)
                            .get(),
                      ]), 
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final subjectsSnapshot = snapshot.data![0].docs;
                        final userData = snapshot.data![1];
                        final progressSnapshot = snapshot.data![2];

                        final DocumentSnapshot userDoc = userData.docs.first;
                        final userDataMap = userDoc.data() as Map<String, dynamic>;
                        if (!userDataMap.containsKey('language')) {
                          return const Center(child: Text('Language not found'));
                        }

                        final doneMapcardIds = progressSnapshot.docs
                            .map((doc) => doc['lessonId'].toString().substring(0, ['lessonId'].toString().length - 7))
                            .toList();

                        return PageView(
                          children: subjectsSnapshot.map((subject) {
                            final title = subject.get('name');
                            final imageURL = subject.get('image');
                            final subjectId = subject.get('id');

                            final countOfSpecificSubject = 
                                doneMapcardIds.where((subject) => subject == subjectId).length;

                            final cardColor = getSubjectColor(subjectId);
                            final progressValue = countOfSpecificSubject / 32;

                            return MyMainCard(
                              title: title ?? 'No Title', 
                              imagePath: imageURL ?? 'lib/assets/images/test/pic1.png', 
                              progressValue: progressValue, 
                              cardColor: cardColor, 
                              progressColor: cardColor.withOpacity(0.7), 
                              onTap: () => _goToSubjectLevel(subjectId)
                            );
                          }).toList(),
                        );
                      }
                    )
                  ],
                ),
              )
            ],
          ),
          _applyBlur(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(),
    );
  }

  AppBar() {
    CustomBar(
      height: 110,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //if (_intendedLanguageImage != null)
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
            child: Image.asset(
              _intendedLanguageImage!,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          GestureDetector(
            onTap: _toggleArrow,
            child: Icon(
              _isArrowDown ? Icons.arrow_drop_down : Icons.arrow_drop_up,
              size: 40,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
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
          )
        ],
      ),
    );
  }

  BottomAppBar() {
    const CustomBar(
      isBottomBar: true,
      height: 80,
    );
  }

  Widget _applyBlur() {
    if (!_isArrowDown) {
      return Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      );
    }
    return SizedBox.shrink();
  } 
}