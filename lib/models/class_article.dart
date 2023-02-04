class aaArticle {
  late String id;
  late String id_user;
  late String image;
  late final String titre;
  late final String description;
  late final String date;
  late int idd;

  aaArticle(this.id, this.id_user, this.image, this.titre, this.description,
      this.date, this.idd);

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_user': id_user,
        'image': image,
        'titre': titre,
        'description': description,
        'date': date,
        'idd': idd
      };

  static aaArticle fromJson(Map<String, dynamic> json) => aaArticle(
        json['id'],
        json['id_user'],
        json['image'],
        json['titre'],
        json['description'],
        json['date'],
        json['idd'],
      );
}
