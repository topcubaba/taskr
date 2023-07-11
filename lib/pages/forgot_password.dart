import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/utils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final emailTEC = TextEditingController();

  @override
  void dispose() {
    emailTEC.dispose();
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
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: ElevatedButton.icon(
                onPressed: resetPassword,
                label: const Text("RESET PASSWORD"),
                icon: const Icon(Icons.arrow_forward_outlined),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailTEC.text.trim());
      Utils.showSnackBar("Password reset email sent");
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      //print(e);
      Utils.showSnackBar(e.message);
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ForgotPassword(),
        ),
      );
    }
  }
}
