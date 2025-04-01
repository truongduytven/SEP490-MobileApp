import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class PDFReaderScreen extends StatefulWidget {
  final String pdfUrl;
  final String bookName;

  const PDFReaderScreen({
    Key? key,
    required this.pdfUrl,
    required this.bookName,
  }) : super(key: key);

  @override
  _PDFReaderScreenState createState() => _PDFReaderScreenState();
}

class _PDFReaderScreenState extends State<PDFReaderScreen> {
  String? _localPath;
  bool _isLoading = true;
  int _totalPages = 0;
  int _currentPage = 0;
  PDFViewController? _pdfController;

  @override
  void initState() {
    super.initState();
    _loadPdf();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(
          NetworkImage(
              'https://assets-v2.lottiefiles.com/a/2913434e-ef4c-11ef-9a29-f3bb65f59573/3SXEyrksnr.gif'),
          context);
    });
  }

  Future<void> _loadPdf() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.pdf';

      final dio = Dio();
      await dio.download(widget.pdfUrl, filePath);

      setState(() {
        _localPath = filePath;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải PDF: $e')),
      );
    }
  }

  void _goToNextPage() {
    if (_pdfController != null && _currentPage < _totalPages - 1) {
      _pdfController!.setPage(_currentPage + 1);
    }
  }

  void _goToPreviousPage() {
    if (_pdfController != null && _currentPage > 0) {
      _pdfController!.setPage(_currentPage - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookName),
      ),
      body: _isLoading
          ? Center(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://assets-v2.lottiefiles.com/a/2913434e-ef4c-11ef-9a29-f3bb65f59573/3SXEyrksnr.gif',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const CircularProgressIndicator();
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.music_note, size: 100),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Đang chuẩn bị sách..',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : _localPath == null
              ? const Center(child: Text("Không thể tải sách"))
              : Column(
                  children: [
                    Expanded(
                      child: PDFView(
                        filePath: _localPath!,
                        enableSwipe: true,
                        onRender: (pages) {
                          setState(() {
                            _totalPages = pages!;
                          });
                        },
                        onViewCreated: (PDFViewController controller) {
                          _pdfController = controller;
                        },
                        onPageChanged: (int? page, int? total) {
                          setState(() {
                            _currentPage = page!;
                          });
                        },
                        onError: (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Lỗi: $error')),
                          );
                        },
                      ),
                    ),
                    // PDF Controls
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.navigate_before),
                            onPressed: _goToPreviousPage,
                          ),
                          Text(
                            '${_currentPage + 1} / $_totalPages',
                            style: TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: Icon(Icons.navigate_next),
                            onPressed: _goToNextPage,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
