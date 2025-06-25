import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_book_screen.dart';
import 'edit_book_screen.dart';
import '../models/book.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = fetchBooks();
  }

  Future<List<Book>> fetchBooks() async {
    const String apiUrl = 'http://localhost:10000/api/books';
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  void _refreshBooks() {
    setState(() {
      _booksFuture = fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Book Library', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookScreen()),
          );
          _refreshBooks();
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Add Book',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 6,
      ),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.deepPurple));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No books available',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            );
          }

          final books = snapshot.data!;

          return ListView.separated(
            padding: EdgeInsets.all(12),
            itemCount: books.length,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                shadowColor: Colors.deepPurple.withOpacity(0.4),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  onTap: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditBookScreen(book: book)),
                    );
                    if (updated == true) {
                      _refreshBooks();
                    }
                  },
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.deepPurple.shade100,
                    child: Icon(Icons.menu_book, color: Colors.deepPurple.shade700, size: 30),
                  ),
                  title: Text(
                    book.name,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      '${book.author}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                  trailing: Text(
                    '\$${book.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}