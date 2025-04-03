import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookReaderScreen extends StatefulWidget {
  final dynamic book;

  const BookReaderScreen({super.key, required this.book});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  double _fontSize = 16.0;
  bool _isDarkMode = false;
  int _currentPage = 1;
  double _lineSpacing = 1.8;
  String _fontFamily = 'Roboto';
  double _scrollOffset = 0.0;
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _highlights = [];
  final List<Map<String, dynamic>> _chapters = [];
  late Future<String> _bookContent;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _bookContent = fetchBookContent(widget.book['key']);
    _loadSettings();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _lineSpacing = prefs.getDouble('lineSpacing') ?? 1.8;
      _fontFamily = prefs.getString('fontFamily') ?? 'Roboto';
      _scrollOffset =
          prefs.getDouble('${widget.book['key']}_scrollOffset') ?? 0.0;
      _highlights = (jsonDecode(
                  prefs.getString('${widget.book['key']}_highlights') ?? '[]')
              as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    });
    if (_scrollOffset > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollOffset);
      });
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontSize', _fontSize);
    prefs.setBool('isDarkMode', _isDarkMode);
    prefs.setDouble('lineSpacing', _lineSpacing);
    prefs.setString('fontFamily', _fontFamily);
    prefs.setDouble('${widget.book['key']}_scrollOffset', _scrollOffset);
    prefs.setString(
        '${widget.book['key']}_highlights', jsonEncode(_highlights));
  }

  Future<String> fetchBookContent(String key) async {
    try {
      // Step 1: Fetch book metadata from Open Library
      final metadataUrl = 'https://openlibrary.org$key.json';
      final metadataResponse = await http.get(Uri.parse(metadataUrl));
      if (metadataResponse.statusCode != 200) {
        return 'Error fetching metadata.';
      }
      final metadata = json.decode(metadataResponse.body);

      // Step 2: Check if the book is available in the public domain
      // Open Library links to Internet Archive or Gutenberg for full text
      if (metadata['ocaid'] != null) {
        // Internet Archive ID exists, try fetching from there
        final archiveUrl =
            'https://archive.org/download/${metadata['ocaid']}/${metadata['ocaid']}.txt';
        final archiveResponse = await http.get(Uri.parse(archiveUrl));
        if (archiveResponse.statusCode == 200) {
          final text = archiveResponse.body;
          _parseChapters(text);
          return text;
        }
      }

      // Step 3: Try Project Gutenberg via Open Library's identifiers
      final identifiers = metadata['identifiers'] ?? {};
      final gutenbergId = identifiers['gutenberg']?.first;
      if (gutenbergId != null) {
        final gutenbergUrl =
            'https://www.gutenberg.org/cache/epub/$gutenbergId/pg$gutenbergId.txt';
        final gutenbergResponse = await http.get(Uri.parse(gutenbergUrl));
        if (gutenbergResponse.statusCode == 200) {
          final text = gutenbergResponse.body;
          _parseChapters(text);
          return text;
        }
      }

      // If no full text is available
      return 'This book is not available for reading in full text through Open Library. It may be under copyright or not digitized. Please check Open Library or a library service for access.';
    } catch (e) {
      return 'Error fetching book content: $e';
    }
  }

  void _parseChapters(String text) {
    final lines = text.split('\n');
    _chapters.clear();
    int chapterCount = 0;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].trim().toLowerCase().startsWith('chapter')) {
        chapterCount++;
        _chapters.add({
          'title': lines[i].trim(),
          'offset': _scrollController.position.maxScrollExtent *
              (i / lines.length), // Approximate offset
        });
      }
    }
    setState(() {
      _totalPages =
          (chapterCount > 0 ? chapterCount : 1) * 10; // Rough estimate
    });
  }

  void _addHighlight(String selectedText, int start, int end) {
    setState(() {
      _highlights.add({
        'text': selectedText,
        'start': start,
        'end': end,
        'color': Colors.yellow.value,
      });
      _saveSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.book["title"] ?? "Unknown Title";
    final String author =
        (widget.book["authors"] != null && widget.book["authors"].isNotEmpty)
            ? widget.book["authors"][0]["name"]
            : "Unknown Author";
    final String coverId = widget.book["cover_id"]?.toString() ?? "";
    final String imageUrl = coverId.isNotEmpty
        ? "https://covers.openlibrary.org/b/id/$coverId-M.jpg"
        : "https://via.placeholder.com/150";

    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        backgroundColor:
            _isDarkMode ? Colors.grey[850] : Colors.deepPurple[700],
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
                _saveSettings();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              _saveSettings();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bookmark Saved')),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'fontSize', child: Text('Font Size')),
              const PopupMenuItem(
                  value: 'fontFamily', child: Text('Font Family')),
              const PopupMenuItem(
                  value: 'lineSpacing', child: Text('Line Spacing')),
              const PopupMenuItem(
                  value: 'toc', child: Text('Table of Contents')),
            ],
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: _isDarkMode ? Colors.grey[850] : Colors.deepPurple[50],
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 60,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.book),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode
                              ? Colors.white
                              : Colors.deepPurple[900],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'by $author',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              _isDarkMode ? Colors.grey[400] : Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<String>(
              future: _bookContent,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final text = snapshot.data ?? 'No content available.';
                return GestureDetector(
                  onLongPress: () {
                    final selection = _getTextSelection(context, text);
                    if (selection != null) {
                      _showHighlightDialog(selection);
                    }
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    child: RichText(
                      text: _buildHighlightedText(text),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: _isDarkMode ? Colors.grey[850] : Colors.deepPurple[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: _isDarkMode ? Colors.white : Colors.deepPurple[700],
                  onPressed: _currentPage > 1
                      ? () {
                          setState(() {
                            _currentPage--;
                            _scrollController.animateTo(
                              (_currentPage - 1) *
                                  _scrollController.position.maxScrollExtent /
                                  _totalPages,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          });
                        }
                      : null,
                ),
                Text(
                  'Page $_currentPage of $_totalPages',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDarkMode ? Colors.white : Colors.deepPurple[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: _isDarkMode ? Colors.white : Colors.deepPurple[700],
                  onPressed: _currentPage < _totalPages
                      ? () {
                          setState(() {
                            _currentPage++;
                            _scrollController.animateTo(
                              (_currentPage - 1) *
                                  _scrollController.position.maxScrollExtent /
                                  _totalPages,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          });
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'fontSize':
        _showFontSizeDialog();
        break;
      case 'fontFamily':
        _showFontFamilyDialog();
        break;
      case 'lineSpacing':
        _showLineSpacingDialog();
        break;
      case 'toc':
        _showTableOfContents();
        break;
    }
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Font Size'),
        content: Slider(
          value: _fontSize,
          min: 12.0,
          max: 24.0,
          divisions: 6,
          label: _fontSize.toString(),
          onChanged: (value) {
            setState(() {
              _fontSize = value;
              _saveSettings();
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFontFamilyDialog() {
    final fonts = ['Roboto', 'Serif', 'Sans', 'Monospace'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Font Family'),
        content: SingleChildScrollView(
          child: Column(
            children: fonts
                .map((font) => RadioListTile<String>(
                      title: Text(font),
                      value: font,
                      groupValue: _fontFamily,
                      onChanged: (value) {
                        setState(() {
                          _fontFamily = value!;
                          _saveSettings();
                        });
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  void _showLineSpacingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Line Spacing'),
        content: Slider(
          value: _lineSpacing,
          min: 1.2,
          max: 2.4,
          divisions: 6,
          label: _lineSpacing.toStringAsFixed(1),
          onChanged: (value) {
            setState(() {
              _lineSpacing = value;
              _saveSettings();
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTableOfContents() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _chapters.length,
        itemBuilder: (context, index) {
          final chapter = _chapters[index];
          return ListTile(
            title: Text(chapter['title']),
            onTap: () {
              setState(() {
                _scrollController.animateTo(
                  chapter['offset'],
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                _currentPage = (index + 1) * 10; // Rough page estimate
              });
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  TextSelection? _getTextSelection(BuildContext context, String text) {
    final renderObject = context.findRenderObject() as RenderBox?;
    if (renderObject == null) return null;
    final position = _scrollController.position;
    final textSpan = _buildHighlightedText(text);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 40);
    final offset =
        renderObject.globalToLocal(position.viewportDimension as Offset);
    final selection = textPainter.getPositionForOffset(offset);
    return TextSelection(
        baseOffset: selection.offset - 10, extentOffset: selection.offset + 10);
  }

  void _showHighlightDialog(TextSelection selection) {
    final text = (_bookContent).then((value) =>
        value.substring(selection.baseOffset, selection.extentOffset));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Highlight'),
        content: FutureBuilder<String>(
          future: text,
          builder: (context, snapshot) => Text(snapshot.data ?? ''),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              text.then((selectedText) {
                _addHighlight(
                    selectedText, selection.baseOffset, selection.extentOffset);
              });
              Navigator.pop(context);
            },
            child: const Text('Highlight'),
          ),
        ],
      ),
    );
  }

  TextSpan _buildHighlightedText(String text) {
    List<TextSpan> spans = [];
    int lastEnd = 0;
    for (var highlight in _highlights
      ..sort((a, b) => a['start'].compareTo(b['start']))) {
      if (highlight['start'] > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, highlight['start']),
          style: TextStyle(
            fontSize: _fontSize,
            height: _lineSpacing,
            letterSpacing: 0.3,
            color: _isDarkMode ? Colors.grey[200] : Colors.grey[800],
            fontFamily: _fontFamily,
          ),
        ));
      }
      spans.add(TextSpan(
        text: text.substring(highlight['start'], highlight['end']),
        style: TextStyle(
          fontSize: _fontSize,
          height: _lineSpacing,
          letterSpacing: 0.3,
          color: _isDarkMode ? Colors.black : Colors.black,
          backgroundColor: Color(highlight['color']),
          fontFamily: _fontFamily,
        ),
      ));
      lastEnd = highlight['end'];
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: TextStyle(
          fontSize: _fontSize,
          height: _lineSpacing,
          letterSpacing: 0.3,
          color: _isDarkMode ? Colors.grey[200] : Colors.grey[800],
          fontFamily: _fontFamily,
        ),
      ));
    }
    return TextSpan(children: spans);
  }
}
