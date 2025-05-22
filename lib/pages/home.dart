import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/book_details.dart';
import '../model/books.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> booksList = [];
  final TextEditingController _bookController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? booksJson = prefs.getString('books');
    if (booksJson != null) {
      final List<dynamic> decoded = json.decode(booksJson);
      setState(() {
        booksList = decoded.map((item) => Book.fromJson(item)).toList();
      });
    } else {
      booksList = Book.bookList(); // Load initial demo list
    }
  }

  void _saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(
      booksList.map((b) => b.toJson()).toList(),
    );
    await prefs.setString('books', encoded);
  }

  void _handleBookChange(Book book) {
    setState(() {
      book.isDone = !book.isDone;
    });
    _saveBooks();
  }

  void _addBook() {
    final text = _bookController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        booksList.add(Book(id: DateTime.now().toString(), bookText: text));
        _bookController.clear();
      });
      _saveBooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reading list',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 219, 218, 218),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MY BOOKS',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.filter_list),
                ],
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView(
                children: [
                  for (Book boook in booksList)
                    BookDetails(book: boook, onBookChanged: _handleBookChange),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _bookController,
                      decoration: InputDecoration(
                        hintText: 'Enter book name',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(onPressed: _addBook, child: Text("Add Book")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
