import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingoneer_beta_0_0_1/components/my_main_card.dart';
import 'package:lingoneer_beta_0_0_1/pages/settingPage.dart';
import 'package:lingoneer_beta_0_0_1/pages/subject_level_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCardIndex = -1;

  void _goToSubjectLevel(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => subjectLevelPage(selectedCardIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Stack(
          children: [
            Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).colorScheme.tertiary, // COLOR
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 40,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.background, //COLOR
                    border: Border.all(
                      color: Theme.of(context).colorScheme.background, //COLOR
                      width: 8,
                    ),
                  ),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary, // COLOR
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('Category').get(),
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
              final imageURL = category.get('imageUrl');

              return MyMainCard(
                title: title ??
                    'No Title', // Set default title if "name" is missing
                imagePath: imageURL ?? 'lib/assets/images/test/pic1.png',
                progressValue: 0.5,
                cardColor: Colors.blue,
                progressColor: Colors.blue.shade700,
                onTap: () => _goToSubjectLevel(
                    0), // Use document ID for navigation (optional)
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
