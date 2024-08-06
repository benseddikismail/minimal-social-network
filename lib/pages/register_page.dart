import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/my_button.dart';
import 'package:social_app/components/my_textfield.dart';
import 'package:social_app/helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {

  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController usernameController =  TextEditingController();
  final TextEditingController emailController =  TextEditingController();
  final TextEditingController passwordController =  TextEditingController();
  final TextEditingController confirmPwController =  TextEditingController();

  // register method
  void registerUser() async {
    // show loading circle
    showDialog(
      context: context, 
      builder: (context) => const Center(
        child: CircularProgressIndicator()
      )
    );
    // make sure passwords match
    if (passwordController.text != confirmPwController.text) {
      
      // pop loading circle
      Navigator.pop(context);
      // error msg
      displayMessageToUser("Passwords do not match!", context);

    } else {
      // create user
      try {
        UserCredential? userCredential = 
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, 
            password: passwordController.text
        );

        createUserDocument(userCredential);

        // pop loading circle
        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch(e) {
        // pop loading circle
        Navigator.pop(context);
        displayMessageToUser(e.code, context);
      }
    }

  }

  // create user document and add to firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance 
            .collection("Users")
            .doc(userCredential.user!.email)
            .set({
              'email': userCredential.user!.email,
              'username': usernameController.text
            });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
          
              const SizedBox(height: 25),
          
              // app name
              Text(
                "N E T W O R K",
                style: TextStyle(fontSize: 20),
              ),
          
              const SizedBox(height: 25),

              // username
              MyTextField(
                hintText: "Username", 
                obscureText: false, 
                controller: usernameController
              ),

              const SizedBox(height: 10),
              
              // email
              MyTextField(
                hintText: "Email", 
                obscureText: false, 
                controller: emailController
              ),

              const SizedBox(height: 10),
              
              // password
              MyTextField(
                hintText: "Password", 
                obscureText: true, 
                controller: passwordController
              ),

              const SizedBox(height: 10),
              
              // confirm password
              MyTextField(
                hintText: "Confirm Password", 
                obscureText: true, 
                controller: confirmPwController
              ),

              // const SizedBox(height: 10),

              // forgot password
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Text(
              //       "Forgot Password?",
              //       style: TextStyle(color: Theme.of(context).colorScheme.secondary)
              //     ),
              //   ],
              // ),

              const SizedBox(height: 35),

              // register button
              MyButton(
                text: "Register", 
                onTap: registerUser
              ),

              const SizedBox(height: 25),

              // register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?", 
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      " Login Here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )

            ],
          ),
        )
      ),
    );

  }
}