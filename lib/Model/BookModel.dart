import 'package:http/http.dart' as http;

class BookModel {
  int id;
  String title;
  String author;
  String description;
  int copies;
  int copiesAvailable;
  String category;
  String img;

  BookModel(
      {required this.id,
      required this.title,
      required this.author,
      required this.description,
      required this.copies,
      required this.copiesAvailable,
      required this.category,
      required this.img});

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      copies: json['copies'],
      copiesAvailable: json['copiesAvailable'],
      category: json['category'],
      img: json['img'],
    );
  }
}
