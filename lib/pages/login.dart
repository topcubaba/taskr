import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:taskr/pages/forgot_password.dart';
import 'package:taskr/utils/consts.dart';

import '../main.dart';
import '../utils/utils.dart';

class Login extends StatefulWidget {
  final VoidCallback onClickedSignup;

  const Login({Key? key, required this.onClickedSignup}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailTEC = TextEditingController();
  final passTEC = TextEditingController();
  final FocusNode _emailFocusedNode = FocusNode();
  final FocusNode _passFocusedNode = FocusNode();
  bool loginIconVisible = true;

  @override
  void initState() {
    super.initState();
    // SETTING VISIBILITY OF ANIMATION ACCORDING TO KEYBOARD STATE
    /*
    _emailFocusedNode.addListener(() {
      _emailFocusedNode.hasFocus ? setState(() {loginIconVisible = false;}) : setState(() {loginIconVisible = true;});
    });
    _passFocusedNode.addListener(() {
      _passFocusedNode.hasFocus ? setState(() {loginIconVisible = false;}) : setState(() {loginIconVisible = true;});
    });
    */
  }

  @override
  void dispose() {
    _emailFocusedNode.dispose();
    _passFocusedNode.dispose();
    emailTEC.dispose();
    passTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        toolbarHeight: 25,
      ),
      //LOGIN PAGE APP TITLE
      body: Column(
        children: [
          const Text(
            "Taskr",
            style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary),
          ),
          Visibility(
            visible: loginIconVisible,
            child:
                const Expanded(child: RiveAnimation.asset('assets/login.riv')),
          ),
          //EMAIL TEXT FIELD
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
            child: TextFormField(
              onTapOutside: (b) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              focusNode: _emailFocusedNode,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Please enter a valid email'
                      : null,
              controller: emailTEC,
              cursorColor: AppColors.secondary,
              decoration: const InputDecoration(
                hintText: "Email",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          //PASSWORD TEXT FIELD
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: TextFormField(
              focusNode: _passFocusedNode,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6
                  ? 'Please enter min. 6 characters'
                  : null,
              controller: passTEC,
              obscureText: true,
              obscuringCharacter: '*',
              cursorColor: AppColors.secondary,
              decoration: const InputDecoration(
                hintText: 'Password',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondary),
                ),
              ),
            ),
          ),
          //FORGOT PASSWORD PART
          Padding(
            padding: const EdgeInsets.only(right: 43.0, left: 35, bottom: 10.0),
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: AppColors.secondary),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPassword(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: primaryPadding,
            child: MaterialButton(
              child: const Text("Login"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              textColor: AppColors.primary,
              onPressed: logIn,
              color: AppColors.secondary,
              minWidth: double.infinity,
            ),
          ),
          Padding(
            padding: allPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: widget.onClickedSignup,
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                        color: AppColors.secondary,
                        decoration: TextDecoration.underline),
                  ),
                ),
                const Text(
                  'or Login with',
                  style: TextStyle(color: AppColors.secondary),
                ),
              ],
            ),
          ),
          Padding(
            padding: primaryPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MaterialButton(
                    child: const Icon(Icons.apple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textColor: AppColors.primary,
                    onPressed: () {},
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MaterialButton(
                    child: const Icon(Icons.g_mobiledata),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textColor: AppColors.primary,
                    onPressed: () {},
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MaterialButton(
                    child: const Icon(Icons.facebook),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textColor: AppColors.primary,
                    onPressed: () {},
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MaterialButton(
                    child: const Icon(Icons.no_accounts),
                    onPressed: logInAnon,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textColor: AppColors.primary,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  Future logIn() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
          child: SizedBox(
              width: 150,
              height: 150,
              child: RiveAnimation.asset('assets/loading.riv'))),
      barrierDismissible: false,
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTEC.text.trim(),
        password: passTEC.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      //print(e);
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future logInAnon() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      //print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
