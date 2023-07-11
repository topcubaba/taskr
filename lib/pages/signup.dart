import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';
import '../utils/utils.dart';

class Signup extends StatefulWidget {
  final Function() onClickedLogin;

  const Signup({Key? key, required this.onClickedLogin}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formKey = GlobalKey<FormState>();
  final emailTEC = TextEditingController();
  final passTEC = TextEditingController();

  @override
  void dispose() {
    emailTEC.dispose();
    passTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              "Taskr",
              style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0197F6)),
            ),
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Please enter a valid email'
                          : null,
                  controller: emailTEC,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'Please enter min. 6 characters'
                      : null,
                  controller: passTEC,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: ElevatedButton.icon(
                onPressed: signUp,
                label: const Text("SIGN UP"),
                icon: const Icon(Icons.arrow_forward_outlined),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40)),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: widget.onClickedLogin,
                  child: const Text('Log in',
                      style: TextStyle(
                          color: Color(0xFF0197F6),
                          decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTEC.text.trim(),
        password: passTEC.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      //print(e);

      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
