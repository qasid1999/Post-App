import 'package:authentication_through_email/Screen/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../methods_for_signIn_and_signUp_pages.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool flag2 = false;
  Methods methods = Methods();
  register() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore database = FirebaseFirestore.instance;
    String email = emailController.text;
    String password = passwordController.text;
    String username = usernameController.text;
    try {
      final UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      database.collection("users").doc(user.user.uid).set(
        {
          "email": email,
          "username": username,
        },
      );
      await user.user.sendEmailVerification();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SignInPage();
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        methods.buildalertDailog(
          "The Password Provided is too weak.",
          context,
        );
      } else if (e.code == 'email-already-in-use') {
        methods.buildalertDailog(
          "The email is already in used.",
          context,
        );
      }
    } catch (e) {
      methods.buildalertDailog(e.code.toString(), context);
    }
  }

  Container registerButton() {
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
          return register();
        },
        child: Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

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
                      fontSize: 25),
                ),
                methods.height(25),
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
                        "User Name",
                        Icons.person_pin,
                        false,
                        flag2,
                        usernameController,
                      ),
                      methods.height(5.0),
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
                      registerButton(),
                      methods.buttonToCheckForAlreadyAccount(
                        context,
                        'Already have account? Log in',
                        SignInPage(),
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
