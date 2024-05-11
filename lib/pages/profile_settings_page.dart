import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:lingoneer_beta_0_0_1/pages/account_settings.dart';
import 'package:lingoneer_beta_0_0_1/pages/login_page.dart';
import 'package:lingoneer_beta_0_0_1/services/language_provider.dart';
import 'package:lingoneer_beta_0_0_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final String? intendedLanguageId = languageProvider.intendedSelectedLanguage;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: const Color.fromARGB(255, 224, 224, 224),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: 15,
              child: Container(
                width: 80, 
                height: 80, 
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                    width: 8,
                  ),
                ),
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 30,
              top: 120,
              child: GestureDetector(
                onTap: () {
                  // Open language selection dialog
                  _showIntendedLanguageDialog(context);
                },
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: const BoxDecoration(),
                    child: FutureBuilder<String?>(
                      future: Provider.of<LanguageProvider>(context)
                        .getIntendedLanguageImageURL(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Icon(Icons.error);
                        } else if (snapshot.hasData) {
                          // Check if the snapshot data is not null
                          String? imageUrl = snapshot.data;
                          if (imageUrl != null && imageUrl.isNotEmpty) {
                            return ClipRRect(
                              child: Image.asset(
                                imageUrl, // Use Image.asset instead of Image.network
                                fit: BoxFit.contain,
                              ),
                            );
                          } else {
                            return Text("No image available");
                          }
                        } else {
                          return Text("No data available");
                        }
                      },
                  )
                )
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _firestore.collection('intended_languages').doc(intendedLanguageId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final languageData = snapshot.data!.data();
          final String? intendedLanguage = languageData?['name'];
          final String? intendedLanguageImage = languageData?['image'];

          return ListView(
            children: [
              ListTile(
                title: const Text('Account'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GeneralSettingsPage()),
                  );
                },
              ),
              ListTile(
                title: const Text('Dark Mode'),
                trailing: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) => Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) => themeProvider.toggleTheme(),
                  ),
                ),
              ),
              ListTile(
                title: const Text('User Language'),
                trailing: GestureDetector(
                  onTap: () {
                    // Open user language selection dialog
                    _showUserLanguageDialog(context);
                  },
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: FutureBuilder<String?>(
                      future: Provider.of<LanguageProvider>(context)
                        .getIntendedLanguageImageURL(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Icon(Icons.error);
                        } else if (snapshot.hasData) {
                          return ClipRRect(
                            child: Image.network(
                              snapshot.data!,
                              fit: BoxFit.contain,
                            ),
                          );
                        } else {
                          return Text("No data available");
                        }
                      },
                    ),
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Sign Out'),
                trailing: const Icon(Icons.logout),
                onTap: () async {
                  await _auth.signOut();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(
                        onTap: null,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate back to home screen
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  String? getImageForLanguage(String? language) {

  }

  // Function to show language selection dialog
  Future<void> _showIntendedLanguageDialog(BuildContext context) async {
    QuerySnapshot<Map<String, dynamic>> languagesSnapshot =
        await _firestore.collection('intended_languages').get(); // Fetch languages from Firestore

    List<String> languageNames = languagesSnapshot.docs
        .map((doc) => doc.data()['name'] as String) // Get language names
        .toList();

    List<String> languageImages = languagesSnapshot.docs
        .map((doc) => doc.data()['image'] as String) // Get local image asset paths
        .toList();

    // Display bottom sheet with language selection
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the bottom sheet to occupy half of the screen
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5, // Set the height to half of the screen
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
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [// Display language name
                        Image.asset(
                          languageImages[index], // Load local image asset
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10.0),
                        Text(languageNames[index]), 
                      ],
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

    // Function to show language selection dialog
  Future<void> _showUserLanguageDialog(BuildContext context) async {
    QuerySnapshot<Map<String, dynamic>> languagesSnapshot =
        await _firestore.collection('languages').get(); // Fetch languages from Firestore

    List<String> languageNames = languagesSnapshot.docs
        .map((doc) => doc.data()['name'] as String) // Get language names
        .toList();

    List<String> languageImages = languagesSnapshot.docs
        .map((doc) => doc.data()['image'] as String) // Get local image asset paths
        .toList();

    // Display bottom sheet with language selection
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the bottom sheet to occupy half of the screen
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5, // Set the height to half of the screen
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'What language do you speak?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: PageView.builder(
                  itemCount: languageNames.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [// Display language name
                        Image.asset(
                          languageImages[index], // Load local image asset
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10.0),
                        Text(languageNames[index]), 
                      ],
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
