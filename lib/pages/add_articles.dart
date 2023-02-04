import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/pages/view_artcicle.dart';

import '../models/class_article.dart';

class Forms_Articles extends StatefulWidget {
  const Forms_Articles({Key? key}) : super(key: key);

  @override
  State<Forms_Articles> createState() => _Forms_ArticlesState();
}

class _Forms_ArticlesState extends State<Forms_Articles> {
  final _formKey = GlobalKey<FormState>();
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  late File image = File('');
  final String uid = (FirebaseAuth.instance.currentUser?.uid)!;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController1.dispose();
    myController2.dispose();
    myController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: MediaQuery.of(context).padding,
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  InkWell(
                    child: Stack(
                      children: [
                        Positioned(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                  color: Color(0xFFF1FF0A),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: FileImage(File(image.path)),
                                      fit: BoxFit.cover)),
                            )),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                            child: Center(
                              child: const Icon(Icons.camera_alt,
                                  color: Color(0xFFF1FF0A)),
                            ),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      pickImage(ImageSource.gallery);
                    },
                  ),
                  Container(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Image: ', style: TextStyle(color: Colors.white)),
                        Container(
                          height: 10,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          readOnly: true,
                          controller: myController1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: myController1.text,
                              prefixIcon: IconButton(
                                  onPressed: () {
                                    pickImage(ImageSource.gallery);
                                  },
                                  icon: const Icon(Icons.file_upload, color: Color(0xFFF1FF0A))),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                              )),
                        ),
                        Container(
                          height: 10,
                        ),
                        const Text('Titre: ', style: TextStyle(color: Colors.white)),
                        Container(
                          height: 10,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: myController2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.title, color: Color(0xFFF1FF0A)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                              )),
                        ),
                        Container(
                          height: 10,
                        ),
                        const Text('Contenu: ', style: TextStyle(color: Colors.white)),
                        Container(
                          height: 10,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: myController3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.description_outlined, color: Color(0xFFF1FF0A)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  InkWell(
                    child: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Color(0xFFF1FF0A),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        child: Center(
                          child: Text(
                            'Enregistrer',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        //ajouté à Firebase
                        addArticlesToFirebase(aaArticle(
                            '',
                            uid,
                            image.path,
                            myController2.text,
                            myController3.text,
                            DateFormat('dd-MM-yyyy H:m:s').format(DateTime.now()),
                            0));
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Articles()));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ajout de l\'image')),
                        );
                      }
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final _image = await ImagePicker().pickImage(source: source);
      if (_image == null) return;

      final imageTemporary = File(_image.path);
      setState(() {
        image = imageTemporary;
        print(image.path);
        myController1.text = image.path;
      });
    } on PlatformException catch (e) {
      print('Echec dans la sélection de limage: $e');
    }
  }

  Future addArticlesToFirebase(aaArticle article) async {
    final docArticle = FirebaseFirestore.instance.collection('articles').doc();
    final QuerySnapshot _docArticle =
        await FirebaseFirestore.instance.collection('articles').get();
    final ref = FirebaseStorage.instance
        .ref()
        .child('articleimages')
        .child('${article.titre}.jpg');
    await ref.putFile(image);
    article.id = docArticle.id;
    article.idd = _docArticle.docs.length;
    article.image = await ref.getDownloadURL();
    final json = article.toJson();
    await docArticle.set(json);
  }
}
