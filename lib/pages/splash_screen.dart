import 'package:flutter/material.dart';
import 'package:lingoneer_beta_0_0_1/pages/first_time/user_language/language_selection.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
  await Future.delayed(const Duration(milliseconds: 2500), () {});
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      // builder: (context) => LanguageSelection(
      //   onLanguageSelected: (selectedLanguageData) {
      //     // nothing just trolling hehehe
      //   },
      // ),
      builder: (context) => LanguageSelection()
      ),
    );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color of splash screen
      body: Center(
        child: Image.asset('lib/assets/images/icons/first_page_logo.png'), // Your image asset
      ),
    );
  }
}
