import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingoneer_beta_0_0_1/pages/login_page.dart';


class SettingsPage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
                child: Container(
                  width:
                      80, // Adjusted width to accommodate the border thickness
                  height:
                      80, // Adjusted height to accommodate the border thickness
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // Background color of the circle
                    border: Border.all(
                      color: Colors.white, // Color of the border
                      width: 8, // Width of the border
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
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('General'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to a separate general settings page (optional)
              // You can use Navigator.push(...) or a navigation library
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GeneralSettingsPage()),
              );
            },
          ),
          const ListTile(
            title: Text('Notifications'),
            trailing: Switch(
              value: true, // Adjust initial switch value
              onChanged: null, // Handle switch change
            ),
          ),
          ListTile(
            title: const Text('Sign Out'),
            trailing: const Icon(Icons.logout),
            onTap: () async {
              await _auth.signOut();

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage(onTap: () {  },)));
            },
          ),
        ],
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

// Assuming you have a separate GeneralSettingsPage widget
class GeneralSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('General Settings'),
      ),
      // Add your general settings UI here
    );
  }
}
