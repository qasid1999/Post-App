import 'dart:io';

import 'package:authentication_through_email/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../database.dart';
import 'package:path/path.dart' as path;

class CreatAndEditPage extends StatefulWidget {
  CreatAndEditPage({this.user, this.post});
  final User user;
  final Map post;
  @override
  _CreatAndEditPageState createState() => _CreatAndEditPageState();
}

class _CreatAndEditPageState extends State<CreatAndEditPage> {
  bool flag2 = false;
  String _title;
  String _discription;
  @override
  initState() {
    if (widget.post != null) {
      _title = widget.post["title"];
      _discription = widget.post["discription"];
      titleController..text = _title;
      discriptionController..text = _discription;
    }
    super.initState();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();

  buildtextField(TextEditingController controllers, hintText) {
    return TextField(
      controller: controllers,
      decoration: InputDecoration(
        errorText: controllers.text.isEmpty && flag2 ? "cannot be Empty" : null,
        fillColor: Colors.grey[200],
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black54,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }

  File _image;

  final pickimg = ImagePicker();
  Future pickimage() async {
    final imagefromgallery =
        await pickimg.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(imagefromgallery.path);
    });
  }

  submit(BuildContext context) async {
    if (titleController.text.isEmpty || discriptionController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (contex) {
            return AlertDialog(
              title: Text('Empty Fields'),
              content: Text('Title and Discription Field can not be Empty'),
            );
          });
    } else if (_image == null) {
      showDialog(
          context: context,
          builder: (contex) {
            return AlertDialog(
              title: Text('Image is Empty'),
              content: Text('Please Pick the Images'),
            );
          });
    } else {
      try {
        final imagepath = path.basename(_image.path);
        firebase_storage.FirebaseStorage storage =
            firebase_storage.FirebaseStorage.instance;
        firebase_storage.Reference ref = storage.ref(imagepath);
        await ref.putFile(_image);
        String downloadURL = await ref.getDownloadURL();
        String documentIDfromcurrentDate() => DateTime.now().toIso8601String();

        final String id = widget.post == null
            ? documentIDfromcurrentDate()
            : widget.post["id"];
        DataBase db = DataBase();
        db.creatPost(
          id,
          titleController.text,
          discriptionController.text,
          downloadURL,
          widget.user,
        );
      } catch (e) {
        showDialog(
            context: context,
            builder: (contex) {
              return AlertDialog(
                title: Text("${e.code}"),
                content: Text("${e.message}"),
              );
            });
      }
      titleController.clear();
      discriptionController.clear();
      _image = null;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            height: 400,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.deepPurpleAccent,
                      size: 50,
                    ),
                    onPressed: pickimage,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  buildtextField(titleController, "Enter Title"),
                  SizedBox(
                    height: 20,
                  ),
                  buildtextField(discriptionController, "Enter Discription"),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 40,
                        width: 100,
                        margin: EdgeInsets.only(
                          top: 30,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          onPressed: () => submit(context),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
