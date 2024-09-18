import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage1.dart';
import 'login_page.dart';
import 'logorreg.dart'; // Import FirebaseAuth

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  late AnimationController _logoTextAnimationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Logo and text animation
    _logoTextAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    _logoAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoTextAnimationController, curve: Curves.easeInOut),
    );

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoTextAnimationController, curve: Curves.easeInOut),
    );

    // Start the logo and text animations
    _logoTextAnimationController.forward().whenComplete(() {
      // Animation completed, check authentication status
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          // User is authenticated, navigate to HomePage
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          // User is not authenticated, show LoginPage
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogOrReg()));
        }
      });
    });
  }

  @override
  void dispose() {
    _logoTextAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _logoAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoAnimation.value,
                  child: Transform.scale(
                    scale: _logoAnimation.value,
                    child: Image.asset('lib/images/intro.png'),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _textAnimation.value,
                  child: Text(
                    'RESHAPE YOUR BODY',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),

            const SizedBox(height: 5),

            AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _textAnimation.value,
                  child: Text(
                    'RESHAPE YOUR LIFESTYLE',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            AnimatedBuilder(animation: _textAnimation, builder: (context, child) {
              return Opacity(opacity: _textAnimation.value,
                  child: Text(
                    'POWERED BY WEFIT',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.grey),
                  )
              );
            })
          ],
        ),
      ),
    );
  }
}
