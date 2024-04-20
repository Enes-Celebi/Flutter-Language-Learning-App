import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
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
  final _auth = FirebaseAuth.instance;
  // text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // login method
  void signup() async {
    if (passwordController.text == confirmPasswordController.text){
      try {
    final user = await _auth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (user != null) {
      print("User created successfully");

      // navigate to home page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  } catch (e) {
    String message = "Sign Up failed";
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }
    }
    else{
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