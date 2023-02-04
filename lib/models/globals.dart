
import 'package:flutter/cupertino.dart';
import 'package:social_media_app/models/user.dart';
import 'class_article.dart';
import 'comments.dart';

List<aaArticle> listArticle = [];
List<Comments> listComments = [];
List<aaArticle> listperso = [];
int nblisterperso = 0;
List<aaArticle> ArticleLiked = [];
List<aaArticle> listSignet = [];

int keyboard = 1;
FocusNode focusNode = FocusNode();

Comments globalComment = Comments(0, 'id_user', '', 'date');

Users currentUser = Users(
    'id', 'nom', 'prenom', 'photo', 'date_de_naissance', 'username', 'email');
//DateFormat('yyyy-MM-dd H:m:s')
