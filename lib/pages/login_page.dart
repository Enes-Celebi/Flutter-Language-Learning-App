import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/components/my_button.dart";
import "package:lingoneer_beta_0_0_1/components/my_textfield.dart";
import "package:lingoneer_beta_0_0_1/pages/home_page.dart";
import "package:lingoneer_beta_0_0_1/pages/register_page.dart";

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  // text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login method
  void login() async {
   try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (cred.user != null) {
        
        // Navigate to the home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }  on FirebaseAuthException catch (e) {
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
          
              // message, app slogan
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
          
              // email textfield
              MyTextField(
                controller: emailController, 
                hintText: "Email", 
                obscureText: false
              ),
          
              const SizedBox(height: 25),
          
              // password textfield
              MyTextField(
                controller: passwordController, 
                hintText: "Password", 
                obscureText: true
              ),
          
              const SizedBox(height: 25),
          
              // sign in button
              MyButton(
                text: "Sign in", 
                onTap: login,
              ),
          
              const SizedBox(height: 25),
          
              // not a member? register now
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
                      // Navigate to the registration screen
                      Navigator.push(
                        context, // Current build context
                        MaterialPageRoute(builder: (context) => RegisterPage(onTap: () {  },)), // Route definition
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

              // Add a divider
              Divider(
                color: Theme.of(context).colorScheme.inversePrimary,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),

              const SizedBox(height: 25),

              // sign up button
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