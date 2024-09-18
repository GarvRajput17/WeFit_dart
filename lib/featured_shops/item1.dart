import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopPage1 extends StatefulWidget {
  ShopPage1({Key? key}) : super(key: key);

  void userSignOut() {
    FirebaseAuth.instance.signOut();
  }
  @override
  State<ShopPage1> createState() => _ShopPage1State();
}

class _ShopPage1State extends State<ShopPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}