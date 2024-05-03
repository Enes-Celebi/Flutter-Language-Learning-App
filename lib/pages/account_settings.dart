import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lingoneer_beta_0_0_1/services/languages_map.dart';

class GeneralSettingsPage extends StatelessWidget {
  // Firebase Firestore instance (replace with your initialization)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Auth instance (replace with your initialization)
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Simulate fetching user data from somewhere (replace with actual logic)
  // final String userLanguage = 'English'; // Add placeholder for user language
  // final String learnedLanguage =
  //     'Spanish'; // Add placeholder for learned language

  void showUsernameDialog(BuildContext context, String currentUsername) {
    final TextEditingController usernameController =
        TextEditingController(text: currentUsername);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            controller: usernameController,
            autofocus: true, // Automatically focus the text field
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
                  Navigator.pop(context); // Close the dialog
                } else {
                  // Show error message if username is empty
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
    final user = _auth.currentUser;
    if (user != null) {
      final userDocRef = _firestore.collection('Users').doc(user.uid);
      await userDocRef.update({'username': newUsername});
    }
  }

  // Function to edit email (requires re-authentication)
  Future<void> editEmail(String newEmail) async {
    final user = _auth.currentUser;
    if (user != null) {
      // Get user credentials for re-authentication (replace with your logic)
// Implement this method

      // Re-authenticate the user

      // Update email after successful re-authentication
      await user.updateEmail(newEmail);
    }
  }

  Future<AuthCredential> getAuthCredential() async {
    // Prompt user for current password or other verification method
    // ...
    throw Exception(
        'Not implemented: getAuthCredential'); // Replace with implementation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Get the current user document ID
            StreamBuilder<User?>(
              stream: _auth.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final user = snapshot.data!;
                final userId = user.uid;

                // Use userId to construct the document reference (replace with your logic)
                final userDocRef = _firestore.collection('Users').doc(userId);

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
                    final languageCombination = userData?['language'] ?? 'N/A';

                    List<String> extractedLanguages =
                        extractLanguages(languageCombination);
                    String userLanguage = extractedLanguages[0];
                    String learnedLanguage = extractedLanguages[1];

                    print(languageCombination);
                    return Column(
                      children: [
                        // Username Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Username:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(username),
                            // Non-functional edit button (for testing)
                            ElevatedButton(
                              onPressed: () => showUsernameDialog(
                                  context, username), // Does nothing on press
                              child: const Text('Edit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.grey[200], // Light gray button
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                            height: 16.0), // Add spacing between rows
                        // Email Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Email:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(userEmail),
                            // Non-functional edit button (for testing)
                            ElevatedButton(
                              onPressed: () => null, // Does nothing on press
                              child: const Text('Edit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.grey[200], // Light gray button
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'User Language:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(userLanguage),
                            // Add edit button functionality here (optional)
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.grey[200], // Light gray button
                              ), // Replace with actual edit logic
                              child: const Text('Edit'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Learned Language:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(learnedLanguage),
                            // Add edit button functionality here (optional)
                            ElevatedButton(
                              onPressed: () => null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.grey[200], // Light gray button
                              ), // Replace with actual edit logic
                              child: const Text('Edit'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16.0), // Add spacing

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Delete Account Button (WARNING:
                TextButton(
                  onPressed: () {
                    // Implement confirmation logic and handle deletion (replace with actual logic)
                    // This is where you would display a custom confirmation dialog or prompt
                  },
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                // Change Password Button
                TextButton(
                  onPressed: () {
                    // Navigate to change password screen (replace with actual navigation)
                    Navigator.pushNamed(context,
                        '/change-password'); // Replace with your route name
                  },
                  child: const Text('Change Password'),
                ),
              ],
            ),
          ],
        ),
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
}
