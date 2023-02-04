import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/widgets/profile_picture.dart';
import '../models/globals.dart';
import '../pages/login.dart';
import '../pages/profile.dart';
import '../models/class_article.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Container(
        margin: MediaQuery.of(context).padding,
        child: Padding(
          padding: const EdgeInsets.only(right: 30, left: 20, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child:
                        Profile_Picture(taille: 50, image: currentUser.photo),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Profile()));
                    },
                  ),
                  const Icon(Icons.blur_circular, color: Color(0xFFF1FF0A))
                ],
              ),
              Container(
                height: 20,
              ),
              Text(
                currentUser.nom + ' ' + currentUser.prenom,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
              Container(
                height: 5,
              ),
              Text(
                '@' + currentUser.username,
                style: TextStyle(color: Colors.white),
              ),
              Container(
                height: 10,
              ),
              Container(
                height: 20,
              ),
              Container(
                height: 1,
                color: Color(0xFFF1FF0A),
              ),
              Container(
                height: 30,
              ),
              InkWell(
                child: _childDrawer1(Icons.person_outlined, 'Profil', 18),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Profile()));
                },
              ),
              Container(
                height: 20,
              ),
              _childDrawer1(Icons.bookmark_border, 'Signets', 18),
              Container(
                height: 30,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFFF1FF0A),
              ),
              Container(
                height: 30,
              ),
              InkWell(
                child: _childDrawer1(Icons.logout, 'Déconnexion', 18),
                onTap: () {
                  setState(() {
                    nblisterperso = 0;
                  });
                  listperso.clear();
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Login()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _childDrawer1(IconData icon, String label, double _size) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFF1FF0A)),
        Container(
          width: 10,
        ),
        Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _size,
              color: Colors.white),
        ),
      ],
    );
  }

  Future<void> getList() async {
    if (nblisterperso == 0) {
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
            nblisterperso = 1;
          });
        }
      } else {
        print('liste11 non trouvé');
      }
    }
  }
}
