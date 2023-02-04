import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/answer.dart';
import '../models/class_article.dart';
import '../models/comments.dart';
import '../models/globals.dart';
import '../widgets/comment.dart';
import '../widgets/profile_picture.dart';

class Commentaire extends StatefulWidget {
  final aaArticle article;

  const Commentaire({Key? key, required this.article}) : super(key: key);

  @override
  State<Commentaire> createState() => _CommentaireState();
}

class _CommentaireState extends State<Commentaire> {
  final myController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Commentaires',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  keyboard = 1;
                });
              },
              icon: const Icon(
                Icons.arrow_back_sharp,
              )),
          elevation: 0,
        ),
        body: StreamBuilder<List<Comments>>(
          stream: readComments(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something has wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final comment = snapshot.data!;
              if (comment.isEmpty) {
                return const Center(
                    child: Text(
                  'Pas de commentaires',
                  style: TextStyle(color: Colors.white),
                ));
              } else {
                return ListView.builder(
                    itemCount: comment.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        child: Comment(
                          userId: comment[index].id_user,
                          comment: comment[index].commentaire,
                          dateComment: comment[index].date,
                          idComment: comment[index].id,
                          article: widget.article,
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      );
                    });
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFF1FF0A)),
              );
            }
          },
        ),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: TextFormField(
            focusNode: focusNode,
            controller: myController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            style: TextStyle(fontSize: 13, color: Colors.white),
            decoration: InputDecoration(
                hintText: 'Ajouter un commentaire',
                labelStyle: TextStyle(fontSize: 13, color: Colors.white),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child:
                        Profile_Picture(taille: 40, image: currentUser.photo)),
                suffixIcon: (keyboard == 1)
                    ? InkWell(
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Publier',
                              style: TextStyle(
                                  color: Color(0xFFF1FF0A), fontSize: 13),
                            )),
                        onTap: () {
                          if (myController.text.isNotEmpty) {
                            _publish();
                          }
                        },
                      )
                    : InkWell(
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Répondre',
                              style: TextStyle(
                                  color: Color(0xFFF1FF0A), fontSize: 13),
                            )),
                        onTap: () {
                          if (myController.text.isNotEmpty) {
                            _answer();
                          }
                        },
                      ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                )),
          ),
        ));
  }

  Future<void> _publish() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.article.id)
        .collection('commentaires')
        .get();
    int j = querySnapshot.docs.length;
    j++;
    final docComments = FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.article.id)
        .collection('commentaires')
        .doc(j.toString());

    docComments.set(Comments(j, currentUser.id, myController.text.trim(),
            DateFormat('dd-MM-yyyy H:m:s').format(DateTime.now()))
        .toJson());
    setState(() {
      myController.text = '';
    });
  }

  Future<void> _answer() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.article.id)
        .collection('commentaires')
        .doc(globalComment.id.toString())
        .collection('reponses')
        .get();
    int j = querySnapshot.docs.length;
    j++;
    final docReponse = FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.article.id)
        .collection('commentaires')
        .doc(globalComment.id.toString())
        .collection('reponses')
        .doc(j.toString());
    docReponse.set(Answers(j, currentUser.id, myController.text.trim(),
            DateFormat('dd-MM-yyyy H:m:s').format(DateTime.now()))
        .toJson());
    setState(() {
      myController.text = '';
      keyboard = 1;
      focusNode = FocusNode();
    });
  }

  Stream<List<Comments>> readComments() => FirebaseFirestore.instance
      .collection('articles')
      .doc(widget.article.id)
      .collection('commentaires')
      .orderBy("id", descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Comments.fromJson(doc.data())).toList());
}
