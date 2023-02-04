import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/widgets/profile_picture.dart';
import '../models/class_article.dart';
import '../models/globals.dart';
import '../models/like.dart';

class AnswerCommentWidget extends StatefulWidget {
  final String userId;
  final String reponse;
  final String dateReponse;
  final int idComment;
  final int idAnswers;
  final aaArticle article;

  const AnswerCommentWidget(
      {Key? key,
      required this.userId,
      required this.reponse,
      required this.dateReponse,
      required this.idComment,
      required this.article,
      required this.idAnswers})
      : super(key: key);

  @override
  State<AnswerCommentWidget> createState() => _AnswerCommentWidgetState();
}

class _AnswerCommentWidgetState extends State<AnswerCommentWidget> {
  String username = '';
  String photo = '';
  bool? likeAnswers = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsernameAndProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    getUsernameAndProfilePicture();

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 40),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[800], borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                            shape: BoxShape.circle, color: Color(0xFFF1FF0A)),
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
                          Container(
                            width: MediaQuery.of(context).size.width / 1.6,
                            child: Text(
                              widget.reponse,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  /*Column(
                    children: [
                      StreamBuilder(
                        stream: hasAlreadyLiked(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            likeAnswers = snapshot.data?.exists;
                            return InkWell(
                              child: (likeAnswers == true)
                                  ? const Icon(Icons.favorite,
                                      color: Colors.red, size: 17)
                                  : const Icon(Icons.favorite_border,
                                      color: Colors.grey, size: 17),
                              onTap: () {
                                setState(() {
                                  bool? value = likeAnswers;
                                  likeAnswers = !value!;
                                  _likeAnswers(value);
                                });
                              },
                            );
                          }
                          return InkWell(
                            child: const Icon(Icons.favorite_border,
                                color: Colors.grey, size: 17),
                            onTap: () {
                              setState(() {
                                bool? value = likeAnswers;
                                likeAnswers = !value!;
                                _likeAnswers(value);
                              });
                            },
                          );
                        },
                      ),
                      Container(
                        height: 5,
                      ),
                      StreamBuilder(
                          stream: hasLikeLenght(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final int? lenghtOfLikeCollection =
                                  snapshot.data?.docs.length;
                              return Text('$lenghtOfLikeCollection',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ));
                            } else {
                              return Text('0',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ));
                            }
                          })
                    ],
                  )*/
                ],
              ),
              Container(
                height: 10,
              ),
            ],
          ),
        ),
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

  Future<void> _likeAnswers(bool liked) async {
    final docLikes = FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.article.id)
        .collection('commentaires')
        .doc(widget.idComment.toString())
        .collection('reponses')
        .doc(widget.idAnswers.toString())
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
        .collection('reponses')
        .doc(widget.idAnswers.toString())
        .collection('likes')
        .doc(currentUser.id)
        .snapshots();
  }

  Stream<QuerySnapshot> hasLikeLenght() {
    return FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.article.id)
        .collection('commentaires')
        .doc(widget.idComment.toString())
        .collection('reponses')
        .doc(widget.idAnswers.toString())
        .collection('likes')
        .snapshots();
  }

  String duree() {
    if ((DateTime.now()
            .difference(
                DateFormat('dd-MM-yyyy H:m:s').parse(widget.dateReponse))
            .inSeconds) <=
        60) {
      return '${DateTime.now().difference(DateFormat('dd-MM-yyyy H:m:s').parse(widget.dateReponse)).inSeconds}s';
    } else if ((DateTime.now()
            .difference(
                DateFormat('dd-MM-yyyy H:m:s').parse(widget.dateReponse))
            .inMinutes) <=
        60) {
      return '${DateTime.now().difference(DateFormat('dd-MM-yyyy H:m:s').parse(widget.dateReponse)).inMinutes}mn';
    }
    if ((DateTime.now()
            .difference(
                DateFormat('dd-MM-yyyy H:m:s').parse(widget.dateReponse))
            .inHours) <=
        24) {
      return '${DateTime.now().difference(DateFormat('dd-MM-yyyy H:m:s').parse(widget.dateReponse)).inHours}h';
    } else {
      return '${DateTime.now().difference(DateFormat('dd-MM-yyyy H:m:s').parse(widget.dateReponse)).inDays}j';
    }
  }
}
