import 'package:authentication_through_email/Screen/create_and_edit_page.dart';
import 'package:authentication_through_email/Screen/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  final Map data;
  final User user;
  Post({this.data, this.user});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(alignment: AlignmentDirectional.topStart, children: [
              Image.network(
                data["url"],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              popUpButton(context)
            ]),
            SizedBox(
              height: 30,
            ),
            Text(
              data["title"],
              style: TextStyle(
                color: Colors.purple,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              data["discription"],
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton popUpButton(BuildContext context) {
    return PopupMenuButton(
      elevation: 30,
      color: Colors.white,
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey,
        size: 35,
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CreatAndEditPage(
                        user: user,
                        post: data,
                      );
                    },
                  ),
                );
              },
              leading: Text(
                "Edit",
                style: TextStyle(color: Colors.black45),
              ),
              trailing: Icon(Icons.edit),
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                return deletePost();
              },
              leading: Text(
                "Delete",
                style: TextStyle(color: Colors.black45),
              ),
              trailing: Icon(Icons.delete),
            ),
          ),
        ];
      },
    );
  }

  deletePost() async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    String postId = data["id"];
    print(postId);
    String path = "users/${user.uid}/Posts/$postId";
    final doc = instance.doc(path);
    await doc.delete();
  }
}
