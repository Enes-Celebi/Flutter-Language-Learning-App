import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/first_time_flag.dart";
import "package:lingoneer_beta_0_0_1/pages/first_time/intended_language_selection.dart";
import "package:lingoneer_beta_0_0_1/services/language_provider.dart";
import "package:provider/provider.dart";

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({super.key});

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  String? _selectedLanguage;

  void _proceedToApp(Map<String, dynamic> languageData) {
    final language = languageData['language'];
    print('Selected language: $language');

    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    languageProvider.setSelectedLanguage(language);

    setState(() {
      _selectedLanguage = language;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IntendedLanguageSelection(onTap: () {},),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('languages').get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final Languages = snapshot.data!.docs;

          return Stack(
            children: [
              // Place your PageView here

              PageView(
                children: Languages.map((languageData) {
                  final title = languageData.get('name');
                  final imageURL = languageData.get('image');
                  // **Fix:** Access data using data() and cast to Map<String, dynamic>
                  final dataMap = languageData.data() as Map<String, dynamic>;

                  // Assuming FirstTimeFlag uses named arguments
                  return FirstTimeFlag(
                    title: title ?? 'No title',
                    imagePath: imageURL ?? 'lib/assets/images/test/pic1.png',
                    onImageClicked: () {
                      // **Fix:** Pass dataMap directly as it's already a Map
                      _proceedToApp(dataMap);
                    },
                  );
                }).toList(),
              ),

              // Text positioned below the PageView with fixed height and centered horizontally
              const Positioned(
                bottom: 0.0, // Pin to bottom
                left: 0.0, // Align left
                right: 0.0, // Align right (optional, fills available width)
                child: Padding(
                  padding: EdgeInsets.only(bottom: 150.0), // Adjust padding for vertical space
                  child: SizedBox(
                    height: 50.0, // Set desired text area height
                    child: Center( // Center the text horizontally
                      child: Text(
                        // Access 'name' from the document data
                        'Choose your language',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate back to home screen
          // _proceedToApp();
        },
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
