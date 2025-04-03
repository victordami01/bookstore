class Book {
  final String title;
  final String author;
  final String coverUrl;
  final String description;
  final String genre;
  final double rating;
  final int pages;

  Book({
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.description,
    required this.genre,
    required this.rating,
    required this.pages,
  });

  // factory Book.fromJson(Map<String, dynamic> json) {
  //   final coverId = json["cover_id"] ?? json["cover_i"];
  //   final imageUrl = coverId != null
  //       ? "https://covers.openlibrary.org/b/id/$coverId-M.jpg"
  //       : "https://via.placeholder.com/150";

  //   return Book(
  //     title: json["title"] ?? "Unknown Title",
  //     author: (json["authors"] != null && json["authors"].isNotEmpty)
  //         ? json["authors"][0]["name"]
  //         : "Unknown Author",
  //     imageUrl: imageUrl,
  //     price: 10.99, // Placeholder price, update if needed
  //     rating: 4.0, // Placeholder rating, update if needed
  //   );
  // }
}