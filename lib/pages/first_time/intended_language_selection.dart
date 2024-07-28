import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lingoneer_beta_0_0_1/pages/login_page.dart';
import 'package:lingoneer_beta_0_0_1/services/language_provider.dart';
import 'package:provider/provider.dart';

class IntendedLanguageSelection extends StatefulWidget {
  const IntendedLanguageSelection({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<IntendedLanguageSelection> createState() => _IntendedLanguageSelectionState();
}

class _IntendedLanguageSelectionState extends State<IntendedLanguageSelection> {
  final ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> _languages = [];
  String? _selectedUserLanguage; // User language from LanguageProvider

  @override
  void initState() {
    super.initState();
    // Access the selected user language from LanguageProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      setState(() {
        _selectedUserLanguage = languageProvider.selectedLanguage;
      });
      fetchIntendedLanguages();
    });
  }

  Future<void> fetchIntendedLanguages() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('intended_languages').get();
      setState(() {
        _languages = snapshot.docs.where((doc) => doc.get('language') != _selectedUserLanguage).toList();
      });
    } catch (e) {
      print('Error fetching intended languages: $e');
    }
  }

  void _proceedToApp(Map<String, dynamic> languageData) {
    final language = languageData['language'];
    print('Selected language: $language');

    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    languageProvider.setIntendedSelectedLanguage(language); // Use setIntendedSelectedLanguage here

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(onTap: widget.onTap),
      ),
    );
  }

  void _onUserLanguageChanged(String? newLanguage) {
    if (newLanguage != null) {
      setState(() {
        _selectedUserLanguage = newLanguage;
      });
    }
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

          _languages = snapshot.data!.docs.where((doc) => doc.get('language') != _selectedUserLanguage).toList();

          return Stack(
            children: [
              _buildTitle(),
              _buildLanguageListView(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage(onTap: widget.onTap)),
          );
        },
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildTitle() {
    return const Positioned(
      top: 100,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          'Choose the language you want to learn',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildLanguageListView() {
    return Positioned(
      top: 200,
      left: 0,
      right: 0,
      bottom: 0,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        itemCount: _languages.length,
        itemBuilder: (context, index) {
          final languageData = _languages[index];
          final translations = languageData.get('translation') as Map<String, dynamic>;
          final imageURL = languageData.get('image') ?? 'lib/assets/images/test/pic1.png';
          final languageCode = languageData.get('language');
          final languageName = translations[_selectedUserLanguage] ?? 'Unknown';

          return GestureDetector(
            onTap: () => _proceedToApp(languageData.data() as Map<String, dynamic>),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Center(
                child: Container(
                  width: 200,
                  height: 80,
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        child: Image.asset(
                          imageURL,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        languageName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
