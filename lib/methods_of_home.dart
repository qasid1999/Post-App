import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MethodsOfHomePage {
  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.purple[300],
      title: Text(
        "Welcome to the Post App",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      centerTitle: true,
    );
  }

  signout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      print("sign Out Successfully");
      Navigator.pop(context);
    } catch (e) {
      print("error");
    }
  }

  String email;
  String username;
  getData(User user) async {
    try {
      final FirebaseFirestore database = FirebaseFirestore.instance;
      final snapshot = await database.collection("users").doc(user.uid).get();
      final myData = snapshot.data();
      username = myData['username'];
      email = myData['email'];
    } catch (e) {
      print(e.toString());
    }
  }

  Drawer buildmenuBar(BuildContext context, User user) {
    return Drawer(
      elevation: 50,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(
                    "images/loginImage.jpg",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: getData(user),
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
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              return Navigator.pop(context);
            },
            leading: Icon(Icons.home),
            title: Text('Home'),
          ),
          ListTile(
            onTap: () {
              signout(context);
              Navigator.pop(context);
            },
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
