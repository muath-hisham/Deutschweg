import 'package:flutter/material.dart';

class BookPage extends StatefulWidget {
  final String folder;
  final int noPages;

  const BookPage({super.key, required this.folder, required this.noPages});

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late TransformationController _transformationController;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  void _zoomIn() {
    setState(() {
      _scale += 0.3;
      _transformationController.value = Matrix4.identity()..scale(_scale);
    });
  }

  void _zoomOut() {
    setState(() {
      _scale = (_scale - 0.3).clamp(1.0, 4.0);
      _transformationController.value = Matrix4.identity()..scale(_scale);
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InteractiveViewer(
            transformationController: _transformationController,
            minScale: 1.0,
            maxScale: 4.0,
            child: ListView.builder(
              itemCount: widget.noPages,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildImage("${index + 1}.jpg"),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _zoomIn,
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  child: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageName) {
    return Image.asset(
      "assets/books/${widget.folder}/$imageName",
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Text('Image not found'));
      },
    );
  }
}
