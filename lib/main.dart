import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libraryapp/Model/BookModel.dart';
import 'package:libraryapp/Service/api_service.dart';
import 'package:libraryapp/Pages/BookDetailPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BooksPage(),
    );
  }
}

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  late Future<List<BookModel>> futureBooks;
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks();
  }

  void searchBooks() {
    setState(() {
      futureBooks = fetchBooks(
        title: titleController.text,
        category: categoryController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        title: const Text('Niit Library'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Search by Title',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: 'Search by Category',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: searchBooks,
            child: Text('Search'),
          ),
          Expanded(
            child: FutureBuilder<List<BookModel>>(
              future: futureBooks,
              builder: (context, snapshot) {
                print('Snapshot state: ${snapshot.connectionState}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No books available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      BookModel book = snapshot.data![index];
                      print('Image URL: ${book.img}'); // Log the image URL

                      // Extract base64 data
                      final String base64Data = book.img.split(',')[1];

                      // Decode base64 string to Uint8List
                      Uint8List bytes = base64Decode(base64Data);

                      return ListTile(
                        leading: SizedBox(
                          width: 100,
                          height: 150,
                          child: Image.memory(
                            bytes,
                            fit: BoxFit.contain,
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return Icon(Icons.error);
                            },
                          ),
                        ),
                        title: Text(book.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('by ${book.author}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailPage(book: book),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
