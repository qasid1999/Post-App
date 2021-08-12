import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBase {
  creatPost(
      String docid, String title, String discription, String url, User user) {
    final postPath = "users/${user.uid}/Posts/$docid";
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.doc(postPath).set(
      {
        "title": title,
        "discription": discription,
        "url": url,
      },
    );
  }

  Stream<QuerySnapshot> readPost(User user) {
    final postPath = "users/${user.uid}/Posts";
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final referenc = db.collection(postPath).snapshots();
    return referenc;
  }
}
