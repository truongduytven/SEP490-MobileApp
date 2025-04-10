import 'package:flutter/material.dart';
import '../screens/book_detail_screen.dart';

class BookSearchDelegate extends SearchDelegate {
  final List<dynamic> books;

  BookSearchDelegate({required this.books});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = books
        .where((book) => book['bookName']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return _buildSearchResults(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? []
        : books
            .where((book) => book['bookName']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();

    return _buildSearchResults(suggestions);
  }

  Widget _buildSearchResults(List<dynamic> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return ListTile(
          leading: Image.network(
            _getBookCover(book['bookUrl']),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(book['bookName']),
          subtitle: Text(book['author'] ?? 'Không rõ tác giả'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailScreen(book: book),
              ),
            );
          },
        );
      },
    );
  }

  String _getBookCover(String pdfUrl) {
    if (!pdfUrl.toLowerCase().endsWith('.pdf')) {
      return 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60';
    }

    final imageUrl = pdfUrl
        .replaceAll('/upload/', '/upload/fl_attachment,pg_1/')
        .replaceAll('.pdf', '.jpg');
    return imageUrl;
  }
}
