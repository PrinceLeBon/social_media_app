class Bookmark {
  late String id;
  late String id_user;
  late String id_article;

  Bookmark(this.id, this.id_user, this.id_article);

  Map<String, dynamic> toJson() => {
    'id': id,
    'id_user': id_user,
    'id_article': id_article
  };

  static Bookmark fromJson(Map<String, dynamic> json) => Bookmark(
      json['id'],
      json['id_user'],
      json['id_article']
  );
}
