import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:lingoneer_beta_0_0_1/components/my_main_card.dart";
import "package:lingoneer_beta_0_0_1/pages/subject_level_page.dart";

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
        builder: (context) => subjectLevelPage(selectedCardIndex: index)
      ),
    );
  }

  Future<void> _logoutConfirmationDialog() async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Log out of your account?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // just close this dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            )
          ],
        );
      }
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
                  backgroundColor: const Color.fromARGB(255, 224, 224, 224),
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
                  // go to profile & settings page
                },
                child: Container(
                  width: 60, // Adjusted width to accommodate the border thickness
                  height: 60, // Adjusted height to accommodate the border thickness
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // Background color of the circle
                    border: Border.all(
                      color: Colors.white, // Color of the border
                      width: 8, // Width of the border
                    ),
                  ),
                  child: Container(
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
      
      body: PageView(
        
        children: [

          // first card
          MyMainCard(
                title: 'Sample Card 1',
                imagePath: 'lib/assets/images/test/pic1.png',
                progressValue: 0.5,
                cardColor: Colors.blue,
                progressColor: Colors.blue[800]!,
                onTap: () {
                  _goToSubjectLevel(0);
                },
              ),

          // second card
          MyMainCard(
                title: 'Sample Card 1',
                imagePath: 'lib/assets/images/test/pic1.png',
                progressValue: 0.5,
                cardColor: Colors.red,
                progressColor: Colors.red[800]!,
                onTap: () {
                  _goToSubjectLevel(0);
                },
              ),

          // third card
          MyMainCard(
                title: 'Sample Card 1',
                imagePath: 'lib/assets/images/test/pic1.png',
                progressValue: 0.5,
                cardColor: Colors.green,
                progressColor: Colors.green[800]!,
                onTap: () {
                  _goToSubjectLevel(0);
                },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // show logout confirmation dialog
          _logoutConfirmationDialog();
        },
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}