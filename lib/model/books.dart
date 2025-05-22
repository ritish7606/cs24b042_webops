class Book {
  String? id;
  String? bookText;
  bool isDone;

  Book({required this.id, required this.bookText, this.isDone = false});

  static List<Book> bookList() {
    return [
      Book(id: '01', bookText: 'math', isDone: true),
      Book(id: '02', bookText: 'phy'),
    ];
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      bookText: json['bookText'],
      isDone: json['isDone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookText': bookText,
      'isDone': isDone,
    };
  }
}
