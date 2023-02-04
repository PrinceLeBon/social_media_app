import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/class_article.dart';
import '../models/globals.dart';
import '../widgets/post.dart';
import '../widgets/profile_picture.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Color unselectedTextColor = Colors.white;
  Color unselectedButtonColor = Colors.black;
  Color selectedTextColor = Colors.black;
  Color selectedButtonColor = Color(0xFFF1FF0A);
  int page = 1;
  int longueur = listperso.length;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Container(
          margin: MediaQuery.of(context).padding,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                expandedHeight: 400,
                leading: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[800], shape: BoxShape.circle),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_sharp,
                      color: Colors.white,
                    ),
                  ) ,
                ),
                actions: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.grey[800], shape: BoxShape.circle),
                    child: Icon(
                      Icons.keyboard_control_sharp,
                      color: Colors.white,
                    ),
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: EdgeInsets.only(top: 90),
                    child: Center(
                      child: Column(
                        children: [
                          Profile_Picture(
                              taille: 100, image: currentUser.photo),
                          Container(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentUser.nom + ' ' + currentUser.prenom,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: 5,
                              ),
                              Icon(
                                Icons.check_circle,
                                color: Color(0xFFF1FF0A),
                                size: 17,
                              )
                            ],
                          ),
                          Container(
                            height: 5,
                          ),
                          Text(
                            '@' + currentUser.username,
                            style: TextStyle(color: Colors.white),
                          ),
                          Container(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.mail, color: Color(0xFFF1FF0A),),
                              Container(width: 5,),
                              Text(
                                currentUser.email,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Container(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_month, color: Color(0xFFF1FF0A),),
                              Container(width: 5,),
                              Text(
                                currentUser.date_de_naissance,
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          Container(
                            height: 30,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width,
                              height: 75,
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(longueur.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        Container(
                                          height: 5,
                                        ),
                                        Text('Posts',
                                            style:
                                                TextStyle(color: Colors.white))
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('1 436',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        Container(
                                          height: 5,
                                        ),
                                        Text("J'aime",
                                            style:
                                                TextStyle(color: Colors.white))
                                      ],
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  leadingWidth: 0,
                  leading: Container(),
                  title: Row(
                    children: [
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(10)),
                            width: 100,
                            height: 50,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: (page==1) ? selectedButtonColor : unselectedButtonColor,
                                    borderRadius: BorderRadius.circular(10)),
                                width: 100,
                                height: 50,
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Posts',
                                        style: TextStyle(
                                            color: (page==1) ? selectedTextColor : unselectedTextColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Container(
                                      width: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[900],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          longueur.toString(),
                                          style: TextStyle(
                                              color: Color(0xFFF1FF0A),
                                              fontSize: 12),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                              ),
                            )),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(10)),
                          width: 100,
                          height: 50,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: (page == 1) ? unselectedButtonColor : selectedButtonColor,
                                  borderRadius: BorderRadius.circular(10)),
                              width: 100,
                              height: 50,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("J'aime",
                                        style: TextStyle(
                                            color: (page == 1) ? unselectedTextColor : selectedTextColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Container(
                                      width: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[900],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          '1 436',
                                          style: TextStyle(
                                              color: Color(0xFFF1FF0A),
                                              fontSize: 12),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
              (page == 1)
                  ? SliverToBoxAdapter(
                child: SliverAnimatedList(
                  itemBuilder: (_, index, ___) {
                    return Posts(article: listperso[index])
                    ;
                  },
                  initialItemCount: longueur,
                ),
              )
                  : SliverAnimatedList(
                itemBuilder: (_, index, ___) {
                  return Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(width: 10, height: 10, color: Colors.red,)
                  );
                },
                initialItemCount: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<List<DocumentSnapshot>> getLikedArticles(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('articles')
        .where('likes', arrayContains: currentUser.id)
        .get();
    return querySnapshot.docs;
  }
  }

