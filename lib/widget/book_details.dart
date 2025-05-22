import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/books.dart';

class BookDetails extends StatelessWidget {
  final Book book;
  final Function(Book) onBookChanged;

  const BookDetails({Key? key, required this.book, required this.onBookChanged})
    : super(key: key);

  void _launchSearch(String query) async {
    final url = 'https://www.google.com/search?q=${Uri.encodeComponent(query)}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        onTap: () => onBookChanged(book),
        leading: Icon(
          book.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.purple,
        ),
        title: Text(
          book.bookText ?? '',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            decoration: book.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.language, color: Colors.blue),
          onPressed: () => _launchSearch(book.bookText ?? ''),
        ),
      ),
    );
  }
}
