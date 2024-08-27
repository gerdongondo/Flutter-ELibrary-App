import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:libraryapp/Model/BookModel.dart';

Future<List<BookModel>> fetchBooks({String? title, String? category}) async {
  String baseUrl = 'http://10.0.2.2:8080/api/books';

  if (title != null && title.isNotEmpty) {
    baseUrl +=
        '/search/findByTitleContaining?title=${Uri.encodeComponent(title)}';
  } else if (category != null && category.isNotEmpty) {
    baseUrl +=
        '/search/findByCategory?category=${Uri.encodeComponent(category)}';
  }

  final response = await http.get(Uri.parse(baseUrl));

  print('Request URL: $baseUrl');
  print('Status code: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List<dynamic> jsonList = jsonResponse['_embedded']['books'];
    return jsonList.map((json) => BookModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load books');
  }
}
