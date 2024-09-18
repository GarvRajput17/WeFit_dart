import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
    //begin sign in process
  final GoogleSignInAccount? guser = await GoogleSignIn().signIn();

    //obtain auth details from request
  final GoogleSignInAuthentication gauth = await guser!.authentication;
    //create a new credential for user
  final credential = GoogleAuthProvider.credential(
    accessToken: gauth.accessToken,
    idToken: gauth.idToken,
  );
    //finally, lets sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);  }
}
