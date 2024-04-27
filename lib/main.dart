import 'package:flutter/material.dart';
import 'package:lingoneer_beta_0_0_1/firebase_options.dart';
import 'package:lingoneer_beta_0_0_1/pages/login_page.dart';
import 'package:lingoneer_beta_0_0_1/pages/splash_screen.dart';
import 'package:lingoneer_beta_0_0_1/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: const LoginPage(onTap: null),
      home: SplashScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
