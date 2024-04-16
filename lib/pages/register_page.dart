import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/auth/auth_service.dart";
import "package:lingoneer_beta_0_0_1/components/my_button.dart";
import "package:lingoneer_beta_0_0_1/components/my_textfield.dart";
import "package:lingoneer_beta_0_0_1/pages/home_page.dart";

class RegisterPage extends StatefulWidget {

  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = AuthService();
  // text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // login method
  void signup() async {
  try {
    final user = await _auth.createUserWithEmailAndPassword(
      emailController.text.trim(), // Trim leading/trailing whitespace
      passwordController.text,
    );

    if (user != null) {
      print("user created");

      // navigate to home page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  } on FirebaseAuthException catch (e) {
    String message = "";
    if (e.code == 'weak-password') {
      message = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      message = 'The account already exists for that email.';
    } else {
      message = 'An error occurred. Please try again.'; // Generic message
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  } catch (e) {
    print(e); // Log the error for debugging
    // Show a generic error message to the user (optional)
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.lock_open_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),

            const SizedBox(height: 25),

            // message, app slogan
            Text(
              "Food delivery app",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.inversePrimary,
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

            // password textfield
            MyTextField(
              controller: confirmPasswordController, 
              hintText: "Confirm password", 
              obscureText: true
            ),

            const SizedBox(height: 25),

            // sign up button
            MyButton(
              text: "Sign up", 
              onTap: signup,
            ),

            const SizedBox(height: 25),

            // already have an account? login here
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
                  onTap: widget.onTap,
                  child: Text(
                    "login now",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}