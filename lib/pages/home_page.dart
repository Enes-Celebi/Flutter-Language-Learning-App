import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingoneer_beta_0_0_1/components/appbar.dart';
import 'package:lingoneer_beta_0_0_1/components/my_main_card.dart';
import 'package:lingoneer_beta_0_0_1/pages/subject_level_page.dart';
import 'package:lingoneer_beta_0_0_1/services/language_provider.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  final String? selectedLanguageComb;

  const HomePage({
    super.key,
    required this.selectedLanguageComb
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _goToSubjectLevel(String subjectId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => subjectLevelPage(
          selectedCardIndex: subjectId
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LanguageProvider>(context);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    _checkUsername(user!);
  
    return Scaffold(
      appBar: const CustomAppBar(),
      body: FutureBuilder<List<QuerySnapshot>>(
        future: Future.wait([
          FirebaseFirestore.instance
            .collection('subjects')
            .where('language', isEqualTo: widget.selectedLanguageComb)
            .get(),
          FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: user.email) 
            .get(),
          FirebaseFirestore.instance
            .collection('progress')
            .where('userId', isEqualTo: user?.uid)
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
          QuerySnapshot userData = snapshot.data![1]!;
          final progressSnapshot = snapshot.data![2];

          final DocumentSnapshot userDoc = userData.docs.first;
          final userDataMap = userDoc.data() as Map<String, dynamic>;
          if (!userDataMap.containsKey('language')) {
            return const Text('Language not found');
          }

          final doneMapcardsIds = progressSnapshot.docs
            .map((doc) => doc['lessonId'].toString()
            .substring(0, doc['lessonId'].toString().length -7))
            .toList();

          return PageView(
            children: subjectsSnapshot.map((subjectsSnapshot) {
              final title = subjectsSnapshot.get('name');
              final imageURL = subjectsSnapshot.get('image');
              final subjectId = subjectsSnapshot.get('id');

              final countOfSpecificSubject = doneMapcardsIds
                .where((subject) => subject == subjectId).length;

              return MyMainCard(
                title: title ??
                    'No Title', // Set default title if "name" is missing
                imagePath: imageURL ?? 'lib/assets/images/test/pic1.png',
                progressValue: countOfSpecificSubject/32,
                cardColor: Colors.blue,
                progressColor: Colors.blue.shade700,
                onTap: () => _goToSubjectLevel(subjectId),
              );
            }).toList(),
          );
        },
      ),
    );
  }



  void _checkUsername(User? user) async {
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
            },
          );
        }
      }
    }
  }
}
