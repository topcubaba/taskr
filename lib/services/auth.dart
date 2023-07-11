import 'package:flutter/material.dart';
import 'package:taskr/pages/login.dart';
import 'package:taskr/pages/signup.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) => _isLogin
      ? Login(onClickedSignup: toggle)
      : Signup(onClickedLogin: toggle);

  void toggle() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }
}
