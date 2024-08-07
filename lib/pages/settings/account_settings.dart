import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lingoneer_beta_0_0_1/components/primary_button_component.dart';
import 'package:lingoneer_beta_0_0_1/services/language_provider.dart';
import 'package:provider/provider.dart';

class GeneralSettingsPage extends StatefulWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GeneralSettingsPage({super.key});

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {

  void showUsernameDialog(BuildContext context, String currentUsername) {
    final TextEditingController usernameController = TextEditingController(text: currentUsername);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            controller: usernameController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter new username',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newUsername = usernameController.text.trim();
                if (newUsername.isNotEmpty) {
                  editUsername(newUsername);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a username'),
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

  Future<void> editUsername(String newUsername) async {
    final user = widget._auth.currentUser;
    if (user != null) {
      final userDocRef = widget._firestore.collection('Users').doc(user.uid);
      await userDocRef.update({'username': newUsername});
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final String? languageId = languageProvider.selectedLanguage;
    final String? intendedLanguageId = languageProvider.intendedSelectedLanguage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Settings'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<QuerySnapshot>>(
          future: Future.wait([
            FirebaseFirestore.instance
              .collection('intended_languages')
              .where('language', isEqualTo: intendedLanguageId)
              .get(),
            FirebaseFirestore.instance
              .collection('languages')
              .where('language', isEqualTo: languageId)
              .get(),
          ]),
          builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data found'));
            } else {
              final intendedLanguageData = snapshot.data![1].docs;

              final String intendedLanguageImage = intendedLanguageData.isNotEmpty
                  ? (intendedLanguageData.first.data() as Map<String, dynamic>)['image'] ?? 'No image'
                  : 'No data';

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<User?>(
                      stream: widget._auth.authStateChanges(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final user = snapshot.data!;
                        final userId = user.uid;
                        final userDocRef = widget._firestore.collection('Users').doc(userId);

                        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: userDocRef.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            final userData = snapshot.data!.data();
                            final username = userData?['username'] ?? 'N/A';
                            final userEmail = userData?['email'] ?? 'N/A';

                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'User Language',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.inversePrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 150),
                                    GestureDetector(
                                      onTap: () {
                                        _showLanguageDialog(context);
                                      },
                                      child: Image.asset(
                                        intendedLanguageImage,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                // Username Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Username:   ',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).colorScheme.inversePrimary, // Color for 'Username:'
                                            ),
                                          ),
                                          TextSpan(
                                            text: username,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).colorScheme.primary, // Color for $username
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => showUsernameDialog(context, username),
                                      child: const Icon(Icons.edit, color: Colors.grey),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                // Email Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Email:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(userEmail),
                                  ],
                                ),
                                const SizedBox(height: 50),
                                MyButton(
                                  text: 'Go Back',
                                  onTap: () {Navigator.pop(context);},
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _showLanguageDialog(BuildContext context) async {
    QuerySnapshot<Map<String, dynamic>> languagesSnapshot =
        await widget._firestore.collection('languages').get();

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
                'Change your language',
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
                            .setSelectedLanguage(languageIds[index]);
                        Navigator.of(context).pop();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            languageImages[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 10),
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
