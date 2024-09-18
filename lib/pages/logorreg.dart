import 'package:flutter/material.dart';
import 'package:wefit/pages/registerpage.dart';

import 'login_page.dart';
//import 'package:puma/pages/login_page.dart';
//import 'package:puma/pages/registerpage.dart';

class LogOrReg extends StatefulWidget {
  const LogOrReg({super.key});

  @override
  State<LogOrReg> createState() => _LogOrRegState();
}

class _LogOrRegState extends State<LogOrReg> {
  @override

  //initially show login page
  bool showLoginPage = true;

  //toggle between login and register page
  void togglePage() {
    setState(() {
      showLoginPage != showLoginPage;
    });
  }


  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePage,);
    } else {
      return RegisterPage(onTap: togglePage,);
    }
  }
}