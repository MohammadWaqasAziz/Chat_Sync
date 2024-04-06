import 'package:chatsync/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 5000),
      () {
        setState(() {
          _isAnimated = true;
        });
      },
    );
  }

  _handleSignInButton() {
    try {
      signInWithGoogle().then(
        (user) {
          print('User: ${user.additionalUserInfo}');
          print('User: ${user.credential}');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const HomeScreen(title: "Home Screen")));
        },
      );
    } catch (e) {
      // Handle error here
      print('Error: $e');
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            top: mq.height * 0.10,
            right: _isAnimated ? mq.width * 0.30 : -mq.width * 0.5,
            width: mq.width * 0.5,
            duration: const Duration(seconds: 1),
            child: Image.asset('images/chat.png'),
          ),
          Positioned(
            bottom: mq.height * 0.15,
            height: mq.height * 0.1,
            left: mq.width * 0.27,
            width: mq.width * 0.5,
            child: FloatingActionButton(
              onPressed: () {
                _handleSignInButton();
              },
              tooltip: 'Sign up with Google',
              child: Image.asset(
                'images/signup.png',
                fit: BoxFit.fill, // or BoxFit.contain
              ),
            ),
          ),
        ],
      ),
    );
  }
}
