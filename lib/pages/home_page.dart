import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingoneer_beta_0_0_1/components/appbar.dart';
import 'package:lingoneer_beta_0_0_1/components/my_main_card.dart';
import 'package:lingoneer_beta_0_0_1/pages/subject_level_page.dart';
import 'package:lingoneer_beta_0_0_1/services/language_provider.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCardIndex = -1;

  void _goToSubjectLevel(String subjectId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => subjectLevelPage(selectedCardIndex: subjectId),
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


  @override
  Widget build(BuildContext context) {
    Provider.of<LanguageProvider>(context);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    _checkUsername(user!);

  
    return Scaffold(
      appBar: const CustomAppBar(),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: user.email) 
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          QuerySnapshot userData = snapshot.data!;
          if (userData.docs.isEmpty) {
            return const Text('User document not found');
          }

          final DocumentSnapshot userDoc = userData.docs.first;
          final userDataMap = userDoc.data() as Map<String, dynamic>;
          if (!userDataMap.containsKey('language')) {
            return const Text('Language not found');
          }

          final String language = userDataMap['language'];

          
        return FutureBuilder<QuerySnapshot>(       
        future: FirebaseFirestore.instance
        .collection('subjects')
        .where('language', isEqualTo: language)
        .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          

          final categories = snapshot.data!.docs;

          return PageView(
            children: categories.map((category) {
              final title = category.get('name');
              final imageURL = category.get('image');
              final subjectId = category.get('id'); // Document ID

              return MyMainCard(
                title: title ??
                    'No Title', // Set default title if "name" is missing
                imagePath: imageURL ?? 'lib/assets/images/test/pic1.png',
                progressValue: 0.5,
                cardColor: Colors.blue,
                progressColor: Colors.blue.shade700,
                onTap: () => _goToSubjectLevel(subjectId),
              );
            }).toList(),
          );
            },
          );
        },
      ),
    );
  }
}