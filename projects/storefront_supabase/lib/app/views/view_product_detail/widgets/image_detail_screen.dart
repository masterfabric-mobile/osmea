import 'package:flutter/material.dart';
import 'package:core/core.dart';

class ImageDetailScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final Function(String path) goRoute;

  const ImageDetailScreen({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    required this.goRoute,
  });

  @override
  State<ImageDetailScreen> createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                "${_currentIndex + 1} / ${widget.imageUrls.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: OsmeaComponents.image(
                imageUrl: widget.imageUrls[index],
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                placeholder: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: const Center(
                  child: Icon(Icons.broken_image, color: Colors.white, size: 50),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
