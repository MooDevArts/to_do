import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = "";

  Future<void> _signUp() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
      // If sign up is successful, the user will be automatically logged in
      print('User signed up: ${userCredential.user?.uid}');
      if (userCredential.user != null) {
        print('Attempting to create user data in Realtime Database');
        FirebaseDatabase.instance
            .ref('users')
            .child(userCredential.user!.uid)
            .child('tasks')
            .set({});
        // print('Successfully created user data in Realtime Database');
      }
      // You might want to navigate to the home screen here,
      // but the StreamBuilder in main.dart will handle it automatically
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          errorMessage = 'The password provided is too weak.';
        });
        // Display error to the user
      } else if (e.code == 'email-already-in-use') {
        try {
          final FirebaseAuth auth = FirebaseAuth.instance;
          await auth.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
        } on FirebaseAuthException catch (e) {
          setState(() {
            if (e.code == 'user-not-found') {
              errorMessage = 'No user found for that email.';
            } else if (e.code == 'wrong-password') {
              errorMessage = 'Wrong password provided for that user.';
            } else {
              errorMessage = 'Error during login: ${e.message}';
            }
          });
        } catch (e) {
          print(e);
        }

        // Display error to the user
      } else {
        setState(() {
          errorMessage = 'Error during sign up: ${e.message}';
          print(e);
          // Display a general error to the user
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up / Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 20),
              Text(errorMessage, style: TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: const Text('Sign Up / Login'),
              ),
              // You can add a button here to navigate to the login screen
              // or to switch between sign up and login forms
            ],
          ),
        ),
      ),
    );
  }
}
