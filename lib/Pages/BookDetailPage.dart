import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:libraryapp/Model/BookModel.dart';

class BookDetailPage extends StatelessWidget {
  final BookModel book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract base64 data
    final String base64Data = book.img.split(',')[1];

    // Decode base64 string to Uint8List
    Uint8List bytes = base64Decode(base64Data);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        title: const Text('Niit Library'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.memory(
                bytes,
                fit: BoxFit.contain,
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Icon(Icons.error);
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              book.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'by ${book.author}',
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16),
            Text(
              book.description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
