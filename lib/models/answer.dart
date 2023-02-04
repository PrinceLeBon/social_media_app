class Answers {
  late int id;
  late String id_user;
  late final String reponse;
  late final String date;
  Answers(this.id, this.id_user, this.reponse, this.date);

  Map<String, dynamic> toJson() => {
    'id': id,
    'id_user': id_user,
    'reponse': reponse,
    'date': date};

  static Answers fromJson(Map<String, dynamic> json) => Answers(json['id'],
      json['id_user'], json['reponse'], json['date']);
}
