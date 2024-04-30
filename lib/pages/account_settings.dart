import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GeneralSettingsPage extends StatelessWidget {
  // Firebase Firestore instance (replace with your initialization)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Auth instance (replace with your initialization)
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Simulate fetching user data from somewhere (replace with actual logic)
  final String userLanguage = 'English'; // Add placeholder for user language
  final String learnedLanguage = 'Spanish'; // Add placeholder for learned language

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
                              onPressed: () => null, // Does nothing on press
                              child: const Text('Edit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200], // Light gray button
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0), // Add spacing between rows
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
                                backgroundColor: Colors.grey[200], // Light gray button
                              ),
                            ),
                          ],
                        ),
                        // ... rest of your UI ...
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16.0), // Add spacing

            // User Language Row
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
                  onPressed: () => null, // Replace with actual edit logic
                  child: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200], // Light gray button
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0), // Add spacing between rows

            // Learned Language Row
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
                  onPressed: () => null, // Replace with actual edit logic
                  child: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200], // Light gray button
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0), // Add spacing

            // Row for Delete Account and Change Password buttons
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

