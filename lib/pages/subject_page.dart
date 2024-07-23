import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingoneer_beta_0_0_1/components/appbar_component.dart';
import 'package:lingoneer_beta_0_0_1/components/subject_card_component.dart';
import 'package:lingoneer_beta_0_0_1/pages/level_page.dart';
import 'package:lingoneer_beta_0_0_1/pages/settings_page.dart'; // Import the SettingsPage class
import 'package:lingoneer_beta_0_0_1/services/language_provider.dart';
import 'package:lingoneer_beta_0_0_1/themes/subject_colors.dart'; // Import the SubjectColors class
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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late FirebaseAuth _auth;
  late User? _user;

  @override
  void initState() {
    super.initState();
    print('Home Page initState called');
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    _checkUsername(_user!);

    // Add observer for lifecycle events
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    // Remove observer for lifecycle events
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  Color getSubjectColor(String subjectId) {
    // Define a map of prefix to color
    final Map<String, Color> colorMap = {
      'mat': SubjectColors.mat,
      'dif': SubjectColors.dif,
      'phy': SubjectColors.phy,
      // Add more mappings as needed
    };

    // Extract the first 3 characters of the subjectId
    final String prefix = subjectId.substring(0, 3).toLowerCase();

    // Return the corresponding color or a default color if not found
    return colorMap[prefix] ?? Colors.grey;
  }

  void _goToSubjectLevel(String subjectId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => subjectLevelPage(
          selectedCardIndex: subjectId,
          subjectCardColor: getSubjectColor(subjectId), // Pass the subject color
        ),
      ),
    );
    setState(() {}); // Refresh the FutureBuilder when returning from the subject level page
  }

  @override
  Widget build(BuildContext context) {
    final selectedLanguageCombination = Provider.of<LanguageProvider>(context).languageComb;
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog when back button is pressed
        bool confirmExit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit App?'),
              content: Text('Are you sure you want to exit the app?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    exit(0); // Confirm exit
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cancel exit
                  },
                  child: Text('No'),
                ),
              ],
            );
          },
        );
        return confirmExit ?? false; // Return the user's choice
      },
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: FutureBuilder<List<QuerySnapshot>>(
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
                .collection('progress')
                .where('userId', isEqualTo: _user!.uid)
                .get(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final subjectsSnapshot = snapshot.data![0].docs;
            QuerySnapshot userData = snapshot.data![1];
            final progressSnapshot = snapshot.data![2];

            final DocumentSnapshot userDoc = userData.docs.first;
            final userDataMap = userDoc.data() as Map<String, dynamic>;
            if (!userDataMap.containsKey('language')) {
              return const Text('Language not found');
            }

            final doneMapcardsIds = progressSnapshot.docs
                .map((doc) => doc['lessonId'].toString().substring(0, doc['lessonId'].toString().length - 7))
                .toList();

            return PageView(
              children: subjectsSnapshot.map((subjectsSnapshot) {
                final title = subjectsSnapshot.get('name');
                final imageURL = subjectsSnapshot.get('image');
                final subjectId = subjectsSnapshot.get('id');

                final countOfSpecificSubject =
                    doneMapcardsIds.where((subject) => subject == subjectId).length;

                final cardColor = getSubjectColor(subjectId);
                final progressValue = countOfSpecificSubject / 32;

                return MyMainCard(
                  title: title ?? 'No Title', // Set default title if "name" is missing
                  imagePath: imageURL ?? 'lib/assets/images/test/pic1.png',
                  progressValue: progressValue,
                  cardColor: cardColor,
                  progressColor: cardColor.withOpacity(0.7),
                  onTap: () => _goToSubjectLevel(subjectId),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  void _checkUsername(User user) async {
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: user.email)
          .get();

      if (userData.docs.isNotEmpty) {
        // User document found, check if username is set
        final userDoc = userData.docs.first;
        final userDataMap = userDoc.data() as Map<String, dynamic>;

        if (!userDataMap.containsKey('username') ||
            userDataMap['username'] == null ||
            userDataMap['username'].isEmpty) {
          // Username not found or empty, prompt to set username
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
                        // Save the new username to Firestore
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(user.uid)
                            .set({'username': newUsername}, SetOptions(merge: true));
                        Navigator.pop(context);
                      } else {
                        // Show an error message if the username is empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(                            content: Text('Please enter a valid username.'),
                          ),
                        );
                      }
                    },
                    child: const Text('Save'),
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

                           
