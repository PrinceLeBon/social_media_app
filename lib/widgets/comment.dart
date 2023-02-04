import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/widgets/profile_picture.dart';
import '../models/answer.dart';
import '../models/class_article.dart';
import '../models/comments.dart';
import '../models/globals.dart';
import '../models/like.dart';
import '../pages/answerComment.dart';

class Comment extends StatefulWidget {
  final String userId;
  final String comment;
  final String dateComment;
  final int idComment;
  final aaArticle article;

  const Comment(
      {Key? key,
      required this.userId,
      required this.comment,
      required this.dateComment,
      required this.idComment,
      required this.article})
      : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  String username = '';
  String photo = '';
  bool? likeComment = false;
  bool showComment = false;
  late int? lenghtOfAnswersCollection = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsernameAndProfilePicture();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getUsernameAndProfilePicture();
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 8, left: 8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFF1FF0A)),
                            child: Profile_Picture(taille: 40, image: photo),
                          ),
                          Container(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    username,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.white),
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  Text(
                                    duree(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ],
                              ),
                              Container(
                                height: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.4,
                                child: Text(
                                  widget.comment,
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ),
                              Container(
                                height: 5,
                              ),
                              InkWell(
                                child: const Text(
                                  "Répondre...",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                                onTap: () {
                                  setState(() {
                                    keyboard = 2;
                                    globalComment = Comments(
                                        widget.idComment,
                                        widget.userId,
                                        widget.comment,
                                        widget.dateComment);
                                    print(keyboard.toString());
                                    print(widget.idComment.toString());
                                    print(widget.userId);
                                    print(widget.comment);
                                    print(widget.dateComment);
                                  });
                                  /*Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AnswerComment(
                                          idComment: widget.idComment,
                                          article: widget.article)));*/
                                },
                              ),
                              Container(
                                height: 5,
                              ),
                              (lenghtOfAnswersCollection! > 0) ? InkWell(
                                child: InkWell(
                                  child: Text(
                                    "Voir les $lenghtOfAnswersCollection commentaires",
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  ),
                                  onTap: (){
                                    bool value = showComment;
                                    showComment = !value;
                                  },
                                ),
                                onTap: () {
                                  setState(() {
                                    keyboard = 2;
                                    globalComment = Comments(
                                        widget.idComment,
                                        widget.userId,
                                        widget.comment,
                                        widget.dateComment);
                                  });
                                  /*Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AnswerComment(
                                          idComment: widget.idComment,
                                          article: widget.article)));*/
                                },
                              ): Container(),

                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          StreamBuilder(
                            stream: hasAlreadyLiked(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                likeComment = snapshot.data?.exists;
                                return InkWell(
                                  child: (likeComment == true)
                                      ? const Icon(Icons.favorite,
                                          color: Colors.red, size: 17)
                                      : const Icon(Icons.favorite_border,
                                          color: Colors.grey, size: 17),
                                  onTap: () {
                                    setState(() {
                                      bool? value = likeComment;
                                      likeComment = !value!;
                                      _likeComments(value);
                                    });
                                  },
                                );
                              }
                              return InkWell(
                                child: const Icon(Icons.favorite_border,
                                    color: Colors.grey, size: 17),
                                onTap: () {
                                  setState(() {
                                    bool? value = likeComment;
                                    likeComment = !value!;
                                    _likeComments(value);
                                  });
                                },
                              );
                            },
                          ),
                          StreamBuilder(
                              stream: hasLikeLenght(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final int? lenghtOfLikeCollection =
                                      snapshot.data?.docs.length;
                                  return Text('$lenghtOfLikeCollection',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ));
                                } else {
                                  return const Text('0',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ));
                                }
                              }),
                          Container(
                            height: 5,
                          ),
                          InkWell(
                            child: const Icon(
                              Icons.mode_comment_outlined,
                              color: Colors.grey,
                              size: 17,
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AnswerComment(
                                      idComment: widget.idComment,
                                      article: widget.article)));
                            },
                          ),
                          StreamBuilder(
                              stream: hasCommentsLenght(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  lenghtOfAnswersCollection =
                                      snapshot.data?.docs.length;
                                  return Text('$lenghtOfAnswersCollection',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ));
                                } else {
                                  return const Text('0',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ));
                                }
                              })
                        ],
                      )
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          (showComment == true) ? AnswerComment(idComment: widget.idComment, article: widget.article) : Container()
        ],
      ),
    );
  }

  Future<void> getUsernameAndProfilePicture() async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection("users");
    QuerySnapshot querySnapshot = await userCollection
        .where("id", isEqualTo: widget.userId)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> userFound = doc.data() as Map<String, dynamic>;
        setState(() {
          username = userFound['username'];
          photo = userFound['photo'];
        });
      }
    } else {
      print('username non trouvé');
    }
  }

  Future<void> _likeComments(bool liked) async {
    final docLikes = FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.article.id)
        .collection('commentaires')
        .doc(widget.idComment.toString())
        .collection('likes')
        .doc(currentUser.id);
    if (liked) {
      docLikes.delete();
    } else {
      docLikes.set(
          Like(currentUser.id, currentUser.id, widget.idComment.toString())
              .toJson());
    }
  }

  Stream<DocumentSnapshot> hasAlreadyLiked() {
    return FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.article.id)
        .collection('commentaires')
        .doc(widget.idComment.toString())
        .collection('likes')
        .doc(currentUser.id)
        .snapshots();
  }

  Stream<QuerySnapshot> hasLikeLenght() {
    return FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.article.id)
        .collection("commentaires")
        .doc(widget.idComment.toString())
        .collection('likes')
        .snapshots();
  }

  Stream<QuerySnapshot> hasCommentsLenght() {
    return FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.article.id)
        .collection("commentaires")
        .doc(widget.idComment.toString())
        .collection('reponses')
        .snapshots();
  }

  String duree() {
    if ((DateTime.now()
            .difference(
                DateFormat('dd-MM-yyyy H:m:s').parse(widget.dateComment))
            .inSeconds) <=
        60) {
      return '${DateTime.now().difference(DateFormat('dd-MM-yyyy H:m:s').parse(widget.dateComment)).inSeconds}s';
    } else if ((DateTime.now()
            .difference(
                DateFormat('dd-MM-yyyy H:m:s').parse(widget.dateComment))
            .inMinutes) <=
        60) {
      return '${DateTime.now().difference(DateFormat('dd-MM-yyyy H:m:s').parse(widget.dateComment)).inMinutes}mn';
    }
    if ((DateTime.now()
            .difference(
                DateFormat('dd-MM-yyyy H:m:s').parse(widget.dateComment))
            .inHours)<=
        24) {
      return '${DateTime.now().difference(DateFormat('dd-MM-yyyy H:m:s').parse(widget.dateComment)).inHours}h';
    } else {
      return '${DateTime.now().difference(DateFormat('dd-MM-yyyy H:m:s').parse(widget.dateComment)).inDays}j';
    }
  }

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

  void showKeyboard() {
    focusNode.requestFocus();
  }
}
