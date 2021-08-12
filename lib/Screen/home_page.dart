import 'package:authentication_through_email/Screen/create_and_edit_page.dart';
import 'package:authentication_through_email/methods_of_home.dart';
import 'package:authentication_through_email/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({this.user});
  final User user;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MethodsOfHomePage methods = MethodsOfHomePage();
  Stream<QuerySnapshot> readPost() {
    final postPath = "users/${widget.user.uid}/Posts";
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final referenc = db.collection(postPath).snapshots();
    return referenc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CreatAndEditPage(
              user: widget.user,
              post: null,
            );
          }));
        },
        child: Icon(
          Icons.add,
          color: Colors.orange,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text(
          "Welcome to the Post App",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      drawer: methods.buildmenuBar(context, widget.user),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: _buildStreamBuilder(),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object>> _buildStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream: readPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final documents = snapshot.data.docs;

          if (documents.isNotEmpty) {
            final chldrn = documents.map(
              (doc) {
                Map data = doc.data();

                String id = doc.id;
                data['id'] = id;
                return Post(
                  user: widget.user,
                  data: data,
                );
              },
            ).toList();
            return GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 250,
                crossAxisSpacing: 3,
                mainAxisSpacing: 15,
              ),
              children: chldrn,
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No Post",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Click on the bellow + button to create a Post",
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          print("error");
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
