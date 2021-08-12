import 'package:authentication_through_email/Screen/home_page.dart';
import 'package:authentication_through_email/methods_for_signIn_and_signUp_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_page.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool flag2 = false;
  Future<void> signinwithemail() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String email = emailController.text;
    String password = passwordController.text;
    try {
      final UserCredential usercredential =
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (usercredential.user.emailVerified) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Home(
                user: usercredential.user,
              );
            },
          ),
        );
      } else {
        try {
          await usercredential.user.sendEmailVerification();
          methods.buildalertDailog(
            " Verify the Email and then try again",
            context,
          );
        } catch (e) {
          methods.buildalertDailog(
              "Blocked Temorary Because of Too-many-request. Please try again after some time",
              context);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        methods.buildalertDailog(
          'No user found for that email',
          context,
        );
      } else if (e.code == 'wrong-password') {
        methods.buildalertDailog(
          "Wrong password provided for that user.",
          context,
        );
      } else if (e.code == 'network-request-failed') {
        methods.buildalertDailog(
          "Network connection Error.Please connect your device with internet",
          context,
        );
      }
    }
  }

  Container signInButton() {
    return Container(
      height: 40,
      width: 100,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            flag2 = true;
          });

          return signinwithemail();
        },
        child: Text(
          'Sign In',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Methods methods = Methods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('images/loginImage.jpg'),
                  radius: 60,
                ),
                methods.height(30),
                Text(
                  'ECOM APP',
                  style: TextStyle(
                    color: Colors.amber[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                methods.height(30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  width: 300,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      methods.buildTextField(
                        "email",
                        Icons.email,
                        false,
                        flag2,
                        emailController,
                      ),
                      methods.height(5),
                      methods.buildTextField(
                        "Password",
                        Icons.lock,
                        true,
                        flag2,
                        passwordController,
                      ),
                      methods.forgetPasswordButton(context),
                      signInButton(),
                      methods.buttonToCheckForAlreadyAccount(
                        context,
                        'No account? Register',
                        Register(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
