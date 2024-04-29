import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/first_time_flag.dart";
import "package:lingoneer_beta_0_0_1/pages/register_page.dart";
import "package:lingoneer_beta_0_0_1/services/language_provider.dart";
import "package:provider/provider.dart";

class IntendedLanguageSelection extends StatefulWidget {
  const IntendedLanguageSelection({super.key, required Null Function() onTap});

  @override
  State<IntendedLanguageSelection> createState() => _IntendedLanguageSelectionState();
}

class _IntendedLanguageSelectionState extends State<IntendedLanguageSelection> {
  String? _intendedSelectedLanguage;

  void _proceedToApp(Map<String, dynamic> languageData) {
    final language = languageData['language'];
    print('Selected language: $language');

    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    languageProvider.setIntendedSelectedLanguage(language); // Use setIntendedSelectedLanguage here

    setState(() {
      _intendedSelectedLanguage = language;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(onTap: () {  },),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('intended_languages').get(),
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
                  final dataMap = languageData.data() as Map<String, dynamic>;
                  
                  // Assuming FirstTimeFlag uses named arguments
                  return FirstTimeFlag(
                    title: title ?? 'No title',
                    imagePath: imageURL ?? 'lib/assets/images/test/pic1.png', 
                    onImageClicked: () {
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
          //_proceedToApp(data);
        },
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
