import 'package:authentication_through_email/Screen/reset_password_page.dart';
import 'package:flutter/material.dart';

class Methods {
  TextButton forgetPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PasswordReset();
            },
          ),
        );
      },
      child: Text(
        'Forget Password?',
        style: TextStyle(color: Colors.black87, fontSize: 15),
      ),
    );
  }

  TextButton buttonToCheckForAlreadyAccount(
      BuildContext context, String text, Widget route) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return route;
            },
          ),
        );
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.black, fontSize: 15),
      ),
    );
  }

  SizedBox height(double height) {
    return SizedBox(
      height: height,
    );
  }

  Future buildalertDailog(String error, BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(
            error,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Ok'),
            )
          ],
        );
      },
    );
  }

  Widget buildTextField(String hinttext, IconData icon, bool flag, bool flag2,
      TextEditingController controller) {
    return TextField(
      obscureText: flag,
      controller: controller,
      decoration: InputDecoration(
        errorText: controller.text.isEmpty && flag2
            ? "$hinttext field cannot be Empty"
            : null,
        filled: true,
        fillColor: Colors.grey[350],
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(25.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(25.0),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey[700],
          size: 30,
        ),
        hintText: hinttext,
        border: InputBorder.none,
      ),
    );
  }
}
