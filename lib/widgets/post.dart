import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/widgets/profile_picture.dart';
import '../models/bookmark.dart';
import '../models/class_article.dart';
import '../models/globals.dart';
import '../models/like.dart';
import '../pages/commentaires.dart';

class Posts extends StatefulWidget {
  final aaArticle article;

  const Posts({Key? key, required this.article}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  bool? likePublication = false;
  bool? addToBookmark = false;
  late String username = '';
  late String photo = '';

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
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[800], borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFF1FF0A)),
                          child: Profile_Picture(taille: 40, image: photo),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                            Container(
                              height: 5,
                            ),
                            Text(
                              duree(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13),
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey[700], shape: BoxShape.circle),
                      child: const Icon(
                        Icons.keyboard_control_sharp,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 10,
              ),
              InkWell(
                onDoubleTap: () {
                  setState(() {
                    bool? value = likePublication;
                    likePublication = !value!;
                    _likePublication(widget.article.id, currentUser.id, value);
                  });
                },
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300],
                      image: DecorationImage(
                        image: NetworkImage(widget.article.image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      StreamBuilder(
                        stream: hasAlreadyLiked(widget.article.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            likePublication = snapshot.data?.exists;
                            return InkWell(
                              child: (likePublication == true)
                                  ? const Icon(Icons.favorite,
                                      color: Colors.red)
                                  : const Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                    ),
                              onTap: () {
                                setState(() {
                                  bool? value = likePublication;
                                  likePublication = !value!;
                                  _likePublication(
                                      widget.article.id, currentUser.id, value);
                                });
                              },
                            );
                          }
                          return InkWell(
                            child: const Icon(Icons.favorite_border,
                                color: Colors.grey),
                            onTap: () {
                              setState(() {
                                bool? value = likePublication;
                                likePublication = !value!;
                                _likePublication(
                                    widget.article.id, currentUser.id, value);
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        child: const Icon(Icons.mode_comment_outlined,
                            color: Colors.white),
                        onTap: () {
                          comment();
                        },
                      )
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        _addToBookmark(
                            widget.article.id, currentUser.id, addToBookmark!);
                      },
                      splashColor: Colors.transparent,
                      icon: StreamBuilder(
                        stream: hasAlreadyAddToBookmarks(widget.article.id),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            addToBookmark = snapshot.data?.exists;
                            return Icon(
                                (addToBookmark == true)
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: Colors.white);
                          }
                          return const Icon(Icons.bookmark_border,
                              color: Colors.white);
                        },
                      )),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder(
                      stream: hasLikeLenght(widget.article.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final int? lenghtOfLikeCollection =
                              snapshot.data?.docs.length;
                          return (lenghtOfLikeCollection! >= 1)
                              ? Row(
                                  children: [
                                    const Text(
                                      'Aimé par ',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.white),
                                    ),
                                    Text('$lenghtOfLikeCollection personnes',
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.white))
                                  ],
                                )
                              : Container();
                        } else {
                          return const Text(
                            '*',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.white),
                          );
                        }
                      }),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: RichText(
                      text: TextSpan(
                          style: const TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                                text: '${widget.article.titre} ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            TextSpan(
                                text: widget.article.description,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white))
                          ]),
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  InkWell(
                    child: Row(
                      children: [
                        const Text(
                          'Voir les ',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        StreamBuilder(
                            stream: hasCommentsLenght(widget.article.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final int? lenghtOfCommentsCollections =
                                    snapshot.data?.docs.length;
                                return Text('$lenghtOfCommentsCollections',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 13));
                              }
                              return const Text('*',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13));
                            }),
                        const Text(
                          ' commentaires',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        )
                      ],
                    ),
                    onTap: () {
                      comment();
                    },
                  ),
                ],
              ),
              Container(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  void comment() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Commentaire(article: widget.article)));
  }

  //quand on utilise future, l'icone prends du temps avant de changer d'état. La solution que j'ai trouvé pour
  // pouvoir faire les modifications simplement et eviter les conflits si on a plusieurs utilisateurs c'est de supprimer
  //le champ nb_like de article et d'utiliser simplement la longueur de la liste de la collections like
  //Ainsi pour les opérations d'ajout et de retrait de like, on a qu'a supprimé ou ajouter un document au lieu de faire
  //des opérations sur deux collections différentes
  Future<void> _likePublication(
      String articleId, String userId, bool liked) async {
    //listperso.clear();
    //getList();
    final docArticleLikes = FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('likes')
        .doc(userId);
    if (liked) {
      docArticleLikes.delete();
    } else {
      docArticleLikes.set(Like(userId, userId, articleId).toJson());
    }
  }

  Future<void> _addToBookmark(
      String articleId, String userId, bool added) async {
    final docBookMark = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .doc(articleId);
    if (added) {
      docBookMark.delete();
    } else {
      docBookMark.set(Bookmark(articleId, userId, articleId).toJson());
    }
  }

  Stream<DocumentSnapshot> hasAlreadyLiked(String id) {
    return FirebaseFirestore.instance
        .collection('articles')
        .doc(id)
        .collection('likes')
        .doc(currentUser.id)
        .snapshots();
  }

  Stream<DocumentSnapshot> hasAlreadyAddToBookmarks(String id) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id)
        .collection('bookmarks')
        .doc(id)
        .snapshots();
  }

  Stream<QuerySnapshot> hasLikeLenght(String id) {
    return FirebaseFirestore.instance
        .collection('articles')
        .doc(id)
        .collection('likes')
        .snapshots();
  }

  Stream<QuerySnapshot> hasCommentsLenght(String id) {
    return FirebaseFirestore.instance
        .collection('articles')
        .doc(id)
        .collection('commentaires')
        .snapshots();
  }

  Future<void> getUsernameAndProfilePicture() async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection("users");
    QuerySnapshot querySnapshot = await userCollection
        .where("id", isEqualTo: widget.article.id_user)
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

  String duree() {
    if ((DateTime.now()
            .difference(
                DateFormat('dd-MM-yyyy H:m:s').parse(widget.article.date))
            .inSeconds) <=
        60) {
      return '${DateTime.now().difference(DateFormat('dd-MM-yyyy H:m:s').parse(widget.article.date)).inSeconds}s';
    } else if ((DateTime.now()
            .difference(
                DateFormat('dd-MM-yyyy H:m:s').parse(widget.article.date))
            .inMinutes) <=
        60) {
      return '${DateTime.now().difference(DateFormat('dd-MM-yyyy H:m:s').parse(widget.article.date)).inMinutes}mn';
    }
    if ((DateTime.now()
            .difference(
                DateFormat('dd-MM-yyyy H:m:s').parse(widget.article.date))
            .inHours) <=
        24) {
      return '${DateTime.now().difference(DateFormat('dd-MM-yyyy H:m:s').parse(widget.article.date)).inHours}h';
    } else {
      return '${DateTime.now().difference(DateFormat('dd-MM-yyyy H:m:s').parse(widget.article.date)).inDays}j';
    }
  }

  Future<void> getList() async {
    CollectionReference articleCollection =
        FirebaseFirestore.instance.collection("articles");
    QuerySnapshot querySnapshot = await articleCollection
        .where("id_user", isEqualTo: currentUser.id)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      // print('liste trouvé');
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> userFound = doc.data() as Map<String, dynamic>;
        setState(() {
          listperso.add(aaArticle.fromJson(userFound));
        });
      }
    } else {
      print('liste11 non trouvé');
    }
  }

/*
  Future<void> _likePublication(String articleId, String userId, bool liked) async {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot articleSnapshot = await transaction.get(
          FirebaseFirestore.instance.collection('articles').doc(articleId));

      if (!articleSnapshot.exists) {
        throw 'Article not found';
      }

      //on récupérer le document ou on avait sauvegardé le like
      DocumentSnapshot likeSnapshot = await transaction
          .get(articleSnapshot.reference.collection('likes').doc(userId));

      //on récupère le nombre de like actuel
      Map<String, dynamic> articleFound =
          articleSnapshot.data() as Map<String, dynamic>;
      int nb_like = articleFound['nb_like'];

      if (likeSnapshot.exists) {
        // Si le document existe l'utilisateur avait déjà liké l'article, donc on dislike et on supprime le document
        nb_like--;
        transaction.delete(likeSnapshot.reference);
      } else {
        // Si le document n'existe pas l'utilisateur n'avait pas liké l'article, donc on like et on ajoute le document
        nb_like++;
        transaction.set(
            articleSnapshot.reference.collection('likes').doc(userId),
            Like(userId, userId, articleId).toJson());
      }

      transaction.update(articleSnapshot.reference, {'nb_like': nb_like});
    });
  }*/

}
