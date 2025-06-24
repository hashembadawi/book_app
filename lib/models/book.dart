class Book {
  final String id;
  final String name;
  final String author;
  final double price;

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.price,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      name: json['name'],
      author: json['author'],
      price: double.tryParse(json['price'].toString()) ?? 0,
    );
  }
}