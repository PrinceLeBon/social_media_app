import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/answer.dart';
import '../models/class_article.dart';
import '../widgets/answersCommentWidget.dart';

class AnswerComment extends StatefulWidget {
  final int idComment;
  final aaArticle article;

  const AnswerComment(
      {Key? key, required this.idComment, required this.article})
      : super(key: key);

  @override
  State<AnswerComment> createState() => _AnswerCommentState();
}

class _AnswerCommentState extends State<AnswerComment> {
  //final myController = TextEditingController();

  @override
  void dispose() {
    //myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Answers>>(
      stream: readAnswers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something has wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          final answer = snapshot.data!;
          if (answer.isEmpty) {
            return Container();
          } else {
            return ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: answer.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: AnswerCommentWidget(
                        userId: answer[index].id_user,
                        reponse: answer[index].reponse,
                        dateReponse: answer[index].date,
                        idComment: widget.idComment,
                        article: widget.article,
                        idAnswers: answer[index].id),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  );
                });
          }
        } else {
          return const Center(
            child:CircularProgressIndicator(color: Color(0xFFF1FF0A)),
          );
        }
      },
    ); /*Scaffold(
      appBar: AppBar(
        title: Text(
          'Réponses',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_sharp,
            )),
        elevation: 0,
      ),
      body: StreamBuilder<List<Answers>>(
        stream: readAnswers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something has wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final answer = snapshot.data!;
            if (answer.isEmpty) {
              return const Center(
                  child: Text(
                'Pas de réponses',
                style: TextStyle(color: Colors.white),
              ));
            } else {
              return ListView.builder(
                  itemCount: answer.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: AnswerCommentWidget(
                          userId: answer[index].id_user,
                          reponse: answer[index].reponse,
                          dateReponse: answer[index].date,
                          idComment: widget.idComment,
                          article: widget.article, idAnswers: answer[index].id),
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
          controller: myController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          style: TextStyle(fontSize: 13, color: Colors.white),
          decoration: InputDecoration(
              hintText: 'Ajouter une réponse',
              labelStyle: TextStyle(fontSize: 13, color: Colors.white),
              hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
              prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Profile_Picture(taille: 40, image: currentUser.photo)),
              suffixIcon: InkWell(
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Publier',
                      style: TextStyle(color: Color(0xFFF1FF0A), fontSize: 13),
                    )),
                onTap: () {
                  if (myController.text.isNotEmpty) {
                    _publish();
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
      ),
    );*/
  }

/*
  Future<void> _publish() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.article.id)
        .collection('commentaires')
        .doc(widget.idComment.toString())
        .collection('reponses')
        .get();
    int j = querySnapshot.docs.length;
    j++;
    final docReponse = FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.article.id)
        .collection('commentaires')
        .doc(widget.idComment.toString())
        .collection('reponses')
        .doc(j.toString());
    docReponse.set(Answers(j, currentUser.id, myController.text.trim(),
            DateFormat('dd-MM-yyyy H:m:s').format(DateTime.now()))
        .toJson());
    setState(() {
      myController.text = '';
    });
  }*/

  Stream<List<Answers>> readAnswers() => FirebaseFirestore.instance
      .collection('articles')
      .doc(widget.article.id)
      .collection('commentaires')
      .doc(widget.idComment.toString())
      .collection('reponses')
      .orderBy("id", descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Answers.fromJson(doc.data())).toList());
}
