import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/my_button.dart";
import "package:lingoneer_beta_0_0_1/components/my_textfield.dart";
import "package:lingoneer_beta_0_0_1/pages/subject_page.dart";
import "package:lingoneer_beta_0_0_1/pages/signup_page.dart";
import "package:lingoneer_beta_0_0_1/services/language_provider.dart";
import "package:provider/provider.dart";

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final String? languageComb = languageProvider.languageComb;

    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (cred.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(selectedLanguageComb: languageComb)),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = e.code;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 160),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: emailController, 
                hintText: "Email", 
                obscureText: false
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: passwordController, 
                hintText: "Password", 
                obscureText: true
              ),
              const SizedBox(height: 25),
              MyButton(
                text: "Sign in", 
                onTap: login,
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member??",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage(onTap: () {  },)),
                      );
                    },
                    child: Text(
                      "Register now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25),
              Divider(
                color: Theme.of(context).colorScheme.inversePrimary,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              const SizedBox(height: 25),
              const MyButton(
                text: "Google sign up", 
                onTap: null
              ),
            ],
          ),
        ),
      ),
    );
  }
}
