import 'package:authentication_through_email/Screen/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;
          Future(
            () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Error"),
                      content: Text('${error.toString()}'),
                    );
                  });
            },
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Register();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
