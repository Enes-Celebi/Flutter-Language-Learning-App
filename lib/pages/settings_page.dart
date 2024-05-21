import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingoneer_beta_0_0_1/components/appbar_component.dart';
import 'package:lingoneer_beta_0_0_1/components/primary_button_component.dart';
import 'package:lingoneer_beta_0_0_1/pages/account_settings.dart';
import 'package:lingoneer_beta_0_0_1/services/language_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final String? languageId = languageProvider.selectedLanguage;
    final String? intendedLanguageId = languageProvider.intendedSelectedLanguage;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: FutureBuilder<List<QuerySnapshot>>(
        future: Future.wait([
          FirebaseFirestore.instance
              .collection('languages')
              .where('language', isEqualTo: languageId)
              .get(),
          FirebaseFirestore.instance
              .collection('intended_languages')
              .where('language', isEqualTo: intendedLanguageId)
              .get(),
        ]),
        builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            final intendedLanguageData = snapshot.data![1].docs;

            final String intendedLanguageImage = intendedLanguageData.isNotEmpty
                ? (intendedLanguageData.first.data() as Map<String, dynamic>)['image'] ?? 'No image'
                : 'No data';

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            isDarkMode = value;
                          });
                        },
                        activeColor: Colors.blue,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    thickness: 2,
                    indent: 16,
                    endIndent: 16
                  ),
                  const SizedBox(height:25),
                  Text(
                    'Course Language',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      _showIntendedLanguageDialog(context);
                    },
                    child: Image.asset(
                      intendedLanguageImage,
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Divider(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    thickness: 2,
                    indent: 16,
                    endIndent: 16
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyButton(
                        text: 'Go Back',
                        onTap: () => Navigator.pop(context),
                      ),
                      MyButton(
                        text: 'Advanced',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GeneralSettingsPage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _showIntendedLanguageDialog(BuildContext context) async {
    QuerySnapshot<Map<String, dynamic>> languagesSnapshot =
        await widget._firestore.collection('intended_languages').get();

    List<String> languageNames = languagesSnapshot.docs
        .map((doc) => doc.data()['name'] as String)
        .toList();

    List<String> languageIds = languagesSnapshot.docs
        .map((doc) => doc.data()['language'] as String)
        .toList();

    List<String> languageImages = languagesSnapshot.docs
        .map((doc) => doc.data()['image'] as String)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'What language do you want to learn?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: PageView.builder(
                  itemCount: languageNames.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Provider.of<LanguageProvider>(context, listen: false)
                            .setIntendedSelectedLanguage(languageIds[index]);
                        Navigator.of(context).pop();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            languageImages[index],
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 10.0),
                          Text(languageNames[index]),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
