
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/pages/view_artcicle.dart';
import 'dart:io';

import '../widgets/custom_drawer.dart';
import 'login.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late File image = File('');
  late final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: CustomDrawer(),
      body: Container(
        margin: MediaQuery.of(context).padding,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('assets/1.png'),
                                fit: BoxFit.cover)),
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.mail,color: Color(0xFFF1FF0A)),
                          Container(
                            width: 10,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Text('houndjoprincelebon3@gmail.com', style: TextStyle(color: Colors.white),))
                        ],
                      ),
                      Container(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone, color: Color(0xFFF1FF0A)),
                          Container(
                            width: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: const Text('+229 62907841', style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                      Container(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.home, color: Color(0xFFF1FF0A)),
                          Container(
                            width: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: const Text('C/268 ESGIS COTONOU'),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: const Text(
                            '2010 - 2012: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.', style: TextStyle(color: Colors.white)),
                      ),
                      Container(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: const Text(
                            '2010 - 2012: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Articles()));
                  },
                  child: const Center(
                    child: Text('Consulter mes articles'),
                  )),
              ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Login()));
                  },
                  child: const Center(child: Text('Déconnexion')))
            ],
          ),
        ),
      ),
    );
  }

}
