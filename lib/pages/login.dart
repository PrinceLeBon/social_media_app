import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_media_app/pages/signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController1.dispose();
    myController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: MediaQuery.of(context).padding,
        child: Padding(
          padding: EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Email : ',
                          style: TextStyle(color: Colors.white)),
                      Container(
                        height: 10,
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: 13, color: Colors.white),
                        controller: myController1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail, color: Color(0xFFF1FF0A),),
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
                        height: 20,
                      ),
                      const Text('Password : ',
                          style: TextStyle(color: Colors.white)),
                      Container(
                        height: 10,
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: 13, color: Colors.white),
                        obscureText: true,
                        obscuringCharacter: '*',
                        controller: myController2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.password, color: Color(0xFFF1FF0A),),
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
                        height: 20,
                      ),
                    ],
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
                            'Se connecter',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        Connexion();
                      }
                    },
                  ),
                  Container(
                    height: 20,
                  ),
                  InkWell(
                    child: Text(
                      'Mot de passe oubi?? ?',
                      style: TextStyle(color: Color(0xFFF1FF0A)),
                    ),
                    onTap: () {
                      print('On ma tap????????');
                    },
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text('Vous n\'avez pas de compte ?',
                          style: TextStyle(color: Colors.white)),
                      Container(
                        width: 10,
                      ),
                      InkWell(
                        child: Text(
                          'Cr??ez un compte',
                          style: TextStyle(color: Color(0xFFF1FF0A)),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignUp()));
                        },
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future Connexion() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: myController1.text.trim(),
          password: myController2.text.trim());
      print('${FirebaseAuth.instance.currentUser?.uid}');
    } on FirebaseAuthException catch (e) {
      print('Echec dans la connexion : $e');
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
