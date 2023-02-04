import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/pages/profile.dart';
import '../models/class_article.dart';
import '../models/globals.dart';
import '../models/user.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/post.dart';
import '../widgets/profile_picture.dart';
import 'add_articles.dart';

class Articles extends StatefulWidget {
  const Articles({Key? key}) : super(key: key);

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  final List<aaArticle> _listArticle =
      listArticle; //List.from(listArticle.reversed);
  String photo = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfilePicture();
    // getList();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    getProfilePicture();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Media App',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.tv, color: Color(0xFFF1FF0A))),
        actions: [
          Stack(
            children: [
              Positioned(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const Profile()));
                    },
                    child: Profile_Picture(
                        taille: 45, image: currentUser.photo),
                  )),
              Positioned(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFF1FF0A)),
                ), /*top: 0, right: 0,*/
              )
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Forms_Articles()));
              //    print('jsbhvkjwdbfvjhbfvdkjfv ${listperso.length}');

              /*FirebaseAuth.instance.signOut();
    Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => Login()));*/
            },
            icon: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                    color: Color(0xFFF1FF0A), shape: BoxShape.circle),
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                )),
          )
        ],
      ),
      drawer: const CustomDrawer(),
      body: _stream(),
    );
  }

  Widget _stream() {
    return StreamBuilder<List<aaArticle>>(
      stream: readArticle(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something has wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          listArticle = snapshot.data!;
          return ListView.builder(
              itemCount: listArticle.length, //article.length
              itemBuilder: (context, index) {
                return ViewArticleFirebase(listArticle[index]);
              });
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFF1FF0A)),
          );
        }
      },
    );
  }

  // Afficher avec Firebase
  Widget ViewArticleFirebase(aaArticle article) {
    return (article.image.isNotEmpty)
        ? Container(
        child: Posts(
          article: article,
        ))
        : Container();
  }

  //afficher avec stream
  Stream<List<aaArticle>> readArticle() =>
      FirebaseFirestore.instance
          .collection('articles')
          .orderBy("idd", descending: true)
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => aaArticle.fromJson(doc.data())).toList());

  Future<void> getProfilePicture() async {
    final String userId = (FirebaseAuth.instance.currentUser?.uid)!;
    CollectionReference userCollection =
    FirebaseFirestore.instance.collection("users");
    QuerySnapshot querySnapshot =
    await userCollection.where("id", isEqualTo: userId).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      print('username trouvé');
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> userFound = doc.data() as Map<String, dynamic>;
        setState(() {
          currentUser = Users(
              userFound['id'],
              userFound['nom'],
              userFound['prenom'],
              userFound['photo'],
              userFound['date_de_naissance'],
              userFound['username'],
              userFound['email']);
        });
      }
    } else {
      print('username non trouvé');
    }

/*
    Widget _future() {
      return FutureBuilder<List<aaArticle>>(
        future: readArticle1(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something has wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final article = snapshot.data!;
            return ListView.builder(
                itemCount: article.length,
                itemBuilder: (context, index) {
                  return ViewArticleFirebase(article[index]);
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }

    //afficher avec future
    Future<List<aaArticle>> readArticle1() =>
        FirebaseFirestore.instance
            .collection('articles')
            .orderBy("idd", descending: true)
            .get()
            .then((snapshot) =>
            snapshot.docs.map((doc) => aaArticle.fromJson(doc.data())).toList());

    */
  }

  Future<void> getList() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("articles")
        .where("id_user", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      print('liste11 trouvé');
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

  Future<void> getSignet() async {
    CollectionReference signetCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.id)
        .collection("bookmarks");
    QuerySnapshot querySnapshot = await signetCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      // print('liste trouvé');
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> userFound = doc.data() as Map<String, dynamic>;
        setState(() {
          listSignet.add(aaArticle.fromJson(userFound));
        });
      }
    } else {
      print('liste11 non trouvé');
    }
  }
}
