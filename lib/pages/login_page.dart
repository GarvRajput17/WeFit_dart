import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wefit/pages/registerpage.dart';
import '../components/box.dart';
import '../components/my_button.dart';
import '../components/textfield.dart';
import '../services/auth_service.dart';
import 'homepage1.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});
  //LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Replace with your actual route
      );
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      showErrorMessage(e.code);
    }
  }



  // wrong password message popup
  void showErrorMessage(String message) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey,
        title: Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.black),
          )
        )
      );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Center(
                  child: Image(
                    image: AssetImage('lib/images/Frame1.png'),
                    height: 280,
                    width: 280,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please Login To Continue',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
          
                MyButton(onTap: signUserIn),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(child: Divider(thickness: 0.5, color: Colors.grey[400])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('Or Continue With', style: TextStyle(color: Colors.grey[700])),
                      ),
                      Expanded(child: Divider(thickness: 0.5, color: Colors.grey[400])),
                    ],
                  ),
                ),
                /*const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(onTap: () => AuthService().signInWithGoogle(), imagePath: 'lib/images/google.png'),

                    const SizedBox(width: 10),

                    SquareTile(onTap: () {}, imagePath: 'lib/images/apple.png'),
                  ],
                ),


                 */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      onTap: () {
                        AuthService().signInWithGoogle().then((user) {
                          // Authentication successful!
                          Navigator.pushNamed(context, '/'); // Navigate to the home page
                        }).catchError((error) {
                          // Handle authentication error
                          print('Error signing in: $error');
                        });
                      },
                      imagePath: 'lib/images/google.png',
                    ),
                    const SizedBox(width: 10),
                    SquareTile(
                      onTap: () {
                        // Logic for Apple sign-in (if applicable)
                        // You can add similar navigation logic here if needed
                      },
                      imagePath: 'lib/images/apple.png',
                    ),
                  ],
                ),


                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not A Member? ', style: TextStyle(color: Colors.grey[700]),),
                    const SizedBox(width: 4),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => RegisterPage(onTap: () {  },)),
                          );
                        },
                        child: Text('Register Now', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))),
                  ],
                )
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}
