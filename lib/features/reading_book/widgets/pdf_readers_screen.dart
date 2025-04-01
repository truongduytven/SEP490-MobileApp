import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_flip/page_flip.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class PDFReaderScreen extends StatefulWidget {
  final String pdfUrl;
  final String bookName;

  const PDFReaderScreen({
    super.key,
    required this.pdfUrl,
    required this.bookName,
  });

  @override
  _PDFReaderScreenState createState() => _PDFReaderScreenState();
}

class _PDFReaderScreenState extends State<PDFReaderScreen> {
  final _controller = GlobalKey<PageFlipWidgetState>();
  String? localPath;
  bool isLoading = true;
  String? errorMessage;
  int? totalPages;
  int currentPage = 0;
  bool pdfReady = false;
  List<Widget> pages = [];
  bool _isManualSwipe = false;
  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<void> loadPdf() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      if (response.statusCode != 200) {
        throw Exception("Không thể tải PDF (${response.statusCode})");
      }

      final dir = await getApplicationDocumentsDirectory();
      final file =
          File('${dir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(response.bodyBytes, flush: true);

      if (mounted) {
        setState(() {
          localPath = file.path;
        });
        await loadPdfPages();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Lỗi khi mở PDF: ${e.toString()}';
          isLoading = false;
        });
      }
    }
  }

  Future<void> loadPdfPages() async {
    try {
      final pdfDocument = await PdfDocument.openFile(localPath!);

      List<Widget> tempPages = [];
      for (int i = 0; i < pdfDocument.pageCount; i++) {
        tempPages.add(Container(
          color: Colors.white,
          child: PdfPageView(
            pdfDocument: pdfDocument,
            pageNumber: i + 1,
          ),
        ));
      }

      if (mounted) {
        setState(() {
          pages = tempPages;
          totalPages = pdfDocument.pageCount;
          isLoading = false;
          pdfReady = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error loading PDF pages: ${e.toString()}';
          isLoading = false;
        });
      }
    }
  }

  void _goToPage(int page) {
    _controller.currentState?.goToPage(page);
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookName),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          if (totalPages != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  '${currentPage + 1}/$totalPages',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : pages.isNotEmpty
                  ? Listener(
                      onPointerDown: (_) => _isManualSwipe = true,
                      onPointerUp: (_) {
                        if (_isManualSwipe) {
                          final newPage =
                              _controller.currentState?.pageNumber ??
                                  currentPage;
                          if (newPage != currentPage) {
                            setState(() {
                              currentPage = newPage;
                            });
                          }
                        }
                        _isManualSwipe = false;
                      },
                      child: PageFlipWidget(
                        key: _controller,
                        initialIndex: currentPage,
                        children: pages,
                      ),
                    )
                  : const Center(child: Text("Không thể hiển thị PDF")),
      floatingActionButton: pdfReady
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "prev",
                  mini: true,
                  child: const Icon(Icons.chevron_left),
                  onPressed: () {
                    if (currentPage > 0) {
                      _goToPage(currentPage - 1);
                    }
                  },
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  heroTag: "next",
                  mini: true,
                  child: const Icon(Icons.chevron_right),
                  onPressed: () {
                    if (currentPage < (totalPages ?? 1) - 1) {
                      _goToPage(currentPage + 1);
                    }
                  },
                ),
              ],
            )
          : null,
    );
  }
}
