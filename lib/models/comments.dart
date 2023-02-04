class Comments {
  late int id;
  late String id_user;
  late final String commentaire;
  late final String date;

  Comments(this.id, this.id_user, this.commentaire, this.date);

  Map<String, dynamic> toJson() =>
      {'id': id, 'id_user': id_user, 'commentaire': commentaire, 'date': date};

  static Comments fromJson(Map<String, dynamic> json) =>
      Comments(json['id'], json['id_user'], json['commentaire'], json['date']);
}
