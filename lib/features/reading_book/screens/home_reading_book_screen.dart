import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sep490/features/reading_book/widgets/book_search_delegate.dart';
import 'package:sep490/theme/color.dart';
import 'dart:convert';
import 'book_detail_screen.dart';

class HomeReadingBookScreen extends StatefulWidget {
  const HomeReadingBookScreen({super.key});

  @override
  State<HomeReadingBookScreen> createState() => _HomeReadingBookScreenState();
}

class _HomeReadingBookScreenState extends State<HomeReadingBookScreen> {
  List<dynamic> books = [];
  List<dynamic> filteredBooks = [];
  bool isLoading = true;
  String errorMessage = '';
  String searchQuery = '';
  String? selectedCategory;
  List<String> categories = ['Tất cả'];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.diavan-valuation.asia/content-management/all-book'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          final activeBooks = (data['data'] as List)
              .where((book) => book['status'] == 'Active')
              .toList();

          final uniqueCategories = activeBooks
              .map((book) => book['bookType']?.toString() ?? 'Khác')
              .toSet()
              .toList();

          setState(() {
            books = activeBooks;
            filteredBooks = activeBooks;
            categories = ['Tất cả']..addAll(uniqueCategories);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = data['message'] ?? 'Failed to load books';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load books: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  void filterBooks() {
    List<dynamic> result = books;

    if (selectedCategory != null && selectedCategory != 'Tất cả') {
      result =
          result.where((book) => book['bookType'] == selectedCategory).toList();
    }

    if (searchQuery.isNotEmpty) {
      result = result
          .where((book) => book['bookName']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredBooks = result;
    });
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
    filterBooks();
  }

  void onCategorySelected(String? category) {
    setState(() {
      selectedCategory = category;
    });
    filterBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // appBar: AppBar(
      //   title: const Text('Thư Viện Sách ',
      //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      //   centerTitle: true,
      //   elevation: 0,
      // ),
      appBar: AppBar(
        title: const Text('Thư Viện Sách',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange[100]!, Colors.pink[200]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 50, color: Colors.red[400]),
                      const SizedBox(height: 20),
                      Text(errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: fetchBooks,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Thử lại',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : books.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.menu_book, size: 50, color: Colors.grey),
                          SizedBox(height: 20),
                          Text('Không có sách nào',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 10),
                          Text('Hãy quay lại sau khi có sách mới',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchBooks,
                      child: CustomScrollView(
                        slivers: [
                          // Header mới với hình ảnh bắt mắt
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            expandedHeight: 200,
                            stretch: true,
                            flexibleSpace: FlexibleSpaceBar(
                              stretchModes: const [
                                StretchMode.zoomBackground,
                                StretchMode.blurBackground,
                              ],
                              background: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    'https://images.unsplash.com/photo-1507842217343-583bb7270b66?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
                                    fit: BoxFit.cover,
                                    color: Colors.black.withOpacity(0.6),
                                    colorBlendMode: BlendMode.darken,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.7),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Khám phá thư viện sách điện tử',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Những đầu sách chất lượng đang chờ bạn',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Icon(Icons.star,
                                                color: Colors.amber, size: 20),
                                            SizedBox(width: 4),
                                            Text('Sách mới cập nhật hàng tuần',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Phần search và category
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Tìm kiếm sách...',
                                      prefixIcon: const Icon(Icons.search,
                                          color: Colors.grey),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 14),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.grey[300]!),
                                      ),
                                    ),
                                    onChanged: onSearch,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    children: categories.map((category) {
                                      return _buildCategoryChip(
                                        category,
                                        selectedCategory == category ||
                                            (selectedCategory == null &&
                                                category == 'Tất cả'),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Tìm thấy ${filteredBooks.length} sách',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Grid sách
                          SliverPadding(
                            padding: const EdgeInsets.all(16),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.6,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final book = filteredBooks[index];
                                  return BookCard(book: book);
                                },
                                childCount: filteredBooks.length,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
      // : Column(
      //     children: [
      //       Container(
      //         padding: const EdgeInsets.all(16),
      //         decoration: BoxDecoration(
      //           color: AppColors.primaryColor,
      //           borderRadius: const BorderRadius.only(
      //             bottomLeft: Radius.circular(16),
      //             bottomRight: Radius.circular(16),
      //           ),
      //         ),
      //         child: const Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               'Khám phá thư viện sách điện tử',
      //               style: TextStyle(
      //                   fontSize: 18,
      //                   fontWeight: FontWeight.bold,
      //                   color: Colors.white),
      //             ),
      //             SizedBox(height: 8),
      //             Text(
      //               'Khám phá các đầu sách chất lượng về nhiều lĩnh vực khác nhau. Đọc mọi lúc, mọi nơi!',
      //               style: TextStyle(
      //                   fontSize: 14, color: Colors.white70),
      //             ),
      //           ],
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.symmetric(
      //             horizontal: 16, vertical: 12),
      //         child: TextField(
      //           decoration: InputDecoration(
      //             hintText: 'Tìm kiếm sách...',
      //             prefixIcon:
      //                 const Icon(Icons.search, color: Colors.grey),
      //             filled: true,
      //             fillColor: Colors.white,
      //             border: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(12),
      //               borderSide: BorderSide.none,
      //             ),
      //             contentPadding:
      //                 const EdgeInsets.symmetric(vertical: 14),
      //             enabledBorder: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(12),
      //               borderSide:
      //                   BorderSide(color: Colors.grey[300]!),
      //             ),
      //           ),
      //           onChanged: onSearch,
      //         ),
      //       ),
      //       SizedBox(
      //         height: 50,
      //         child: ListView(
      //           scrollDirection: Axis.horizontal,
      //           padding: const EdgeInsets.symmetric(horizontal: 16),
      //           children: categories.map((category) {
      //             return _buildCategoryChip(
      //               category,
      //               selectedCategory == category ||
      //                   (selectedCategory == null &&
      //                       category == 'Tất cả'),
      //             );
      //           }).toList(),
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 16),
      //         child: Align(
      //           alignment: Alignment.centerLeft,
      //           child: Text(
      //             'Tìm thấy ${filteredBooks.length} sách',
      //             style: TextStyle(
      //               color: Colors.grey[600],
      //               fontSize: 14,
      //             ),
      //           ),
      //         ),
      //       ),
      //       Flexible(
      //         child: RefreshIndicator(
      //           onRefresh: fetchBooks,
      //           child: CustomScrollView(
      //             slivers: [
      //               SliverPadding(
      //                 padding: const EdgeInsets.all(16),
      //                 sliver: SliverGrid(
      //                   gridDelegate:
      //                       const SliverGridDelegateWithFixedCrossAxisCount(
      //                     crossAxisCount: 2,
      //                     crossAxisSpacing: 16,
      //                     mainAxisSpacing: 16,
      //                     childAspectRatio: 0.6,
      //                   ),
      //                   delegate: SliverChildBuilderDelegate(
      //                     (context, index) {
      //                       final book = filteredBooks[index];
      //                       return BookCard(book: book);
      //                     },
      //                     childCount: filteredBooks.length,
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
    );
  }

  Widget _buildCategoryChip(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        checkmarkColor: Colors.white,
        label: Text(label),
        selected: isActive,
        selectedColor: AppColors.primaryColor,
        labelStyle: TextStyle(
          color: isActive ? Colors.white : Colors.black,
        ),
        onSelected: (selected) {
          onCategorySelected(selected ? label : 'Tất cả');
        },
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final dynamic book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailScreen(book: book),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh bìa sách
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              _getBookCover(book['bookUrl']),
              height: 200,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.book, size: 50, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Tên sách
          Text(
            book['bookName'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Tác giả
          Text(
            book['author'] ?? 'Không rõ tác giả',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
