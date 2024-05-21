import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/primary_button_component.dart";
import "package:lingoneer_beta_0_0_1/components/primary_textfield_component.dart";
import "package:lingoneer_beta_0_0_1/pages/subject_page.dart";
import "package:lingoneer_beta_0_0_1/pages/login_page.dart";
import "package:lingoneer_beta_0_0_1/services/language_provider.dart";
import "package:provider/provider.dart";

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void signup(BuildContext context) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final String? languageComb = languageProvider.languageComb;

    if (passwordController.text == confirmPasswordController.text) {
      try {
        final user = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.user!.uid)
            .set({
          'userId': user.user!.uid,
          'email': user.user!.email,
          'language': languageComb,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(selectedLanguageComb: languageComb)),
        );
            } catch (e) {
        String message = "Sign Up failed";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    } else {
      String message = "Password not matching";
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
                  "Register",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false),
              const SizedBox(height: 15),
              MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true),
              const SizedBox(height: 15),
              MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm password",
                  obscureText: true),
              const SizedBox(height: 15),
              MyButton(
                text: "Sign up",
                onTap: () => signup(context),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage(
                                  onTap: null,
                                )
                          )
                      );
                    },
                    child: Text(
                      "login now",
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
                onTap: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}