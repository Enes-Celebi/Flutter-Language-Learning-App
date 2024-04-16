import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:lingoneer_beta_0_0_1/auth/auth_service.dart";
import "package:lingoneer_beta_0_0_1/components/my_button.dart";
import "package:lingoneer_beta_0_0_1/components/my_textfield.dart";
import "package:lingoneer_beta_0_0_1/pages/home_page.dart";

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  // text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login method
  void login() async {
  try {
    final user = await _auth.loginUserWithEmailAndPassword(
      emailController.text,
      passwordController.text,
    );

    if (user != null) {
      print("User Logged In");

      // navigate to home page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
    else{
      print("anas error");
    }
  } on FirebaseAuthException catch (e) {
    print("hello from catching errors");
    
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      // Show a snackbar or dialog to the user
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that email.');
      // Show a snackbar or dialog to the user
    } else {
      print(e.code); // Log the error code for debugging
      // Show a generic error message to the user
    }
  } catch (e) {
    print(e); // Log the error for debugging
    // Show a generic error message to the user
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
              "Food delivery app new",
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
                  onTap: widget.onTap,
                  child: Text(
                    "Register now",
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