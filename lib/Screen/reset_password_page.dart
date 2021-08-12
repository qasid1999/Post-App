import 'package:authentication_through_email/methods_for_signIn_and_signUp_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  Methods methods = Methods();
  bool flag2 = false;
  Container resetPasswordButton() {
    return Container(
      height: 40,
      width: 150,
      margin: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            flag2 = true;
          });
          return resetPassword();
        },
        child: Text(
          'Reset Password',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> resetPassword() async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email has been send successfully '),
        ),
      );
    } catch (e) {
      methods.buildalertDailog(
        e.code,
        context,
      );
    }
  }

  TextEditingController emailController = TextEditingController();
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
                      resetPasswordButton()
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
